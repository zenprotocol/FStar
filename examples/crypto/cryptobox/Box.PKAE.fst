(**
This is the top level module for the hybrid encryption example. The structure of the example is as follows.

  * Box.AE contains the relevant functions for authenticated encryption, including leaking of plaintext and coersion of keys.
    Its encryption/decryption function contain calls to the concrete functions in CoreCrypto.
  * Box.PKE contains the relevant functions for CCA-secure public-key encryption. Its encryption/decryption functions contain calls to Box.RSA.
  * Box.Flags contains the flags controlling the idealization of modules depending on the assumptions on underlying cryptographic primitives.
  * Box.PlainAE contains functions to convert abstract types to concrete types and the other way around for symmetric encryption content.
  * Box.PlainPKE fulfills the same role as Box.Plain but for public-key encryption.
  * Box.RSA contains references to external functions implementing the actual functionality. However, these do currently not exist.

The cryptographic keys are stored in memory in the following manner. Beneath the memory root, the public key as used in CCA2 is stored.
As children of the public key, each private key (honest and dishonest) live in their own memory regions.

TODO: 
   * Actually structure the memory layout that way.
   * Investigate where the secret key is actually stored.
   * Figure out, why the precondition in Box.AE.encrypt is not met. (recall <-> m_contains...)
   * Sketch overall proof structure
*)
module Box.PKAE

open Platform.Bytes
open FStar.HyperHeap
open FStar.HyperStack
open Box.Flags
open Box.AE
open Box.DH
open Box.PlainPKAE
open Box.PlainAE
open Box.PlainDH
open Box.Indexing

module B = Platform.Bytes

type rid = FStar.Monotonic.Seq.rid

(**
   The PKAE key types contain a region in which they live, as well as the concrete PKE key
   that is used for the encryption/decryption. The secret key is abstract.
*)
noeq abstract type pkae_pkey (pk_id:id) =
  | PKey: #region:rid -> dh_pk:dh_pkey{dh_pk.pk_i=pk_id} -> pkae_pkey pk_id

noeq abstract type pkae_skey (sk_id:id) =
  | SKey: dh_sk:dh_skey -> pkae_pk:pkae_pkey sk_id -> pkae_skey sk_id

val keygen: #(i:id) -> rid -> St (pkae_pkey i * pkae_skey i)
let keygen #i (parent:rid) =
  let (dh_pk, dh_sk) = DH.keygen #i parent in
  let region = new_region parent in
  let pkae_pk = PKey #i #region dh_pk in
  pkae_pk, SKey #i dh_sk pkae_pk

(**
   The ciphertext of PKAE consists of a PKE ciphertext (containing the ephemeral AE key)
   and an AE ciphertext containing said key.
*)
type c = DH.dh_share * AE.cipher //lbytes(PKE.ciphersize + AE.ciphersize)


(**
   For every new message we encrypt, we generate a new id. If that
   id is honest (which is only possible if pke is idealized), then
   we encrypt the protected_pkae_plain. Else we strip it of its 
   protection and encrypt the plain representation.
*)
val encrypt: #(pk_i:id) -> #(eph_i:id)-> pkae_pkey pk_i -> p:protected_pkae_plain{PlainPKAE.get_index p = (pk_i,eph_i)} -> St c 
let encrypt #pk_i #eph_i pk p =
  let region = new_region pk.region in
  let eph_dh_pk,eph_dh_sk = DH.keygen #eph_i region in
  let k = prf_odh_snd eph_dh_sk pk.dh_pk in
  let ae_i = pk_i,eph_i in
  assert (DH.get_index eph_dh_sk = snd ae_i);
  assert (pk.dh_pk.pk_i = fst ae_i);
  assert (DH.get_index eph_dh_sk = eph_i);
  assert (pk.dh_pk.pk_i = pk_i);
  assert (ae_i = (pk_i,eph_i));
  let ae_m = ae_message_wrap #ae_i p in
  //let dh_m = dh_message_wrap #pk.i eph_dh_pk.rawpk in
  eph_dh_pk.rawpk,(AE.encrypt #ae_i k ae_m)


val decrypt: #(sk_i:id) -> pkae_skey sk_i -> #(pk_i:id) -> pkae_pkey sk_i -> c -> St(option (p:protected_pkae_plain))//{fst (PlainPKAE.get_index p) = sk_i })
let decrypt #sk_i sk #pk_i pk c =
  let (dh_sh,ae_c) = c in 
  let k = prf_odh_rcv #sk_i sk.dh_sk #pk_i pk.dh_pk  in
  let ae_i = AE.get_index k in
  (match AE.decrypt #ae_i k ae_c with
  | Some p -> 
    let p' = (PlainAE.ae_message_unwrap #ae_i p) in 
    Some p'
  | None -> None)
