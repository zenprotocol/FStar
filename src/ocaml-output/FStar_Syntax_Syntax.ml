open Prims
type ('a,'t) withinfo_t = {
  v: 'a;
  ty: 't;
  p: FStar_Range.range;}
type 't var = (FStar_Ident.lident,'t) withinfo_t
type sconst = FStar_Const.sconst
type pragma =
  | SetOptions of Prims.string
  | ResetOptions of Prims.string option
  | LightOff
let uu___is_SetOptions: pragma -> Prims.bool =
  fun projectee  ->
    match projectee with | SetOptions _0 -> true | uu____86 -> false
let __proj__SetOptions__item___0: pragma -> Prims.string =
  fun projectee  -> match projectee with | SetOptions _0 -> _0
let uu___is_ResetOptions: pragma -> Prims.bool =
  fun projectee  ->
    match projectee with | ResetOptions _0 -> true | uu____99 -> false
let __proj__ResetOptions__item___0: pragma -> Prims.string option =
  fun projectee  -> match projectee with | ResetOptions _0 -> _0
let uu___is_LightOff: pragma -> Prims.bool =
  fun projectee  ->
    match projectee with | LightOff  -> true | uu____113 -> false
type 'a memo = 'a option FStar_ST.ref
type version = {
  major: Prims.int;
  minor: Prims.int;}
type arg_qualifier =
  | Implicit of Prims.bool
  | Equality
let uu___is_Implicit: arg_qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Implicit _0 -> true | uu____143 -> false
let __proj__Implicit__item___0: arg_qualifier -> Prims.bool =
  fun projectee  -> match projectee with | Implicit _0 -> _0
let uu___is_Equality: arg_qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Equality  -> true | uu____154 -> false
type aqual = arg_qualifier option
type universe =
  | U_zero
  | U_succ of universe
  | U_max of universe Prims.list
  | U_bvar of Prims.int
  | U_name of FStar_Ident.ident
  | U_unif of (universe option FStar_Unionfind.p_uvar* version)
  | U_unknown
let uu___is_U_zero: universe -> Prims.bool =
  fun projectee  ->
    match projectee with | U_zero  -> true | uu____184 -> false
let uu___is_U_succ: universe -> Prims.bool =
  fun projectee  ->
    match projectee with | U_succ _0 -> true | uu____189 -> false
let __proj__U_succ__item___0: universe -> universe =
  fun projectee  -> match projectee with | U_succ _0 -> _0
let uu___is_U_max: universe -> Prims.bool =
  fun projectee  ->
    match projectee with | U_max _0 -> true | uu____202 -> false
let __proj__U_max__item___0: universe -> universe Prims.list =
  fun projectee  -> match projectee with | U_max _0 -> _0
let uu___is_U_bvar: universe -> Prims.bool =
  fun projectee  ->
    match projectee with | U_bvar _0 -> true | uu____217 -> false
let __proj__U_bvar__item___0: universe -> Prims.int =
  fun projectee  -> match projectee with | U_bvar _0 -> _0
let uu___is_U_name: universe -> Prims.bool =
  fun projectee  ->
    match projectee with | U_name _0 -> true | uu____229 -> false
let __proj__U_name__item___0: universe -> FStar_Ident.ident =
  fun projectee  -> match projectee with | U_name _0 -> _0
let uu___is_U_unif: universe -> Prims.bool =
  fun projectee  ->
    match projectee with | U_unif _0 -> true | uu____245 -> false
let __proj__U_unif__item___0:
  universe -> (universe option FStar_Unionfind.p_uvar* version) =
  fun projectee  -> match projectee with | U_unif _0 -> _0
let uu___is_U_unknown: universe -> Prims.bool =
  fun projectee  ->
    match projectee with | U_unknown  -> true | uu____268 -> false
type univ_name = FStar_Ident.ident
type universe_uvar = (universe option FStar_Unionfind.p_uvar* version)
type univ_names = univ_name Prims.list
type universes = universe Prims.list
type monad_name = FStar_Ident.lident
type delta_depth =
  | Delta_constant
  | Delta_defined_at_level of Prims.int
  | Delta_equational
  | Delta_abstract of delta_depth
let uu___is_Delta_constant: delta_depth -> Prims.bool =
  fun projectee  ->
    match projectee with | Delta_constant  -> true | uu____286 -> false
let uu___is_Delta_defined_at_level: delta_depth -> Prims.bool =
  fun projectee  ->
    match projectee with
    | Delta_defined_at_level _0 -> true
    | uu____291 -> false
let __proj__Delta_defined_at_level__item___0: delta_depth -> Prims.int =
  fun projectee  -> match projectee with | Delta_defined_at_level _0 -> _0
let uu___is_Delta_equational: delta_depth -> Prims.bool =
  fun projectee  ->
    match projectee with | Delta_equational  -> true | uu____302 -> false
let uu___is_Delta_abstract: delta_depth -> Prims.bool =
  fun projectee  ->
    match projectee with | Delta_abstract _0 -> true | uu____307 -> false
let __proj__Delta_abstract__item___0: delta_depth -> delta_depth =
  fun projectee  -> match projectee with | Delta_abstract _0 -> _0
type term' =
  | Tm_bvar of bv
  | Tm_name of bv
  | Tm_fvar of fv
  | Tm_uinst of ((term',term') syntax* universes)
  | Tm_constant of sconst
  | Tm_type of universe
  | Tm_abs of ((bv* aqual) Prims.list* (term',term') syntax*
  (lcomp,(FStar_Ident.lident* cflags Prims.list)) FStar_Util.either option)
  | Tm_arrow of ((bv* aqual) Prims.list* (comp',Prims.unit) syntax)
  | Tm_refine of (bv* (term',term') syntax)
  | Tm_app of ((term',term') syntax* ((term',term') syntax* aqual)
  Prims.list)
  | Tm_match of ((term',term') syntax* ((pat',term') withinfo_t*
  (term',term') syntax option* (term',term') syntax) Prims.list)
  | Tm_ascribed of ((term',term') syntax*
  (((term',term') syntax,(comp',Prims.unit) syntax) FStar_Util.either*
  (term',term') syntax option)* FStar_Ident.lident option)
  | Tm_let of ((Prims.bool* letbinding Prims.list)* (term',term') syntax)
  | Tm_uvar of (((term',term') syntax option FStar_Unionfind.p_uvar*
  version)* (term',term') syntax)
  | Tm_delayed of
  ((((term',term') syntax* (subst_elt Prims.list Prims.list*
      FStar_Range.range option)),Prims.unit -> (term',term') syntax)
  FStar_Util.either* (term',term') syntax memo)
  | Tm_meta of ((term',term') syntax* metadata)
  | Tm_unknown
and pat' =
  | Pat_constant of sconst
  | Pat_cons of (fv* ((pat',term') withinfo_t* Prims.bool) Prims.list)
  | Pat_var of bv
  | Pat_wild of bv
  | Pat_dot_term of (bv* (term',term') syntax)
and letbinding =
  {
  lbname: (bv,fv) FStar_Util.either;
  lbunivs: univ_name Prims.list;
  lbtyp: (term',term') syntax;
  lbeff: FStar_Ident.lident;
  lbdef: (term',term') syntax;}
and comp_typ =
  {
  comp_univs: universes;
  effect_name: FStar_Ident.lident;
  result_typ: (term',term') syntax;
  effect_args: ((term',term') syntax* aqual) Prims.list;
  flags: cflags Prims.list;}
and comp' =
  | Total of ((term',term') syntax* universe option)
  | GTotal of ((term',term') syntax* universe option)
  | Comp of comp_typ
and cflags =
  | TOTAL
  | MLEFFECT
  | RETURN
  | PARTIAL_RETURN
  | SOMETRIVIAL
  | LEMMA
  | CPS
  | DECREASES of (term',term') syntax
and metadata =
  | Meta_pattern of ((term',term') syntax* aqual) Prims.list Prims.list
  | Meta_named of FStar_Ident.lident
  | Meta_labeled of (Prims.string* FStar_Range.range* Prims.bool)
  | Meta_desugared of meta_source_info
  | Meta_monadic of (monad_name* (term',term') syntax)
  | Meta_monadic_lift of (monad_name* monad_name* (term',term') syntax)
and meta_source_info =
  | Data_app
  | Sequence
  | Primop
  | Masked_effect
  | Meta_smt_pat
  | Mutable_alloc
  | Mutable_rval
and fv_qual =
  | Data_ctor
  | Record_projector of (FStar_Ident.lident* FStar_Ident.ident)
  | Record_ctor of (FStar_Ident.lident* FStar_Ident.ident Prims.list)
and subst_elt =
  | DB of (Prims.int* bv)
  | NM of (bv* Prims.int)
  | NT of (bv* (term',term') syntax)
  | UN of (Prims.int* universe)
  | UD of (univ_name* Prims.int)
and ('a,'b) syntax =
  {
  n: 'a;
  tk: 'b memo;
  pos: FStar_Range.range;
  vars: free_vars memo;}
and bv =
  {
  ppname: FStar_Ident.ident;
  index: Prims.int;
  sort: (term',term') syntax;}
and fv =
  {
  fv_name: (term',term') syntax var;
  fv_delta: delta_depth;
  fv_qual: fv_qual option;}
and free_vars =
  {
  free_names: bv FStar_Util.set;
  free_uvars:
    (((term',term') syntax option FStar_Unionfind.p_uvar* version)*
      (term',term') syntax) FStar_Util.set;
  free_univs: universe_uvar FStar_Util.set;
  free_univ_names: univ_name FStar_Util.fifo_set;}
and lcomp =
  {
  eff_name: FStar_Ident.lident;
  res_typ: (term',term') syntax;
  cflags: cflags Prims.list;
  comp: Prims.unit -> (comp',Prims.unit) syntax;}
let uu___is_Tm_bvar: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tm_bvar _0 -> true | uu____810 -> false
let __proj__Tm_bvar__item___0: term' -> bv =
  fun projectee  -> match projectee with | Tm_bvar _0 -> _0
let uu___is_Tm_name: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tm_name _0 -> true | uu____822 -> false
let __proj__Tm_name__item___0: term' -> bv =
  fun projectee  -> match projectee with | Tm_name _0 -> _0
let uu___is_Tm_fvar: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tm_fvar _0 -> true | uu____834 -> false
let __proj__Tm_fvar__item___0: term' -> fv =
  fun projectee  -> match projectee with | Tm_fvar _0 -> _0
let uu___is_Tm_uinst: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tm_uinst _0 -> true | uu____850 -> false
let __proj__Tm_uinst__item___0: term' -> ((term',term') syntax* universes) =
  fun projectee  -> match projectee with | Tm_uinst _0 -> _0
let uu___is_Tm_constant: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tm_constant _0 -> true | uu____874 -> false
let __proj__Tm_constant__item___0: term' -> sconst =
  fun projectee  -> match projectee with | Tm_constant _0 -> _0
let uu___is_Tm_type: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tm_type _0 -> true | uu____886 -> false
let __proj__Tm_type__item___0: term' -> universe =
  fun projectee  -> match projectee with | Tm_type _0 -> _0
let uu___is_Tm_abs: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tm_abs _0 -> true | uu____912 -> false
let __proj__Tm_abs__item___0:
  term' ->
    ((bv* aqual) Prims.list* (term',term') syntax*
      (lcomp,(FStar_Ident.lident* cflags Prims.list)) FStar_Util.either
      option)
  = fun projectee  -> match projectee with | Tm_abs _0 -> _0
let uu___is_Tm_arrow: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tm_arrow _0 -> true | uu____973 -> false
let __proj__Tm_arrow__item___0:
  term' -> ((bv* aqual) Prims.list* (comp',Prims.unit) syntax) =
  fun projectee  -> match projectee with | Tm_arrow _0 -> _0
let uu___is_Tm_refine: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tm_refine _0 -> true | uu____1010 -> false
let __proj__Tm_refine__item___0: term' -> (bv* (term',term') syntax) =
  fun projectee  -> match projectee with | Tm_refine _0 -> _0
let uu___is_Tm_app: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tm_app _0 -> true | uu____1043 -> false
let __proj__Tm_app__item___0:
  term' -> ((term',term') syntax* ((term',term') syntax* aqual) Prims.list) =
  fun projectee  -> match projectee with | Tm_app _0 -> _0
let uu___is_Tm_match: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tm_match _0 -> true | uu____1097 -> false
let __proj__Tm_match__item___0:
  term' ->
    ((term',term') syntax* ((pat',term') withinfo_t* (term',term') syntax
      option* (term',term') syntax) Prims.list)
  = fun projectee  -> match projectee with | Tm_match _0 -> _0
let uu___is_Tm_ascribed: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tm_ascribed _0 -> true | uu____1171 -> false
let __proj__Tm_ascribed__item___0:
  term' ->
    ((term',term') syntax* (((term',term') syntax,(comp',Prims.unit) syntax)
      FStar_Util.either* (term',term') syntax option)* FStar_Ident.lident
      option)
  = fun projectee  -> match projectee with | Tm_ascribed _0 -> _0
let uu___is_Tm_let: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tm_let _0 -> true | uu____1241 -> false
let __proj__Tm_let__item___0:
  term' -> ((Prims.bool* letbinding Prims.list)* (term',term') syntax) =
  fun projectee  -> match projectee with | Tm_let _0 -> _0
let uu___is_Tm_uvar: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tm_uvar _0 -> true | uu____1284 -> false
let __proj__Tm_uvar__item___0:
  term' ->
    (((term',term') syntax option FStar_Unionfind.p_uvar* version)*
      (term',term') syntax)
  = fun projectee  -> match projectee with | Tm_uvar _0 -> _0
let uu___is_Tm_delayed: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tm_delayed _0 -> true | uu____1346 -> false
let __proj__Tm_delayed__item___0:
  term' ->
    ((((term',term') syntax* (subst_elt Prims.list Prims.list*
        FStar_Range.range option)),Prims.unit -> (term',term') syntax)
      FStar_Util.either* (term',term') syntax memo)
  = fun projectee  -> match projectee with | Tm_delayed _0 -> _0
let uu___is_Tm_meta: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tm_meta _0 -> true | uu____1422 -> false
let __proj__Tm_meta__item___0: term' -> ((term',term') syntax* metadata) =
  fun projectee  -> match projectee with | Tm_meta _0 -> _0
let uu___is_Tm_unknown: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tm_unknown  -> true | uu____1445 -> false
let uu___is_Pat_constant: pat' -> Prims.bool =
  fun projectee  ->
    match projectee with | Pat_constant _0 -> true | uu____1450 -> false
let __proj__Pat_constant__item___0: pat' -> sconst =
  fun projectee  -> match projectee with | Pat_constant _0 -> _0
let uu___is_Pat_cons: pat' -> Prims.bool =
  fun projectee  ->
    match projectee with | Pat_cons _0 -> true | uu____1469 -> false
let __proj__Pat_cons__item___0:
  pat' -> (fv* ((pat',term') withinfo_t* Prims.bool) Prims.list) =
  fun projectee  -> match projectee with | Pat_cons _0 -> _0
let uu___is_Pat_var: pat' -> Prims.bool =
  fun projectee  ->
    match projectee with | Pat_var _0 -> true | uu____1502 -> false
let __proj__Pat_var__item___0: pat' -> bv =
  fun projectee  -> match projectee with | Pat_var _0 -> _0
let uu___is_Pat_wild: pat' -> Prims.bool =
  fun projectee  ->
    match projectee with | Pat_wild _0 -> true | uu____1514 -> false
let __proj__Pat_wild__item___0: pat' -> bv =
  fun projectee  -> match projectee with | Pat_wild _0 -> _0
let uu___is_Pat_dot_term: pat' -> Prims.bool =
  fun projectee  ->
    match projectee with | Pat_dot_term _0 -> true | uu____1530 -> false
let __proj__Pat_dot_term__item___0: pat' -> (bv* (term',term') syntax) =
  fun projectee  -> match projectee with | Pat_dot_term _0 -> _0
let uu___is_Total: comp' -> Prims.bool =
  fun projectee  ->
    match projectee with | Total _0 -> true | uu____1629 -> false
let __proj__Total__item___0: comp' -> ((term',term') syntax* universe option)
  = fun projectee  -> match projectee with | Total _0 -> _0
let uu___is_GTotal: comp' -> Prims.bool =
  fun projectee  ->
    match projectee with | GTotal _0 -> true | uu____1661 -> false
let __proj__GTotal__item___0:
  comp' -> ((term',term') syntax* universe option) =
  fun projectee  -> match projectee with | GTotal _0 -> _0
let uu___is_Comp: comp' -> Prims.bool =
  fun projectee  ->
    match projectee with | Comp _0 -> true | uu____1688 -> false
let __proj__Comp__item___0: comp' -> comp_typ =
  fun projectee  -> match projectee with | Comp _0 -> _0
let uu___is_TOTAL: cflags -> Prims.bool =
  fun projectee  ->
    match projectee with | TOTAL  -> true | uu____1699 -> false
let uu___is_MLEFFECT: cflags -> Prims.bool =
  fun projectee  ->
    match projectee with | MLEFFECT  -> true | uu____1703 -> false
let uu___is_RETURN: cflags -> Prims.bool =
  fun projectee  ->
    match projectee with | RETURN  -> true | uu____1707 -> false
let uu___is_PARTIAL_RETURN: cflags -> Prims.bool =
  fun projectee  ->
    match projectee with | PARTIAL_RETURN  -> true | uu____1711 -> false
let uu___is_SOMETRIVIAL: cflags -> Prims.bool =
  fun projectee  ->
    match projectee with | SOMETRIVIAL  -> true | uu____1715 -> false
let uu___is_LEMMA: cflags -> Prims.bool =
  fun projectee  ->
    match projectee with | LEMMA  -> true | uu____1719 -> false
let uu___is_CPS: cflags -> Prims.bool =
  fun projectee  -> match projectee with | CPS  -> true | uu____1723 -> false
let uu___is_DECREASES: cflags -> Prims.bool =
  fun projectee  ->
    match projectee with | DECREASES _0 -> true | uu____1730 -> false
let __proj__DECREASES__item___0: cflags -> (term',term') syntax =
  fun projectee  -> match projectee with | DECREASES _0 -> _0
let uu___is_Meta_pattern: metadata -> Prims.bool =
  fun projectee  ->
    match projectee with | Meta_pattern _0 -> true | uu____1754 -> false
let __proj__Meta_pattern__item___0:
  metadata -> ((term',term') syntax* aqual) Prims.list Prims.list =
  fun projectee  -> match projectee with | Meta_pattern _0 -> _0
let uu___is_Meta_named: metadata -> Prims.bool =
  fun projectee  ->
    match projectee with | Meta_named _0 -> true | uu____1784 -> false
let __proj__Meta_named__item___0: metadata -> FStar_Ident.lident =
  fun projectee  -> match projectee with | Meta_named _0 -> _0
let uu___is_Meta_labeled: metadata -> Prims.bool =
  fun projectee  ->
    match projectee with | Meta_labeled _0 -> true | uu____1799 -> false
let __proj__Meta_labeled__item___0:
  metadata -> (Prims.string* FStar_Range.range* Prims.bool) =
  fun projectee  -> match projectee with | Meta_labeled _0 -> _0
let uu___is_Meta_desugared: metadata -> Prims.bool =
  fun projectee  ->
    match projectee with | Meta_desugared _0 -> true | uu____1820 -> false
let __proj__Meta_desugared__item___0: metadata -> meta_source_info =
  fun projectee  -> match projectee with | Meta_desugared _0 -> _0
let uu___is_Meta_monadic: metadata -> Prims.bool =
  fun projectee  ->
    match projectee with | Meta_monadic _0 -> true | uu____1836 -> false
let __proj__Meta_monadic__item___0:
  metadata -> (monad_name* (term',term') syntax) =
  fun projectee  -> match projectee with | Meta_monadic _0 -> _0
let uu___is_Meta_monadic_lift: metadata -> Prims.bool =
  fun projectee  ->
    match projectee with | Meta_monadic_lift _0 -> true | uu____1865 -> false
let __proj__Meta_monadic_lift__item___0:
  metadata -> (monad_name* monad_name* (term',term') syntax) =
  fun projectee  -> match projectee with | Meta_monadic_lift _0 -> _0
let uu___is_Data_app: meta_source_info -> Prims.bool =
  fun projectee  ->
    match projectee with | Data_app  -> true | uu____1891 -> false
let uu___is_Sequence: meta_source_info -> Prims.bool =
  fun projectee  ->
    match projectee with | Sequence  -> true | uu____1895 -> false
let uu___is_Primop: meta_source_info -> Prims.bool =
  fun projectee  ->
    match projectee with | Primop  -> true | uu____1899 -> false
let uu___is_Masked_effect: meta_source_info -> Prims.bool =
  fun projectee  ->
    match projectee with | Masked_effect  -> true | uu____1903 -> false
let uu___is_Meta_smt_pat: meta_source_info -> Prims.bool =
  fun projectee  ->
    match projectee with | Meta_smt_pat  -> true | uu____1907 -> false
let uu___is_Mutable_alloc: meta_source_info -> Prims.bool =
  fun projectee  ->
    match projectee with | Mutable_alloc  -> true | uu____1911 -> false
let uu___is_Mutable_rval: meta_source_info -> Prims.bool =
  fun projectee  ->
    match projectee with | Mutable_rval  -> true | uu____1915 -> false
let uu___is_Data_ctor: fv_qual -> Prims.bool =
  fun projectee  ->
    match projectee with | Data_ctor  -> true | uu____1919 -> false
let uu___is_Record_projector: fv_qual -> Prims.bool =
  fun projectee  ->
    match projectee with | Record_projector _0 -> true | uu____1926 -> false
let __proj__Record_projector__item___0:
  fv_qual -> (FStar_Ident.lident* FStar_Ident.ident) =
  fun projectee  -> match projectee with | Record_projector _0 -> _0
let uu___is_Record_ctor: fv_qual -> Prims.bool =
  fun projectee  ->
    match projectee with | Record_ctor _0 -> true | uu____1947 -> false
let __proj__Record_ctor__item___0:
  fv_qual -> (FStar_Ident.lident* FStar_Ident.ident Prims.list) =
  fun projectee  -> match projectee with | Record_ctor _0 -> _0
let uu___is_DB: subst_elt -> Prims.bool =
  fun projectee  ->
    match projectee with | DB _0 -> true | uu____1970 -> false
let __proj__DB__item___0: subst_elt -> (Prims.int* bv) =
  fun projectee  -> match projectee with | DB _0 -> _0
let uu___is_NM: subst_elt -> Prims.bool =
  fun projectee  ->
    match projectee with | NM _0 -> true | uu____1990 -> false
let __proj__NM__item___0: subst_elt -> (bv* Prims.int) =
  fun projectee  -> match projectee with | NM _0 -> _0
let uu___is_NT: subst_elt -> Prims.bool =
  fun projectee  ->
    match projectee with | NT _0 -> true | uu____2012 -> false
let __proj__NT__item___0: subst_elt -> (bv* (term',term') syntax) =
  fun projectee  -> match projectee with | NT _0 -> _0
let uu___is_UN: subst_elt -> Prims.bool =
  fun projectee  ->
    match projectee with | UN _0 -> true | uu____2038 -> false
let __proj__UN__item___0: subst_elt -> (Prims.int* universe) =
  fun projectee  -> match projectee with | UN _0 -> _0
let uu___is_UD: subst_elt -> Prims.bool =
  fun projectee  ->
    match projectee with | UD _0 -> true | uu____2058 -> false
let __proj__UD__item___0: subst_elt -> (univ_name* Prims.int) =
  fun projectee  -> match projectee with | UD _0 -> _0
type pat = (pat',term') withinfo_t
type term = (term',term') syntax
type branch =
  ((pat',term') withinfo_t* (term',term') syntax option* (term',term')
    syntax)
type comp = (comp',Prims.unit) syntax
type ascription =
  (((term',term') syntax,(comp',Prims.unit) syntax) FStar_Util.either*
    (term',term') syntax option)
type typ = (term',term') syntax
type arg = ((term',term') syntax* aqual)
type args = ((term',term') syntax* aqual) Prims.list
type binder = (bv* aqual)
type binders = (bv* aqual) Prims.list
type uvar = ((term',term') syntax option FStar_Unionfind.p_uvar* version)
type lbname = (bv,fv) FStar_Util.either
type letbindings = (Prims.bool* letbinding Prims.list)
type subst_ts = (subst_elt Prims.list Prims.list* FStar_Range.range option)
type freenames = bv FStar_Util.set
type uvars =
  (((term',term') syntax option FStar_Unionfind.p_uvar* version)*
    (term',term') syntax) FStar_Util.set
type residual_comp = (FStar_Ident.lident* cflags Prims.list)
type tscheme = (univ_name Prims.list* typ)
type freenames_l = bv Prims.list
type formula = typ
type formulae = typ Prims.list
type qualifier =
  | Assumption
  | New
  | Private
  | Unfold_for_unification_and_vcgen
  | Visible_default
  | Irreducible
  | Abstract
  | Inline_for_extraction
  | NoExtract
  | Noeq
  | Unopteq
  | TotalEffect
  | Logic
  | Reifiable
  | Reflectable of FStar_Ident.lident
  | Discriminator of FStar_Ident.lident
  | Projector of (FStar_Ident.lident* FStar_Ident.ident)
  | RecordType of (FStar_Ident.ident Prims.list* FStar_Ident.ident
  Prims.list)
  | RecordConstructor of (FStar_Ident.ident Prims.list* FStar_Ident.ident
  Prims.list)
  | Action of FStar_Ident.lident
  | ExceptionConstructor
  | HasMaskedEffect
  | Effect
  | OnlyName
let uu___is_Assumption: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Assumption  -> true | uu____2374 -> false
let uu___is_New: qualifier -> Prims.bool =
  fun projectee  -> match projectee with | New  -> true | uu____2378 -> false
let uu___is_Private: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Private  -> true | uu____2382 -> false
let uu___is_Unfold_for_unification_and_vcgen: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with
    | Unfold_for_unification_and_vcgen  -> true
    | uu____2386 -> false
let uu___is_Visible_default: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Visible_default  -> true | uu____2390 -> false
let uu___is_Irreducible: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Irreducible  -> true | uu____2394 -> false
let uu___is_Abstract: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Abstract  -> true | uu____2398 -> false
let uu___is_Inline_for_extraction: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with
    | Inline_for_extraction  -> true
    | uu____2402 -> false
let uu___is_NoExtract: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | NoExtract  -> true | uu____2406 -> false
let uu___is_Noeq: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Noeq  -> true | uu____2410 -> false
let uu___is_Unopteq: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Unopteq  -> true | uu____2414 -> false
let uu___is_TotalEffect: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | TotalEffect  -> true | uu____2418 -> false
let uu___is_Logic: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Logic  -> true | uu____2422 -> false
let uu___is_Reifiable: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Reifiable  -> true | uu____2426 -> false
let uu___is_Reflectable: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Reflectable _0 -> true | uu____2431 -> false
let __proj__Reflectable__item___0: qualifier -> FStar_Ident.lident =
  fun projectee  -> match projectee with | Reflectable _0 -> _0
let uu___is_Discriminator: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Discriminator _0 -> true | uu____2443 -> false
let __proj__Discriminator__item___0: qualifier -> FStar_Ident.lident =
  fun projectee  -> match projectee with | Discriminator _0 -> _0
let uu___is_Projector: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Projector _0 -> true | uu____2457 -> false
let __proj__Projector__item___0:
  qualifier -> (FStar_Ident.lident* FStar_Ident.ident) =
  fun projectee  -> match projectee with | Projector _0 -> _0
let uu___is_RecordType: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | RecordType _0 -> true | uu____2479 -> false
let __proj__RecordType__item___0:
  qualifier -> (FStar_Ident.ident Prims.list* FStar_Ident.ident Prims.list) =
  fun projectee  -> match projectee with | RecordType _0 -> _0
let uu___is_RecordConstructor: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | RecordConstructor _0 -> true | uu____2507 -> false
let __proj__RecordConstructor__item___0:
  qualifier -> (FStar_Ident.ident Prims.list* FStar_Ident.ident Prims.list) =
  fun projectee  -> match projectee with | RecordConstructor _0 -> _0
let uu___is_Action: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Action _0 -> true | uu____2531 -> false
let __proj__Action__item___0: qualifier -> FStar_Ident.lident =
  fun projectee  -> match projectee with | Action _0 -> _0
let uu___is_ExceptionConstructor: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with
    | ExceptionConstructor  -> true
    | uu____2542 -> false
let uu___is_HasMaskedEffect: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | HasMaskedEffect  -> true | uu____2546 -> false
let uu___is_Effect: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Effect  -> true | uu____2550 -> false
let uu___is_OnlyName: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | OnlyName  -> true | uu____2554 -> false
type attribute = term
type tycon = (FStar_Ident.lident* binders* typ)
type monad_abbrev = {
  mabbrev: FStar_Ident.lident;
  parms: binders;
  def: typ;}
type sub_eff =
  {
  source: FStar_Ident.lident;
  target: FStar_Ident.lident;
  lift_wp: tscheme option;
  lift: tscheme option;}
type action =
  {
  action_name: FStar_Ident.lident;
  action_unqualified_name: FStar_Ident.ident;
  action_univs: univ_names;
  action_params: binders;
  action_defn: term;
  action_typ: typ;}
type eff_decl =
  {
  cattributes: cflags Prims.list;
  mname: FStar_Ident.lident;
  univs: univ_names;
  binders: binders;
  signature: term;
  ret_wp: tscheme;
  bind_wp: tscheme;
  if_then_else: tscheme;
  ite_wp: tscheme;
  stronger: tscheme;
  close_wp: tscheme;
  assert_p: tscheme;
  assume_p: tscheme;
  null_wp: tscheme;
  trivial: tscheme;
  repr: term;
  return_repr: tscheme;
  bind_repr: tscheme;
  actions: action Prims.list;}
type sig_metadata =
  {
  sigmeta_active: Prims.bool;
  sigmeta_fact_db_ids: Prims.string Prims.list;}
type sigelt' =
  | Sig_inductive_typ of (FStar_Ident.lident* univ_names* binders* typ*
  FStar_Ident.lident Prims.list* FStar_Ident.lident Prims.list)
  | Sig_bundle of (sigelt Prims.list* FStar_Ident.lident Prims.list)
  | Sig_datacon of (FStar_Ident.lident* univ_names* typ* FStar_Ident.lident*
  Prims.int* FStar_Ident.lident Prims.list)
  | Sig_declare_typ of (FStar_Ident.lident* univ_names* typ)
  | Sig_let of (letbindings* FStar_Ident.lident Prims.list* attribute
  Prims.list)
  | Sig_main of term
  | Sig_assume of (FStar_Ident.lident* univ_names* formula)
  | Sig_new_effect of eff_decl
  | Sig_new_effect_for_free of eff_decl
  | Sig_sub_effect of sub_eff
  | Sig_effect_abbrev of (FStar_Ident.lident* univ_names* binders* comp*
  cflags Prims.list)
  | Sig_pragma of pragma
and sigelt =
  {
  sigel: sigelt';
  sigrng: FStar_Range.range;
  sigquals: qualifier Prims.list;
  sigmeta: sig_metadata;}
let uu___is_Sig_inductive_typ: sigelt' -> Prims.bool =
  fun projectee  ->
    match projectee with | Sig_inductive_typ _0 -> true | uu____2958 -> false
let __proj__Sig_inductive_typ__item___0:
  sigelt' ->
    (FStar_Ident.lident* univ_names* binders* typ* FStar_Ident.lident
      Prims.list* FStar_Ident.lident Prims.list)
  = fun projectee  -> match projectee with | Sig_inductive_typ _0 -> _0
let uu___is_Sig_bundle: sigelt' -> Prims.bool =
  fun projectee  ->
    match projectee with | Sig_bundle _0 -> true | uu____2998 -> false
let __proj__Sig_bundle__item___0:
  sigelt' -> (sigelt Prims.list* FStar_Ident.lident Prims.list) =
  fun projectee  -> match projectee with | Sig_bundle _0 -> _0
let uu___is_Sig_datacon: sigelt' -> Prims.bool =
  fun projectee  ->
    match projectee with | Sig_datacon _0 -> true | uu____3029 -> false
let __proj__Sig_datacon__item___0:
  sigelt' ->
    (FStar_Ident.lident* univ_names* typ* FStar_Ident.lident* Prims.int*
      FStar_Ident.lident Prims.list)
  = fun projectee  -> match projectee with | Sig_datacon _0 -> _0
let uu___is_Sig_declare_typ: sigelt' -> Prims.bool =
  fun projectee  ->
    match projectee with | Sig_declare_typ _0 -> true | uu____3065 -> false
let __proj__Sig_declare_typ__item___0:
  sigelt' -> (FStar_Ident.lident* univ_names* typ) =
  fun projectee  -> match projectee with | Sig_declare_typ _0 -> _0
let uu___is_Sig_let: sigelt' -> Prims.bool =
  fun projectee  ->
    match projectee with | Sig_let _0 -> true | uu____3091 -> false
let __proj__Sig_let__item___0:
  sigelt' ->
    (letbindings* FStar_Ident.lident Prims.list* attribute Prims.list)
  = fun projectee  -> match projectee with | Sig_let _0 -> _0
let uu___is_Sig_main: sigelt' -> Prims.bool =
  fun projectee  ->
    match projectee with | Sig_main _0 -> true | uu____3118 -> false
let __proj__Sig_main__item___0: sigelt' -> term =
  fun projectee  -> match projectee with | Sig_main _0 -> _0
let uu___is_Sig_assume: sigelt' -> Prims.bool =
  fun projectee  ->
    match projectee with | Sig_assume _0 -> true | uu____3133 -> false
let __proj__Sig_assume__item___0:
  sigelt' -> (FStar_Ident.lident* univ_names* formula) =
  fun projectee  -> match projectee with | Sig_assume _0 -> _0
let uu___is_Sig_new_effect: sigelt' -> Prims.bool =
  fun projectee  ->
    match projectee with | Sig_new_effect _0 -> true | uu____3154 -> false
let __proj__Sig_new_effect__item___0: sigelt' -> eff_decl =
  fun projectee  -> match projectee with | Sig_new_effect _0 -> _0
let uu___is_Sig_new_effect_for_free: sigelt' -> Prims.bool =
  fun projectee  ->
    match projectee with
    | Sig_new_effect_for_free _0 -> true
    | uu____3166 -> false
let __proj__Sig_new_effect_for_free__item___0: sigelt' -> eff_decl =
  fun projectee  -> match projectee with | Sig_new_effect_for_free _0 -> _0
let uu___is_Sig_sub_effect: sigelt' -> Prims.bool =
  fun projectee  ->
    match projectee with | Sig_sub_effect _0 -> true | uu____3178 -> false
let __proj__Sig_sub_effect__item___0: sigelt' -> sub_eff =
  fun projectee  -> match projectee with | Sig_sub_effect _0 -> _0
let uu___is_Sig_effect_abbrev: sigelt' -> Prims.bool =
  fun projectee  ->
    match projectee with | Sig_effect_abbrev _0 -> true | uu____3196 -> false
let __proj__Sig_effect_abbrev__item___0:
  sigelt' ->
    (FStar_Ident.lident* univ_names* binders* comp* cflags Prims.list)
  = fun projectee  -> match projectee with | Sig_effect_abbrev _0 -> _0
let uu___is_Sig_pragma: sigelt' -> Prims.bool =
  fun projectee  ->
    match projectee with | Sig_pragma _0 -> true | uu____3226 -> false
let __proj__Sig_pragma__item___0: sigelt' -> pragma =
  fun projectee  -> match projectee with | Sig_pragma _0 -> _0
type sigelts = sigelt Prims.list
type modul =
  {
  name: FStar_Ident.lident;
  declarations: sigelts;
  exports: sigelts;
  is_interface: Prims.bool;}
type path = Prims.string Prims.list
type subst_t = subst_elt Prims.list
type ('a,'b) mk_t_a = 'b option -> FStar_Range.range -> ('a,'b) syntax
type mk_t = (term',term') mk_t_a
let contains_reflectable: qualifier Prims.list -> Prims.bool =
  fun l  ->
    FStar_Util.for_some
      (fun uu___87_3307  ->
         match uu___87_3307 with
         | Reflectable uu____3308 -> true
         | uu____3309 -> false) l
let withinfo v1 s r = { v = v1; ty = s; p = r }
let withsort v1 s = withinfo v1 s FStar_Range.dummyRange
let bv_eq: bv -> bv -> Prims.bool =
  fun bv1  ->
    fun bv2  ->
      ((bv1.ppname).FStar_Ident.idText = (bv2.ppname).FStar_Ident.idText) &&
        (bv1.index = bv2.index)
let order_bv: bv -> bv -> Prims.int =
  fun x  ->
    fun y  ->
      let i =
        FStar_String.compare (x.ppname).FStar_Ident.idText
          (y.ppname).FStar_Ident.idText in
      if i = (Prims.parse_int "0") then x.index - y.index else i
let order_fv: FStar_Ident.lident -> FStar_Ident.lident -> Prims.int =
  fun x  ->
    fun y  -> FStar_String.compare x.FStar_Ident.str y.FStar_Ident.str
let range_of_lbname: lbname -> FStar_Range.range =
  fun l  ->
    match l with
    | FStar_Util.Inl x -> (x.ppname).FStar_Ident.idRange
    | FStar_Util.Inr fv -> FStar_Ident.range_of_lid (fv.fv_name).v
let range_of_bv: bv -> FStar_Range.range =
  fun x  -> (x.ppname).FStar_Ident.idRange
let set_range_of_bv: bv -> FStar_Range.range -> bv =
  fun x  ->
    fun r  ->
      let uu___94_3385 = x in
      {
        ppname = (FStar_Ident.mk_ident (((x.ppname).FStar_Ident.idText), r));
        index = (uu___94_3385.index);
        sort = (uu___94_3385.sort)
      }
let syn p k f = f k p
let mk_fvs uu____3426 = FStar_Util.mk_ref None
let mk_uvs uu____3438 = FStar_Util.mk_ref None
let new_bv_set: Prims.unit -> bv FStar_Util.set =
  fun uu____3444  ->
    FStar_Util.new_set order_bv
      (fun x  ->
         x.index + (FStar_Util.hashcode (x.ppname).FStar_Ident.idText))
let new_fv_set: Prims.unit -> FStar_Ident.lident FStar_Util.set =
  fun uu____3450  ->
    FStar_Util.new_set order_fv
      (fun x  -> FStar_Util.hashcode x.FStar_Ident.str)
let new_universe_names_fifo_set:
  Prims.unit -> FStar_Ident.ident FStar_Util.fifo_set =
  fun uu____3458  ->
    FStar_Util.new_fifo_set
      (fun x  ->
         fun y  ->
           FStar_String.compare (FStar_Ident.text_of_id x)
             (FStar_Ident.text_of_id y))
      (fun x  -> FStar_Util.hashcode (FStar_Ident.text_of_id x))
let no_names: bv FStar_Util.set = new_bv_set ()
let no_fvars: FStar_Ident.lident FStar_Util.set = new_fv_set ()
let no_universe_names: univ_name FStar_Util.fifo_set =
  new_universe_names_fifo_set ()
let freenames_of_list: bv Prims.list -> bv FStar_Util.set =
  fun l  -> FStar_List.fold_right FStar_Util.set_add l no_names
let list_of_freenames: freenames -> bv Prims.list =
  fun fvs  -> FStar_Util.set_elements fvs
let mk t topt r =
  let uu____3504 = FStar_Util.mk_ref topt in
  let uu____3508 = FStar_Util.mk_ref None in
  { n = t; tk = uu____3504; pos = r; vars = uu____3508 }
let bv_to_tm: bv -> (term',term') syntax =
  fun bv  ->
    let uu____3519 = range_of_bv bv in
    mk (Tm_bvar bv) (Some ((bv.sort).n)) uu____3519
let bv_to_name: bv -> (term',term') syntax =
  fun bv  ->
    let uu____3527 = range_of_bv bv in
    mk (Tm_name bv) (Some ((bv.sort).n)) uu____3527
let mk_Tm_app:
  typ ->
    arg Prims.list ->
      term' option -> FStar_Range.range -> (term',term') syntax
  =
  fun t1  ->
    fun args  ->
      fun k  ->
        fun p  ->
          match args with
          | [] -> t1
          | uu____3548 -> mk (Tm_app (t1, args)) k p
let mk_Tm_uinst: term -> universes -> term =
  fun t  ->
    fun uu___88_3560  ->
      match uu___88_3560 with
      | [] -> t
      | us ->
          (match t.n with
           | Tm_fvar uu____3562 -> mk (Tm_uinst (t, us)) None t.pos
           | uu____3567 -> failwith "Unexpected universe instantiation")
let extend_app_n:
  term -> args -> term' option -> FStar_Range.range -> (term',term') syntax =
  fun t  ->
    fun args'  ->
      fun kopt  ->
        fun r  ->
          match t.n with
          | Tm_app (head1,args) ->
              mk_Tm_app head1 (FStar_List.append args args') kopt r
          | uu____3605 -> mk_Tm_app t args' kopt r
let extend_app:
  term -> arg -> term' option -> FStar_Range.range -> (term',term') syntax =
  fun t  -> fun arg  -> fun kopt  -> fun r  -> extend_app_n t [arg] kopt r
let mk_Tm_delayed:
  ((term* subst_ts),Prims.unit -> term) FStar_Util.either ->
    FStar_Range.range -> (term',term') syntax
  =
  fun lr  ->
    fun pos  ->
      let uu____3642 =
        let uu____3645 =
          let uu____3646 =
            let uu____3667 = FStar_Util.mk_ref None in (lr, uu____3667) in
          Tm_delayed uu____3646 in
        mk uu____3645 in
      uu____3642 None pos
let mk_Total': typ -> universe option -> (comp',Prims.unit) syntax =
  fun t  -> fun u  -> mk (Total (t, u)) None t.pos
let mk_GTotal': typ -> universe option -> (comp',Prims.unit) syntax =
  fun t  -> fun u  -> mk (GTotal (t, u)) None t.pos
let mk_Total: typ -> comp = fun t  -> mk_Total' t None
let mk_GTotal: typ -> comp = fun t  -> mk_GTotal' t None
let mk_Comp: comp_typ -> (comp',Prims.unit) syntax =
  fun ct  -> mk (Comp ct) None (ct.result_typ).pos
let mk_lb:
  (lbname* univ_name Prims.list* FStar_Ident.lident* typ* term) -> letbinding
  =
  fun uu____3745  ->
    match uu____3745 with
    | (x,univs,eff,t,e) ->
        { lbname = x; lbunivs = univs; lbtyp = t; lbeff = eff; lbdef = e }
let default_sigmeta: sig_metadata =
  { sigmeta_active = true; sigmeta_fact_db_ids = [] }
let mk_sigelt: sigelt' -> sigelt =
  fun e  ->
    {
      sigel = e;
      sigrng = FStar_Range.dummyRange;
      sigquals = [];
      sigmeta = default_sigmeta
    }
let mk_subst: subst_t -> subst_t = fun s  -> s
let extend_subst: subst_elt -> subst_elt Prims.list -> subst_elt Prims.list =
  fun x  -> fun s  -> x :: s
let argpos: arg -> FStar_Range.range = fun x  -> (fst x).pos
let tun: (term',term') syntax = mk Tm_unknown None FStar_Range.dummyRange
let teff: (term',term') syntax =
  mk (Tm_constant FStar_Const.Const_effect) (Some Tm_unknown)
    FStar_Range.dummyRange
let is_teff: term -> Prims.bool =
  fun t  ->
    match t.n with
    | Tm_constant (FStar_Const.Const_effect ) -> true
    | uu____3793 -> false
let is_type: term -> Prims.bool =
  fun t  -> match t.n with | Tm_type uu____3797 -> true | uu____3798 -> false
let null_id: FStar_Ident.ident =
  FStar_Ident.mk_ident ("_", FStar_Range.dummyRange)
let null_bv: term -> bv =
  fun k  -> { ppname = null_id; index = (Prims.parse_int "0"); sort = k }
let mk_binder: bv -> (bv* arg_qualifier option) = fun a  -> (a, None)
let null_binder: term -> (bv* arg_qualifier option) =
  fun t  -> let uu____3809 = null_bv t in (uu____3809, None)
let imp_tag: arg_qualifier = Implicit false
let iarg: term -> (term* arg_qualifier option) =
  fun t  -> (t, (Some imp_tag))
let as_arg: term -> (term* arg_qualifier option) = fun t  -> (t, None)
let is_null_bv: bv -> Prims.bool =
  fun b  -> (b.ppname).FStar_Ident.idText = null_id.FStar_Ident.idText
let is_null_binder: binder -> Prims.bool = fun b  -> is_null_bv (fst b)
let is_top_level: letbinding Prims.list -> Prims.bool =
  fun uu___89_3828  ->
    match uu___89_3828 with
    | { lbname = FStar_Util.Inr uu____3830; lbunivs = uu____3831;
        lbtyp = uu____3832; lbeff = uu____3833; lbdef = uu____3834;_}::uu____3835
        -> true
    | uu____3842 -> false
let freenames_of_binders: binders -> bv FStar_Util.set =
  fun bs  ->
    FStar_List.fold_right
      (fun uu____3850  ->
         fun out  ->
           match uu____3850 with | (x,uu____3857) -> FStar_Util.set_add x out)
      bs no_names
let binders_of_list: bv Prims.list -> (bv* arg_qualifier option) Prims.list =
  fun fvs  -> FStar_All.pipe_right fvs (FStar_List.map (fun t  -> (t, None)))
let binders_of_freenames: freenames -> binders =
  fun fvs  ->
    let uu____3876 = FStar_Util.set_elements fvs in
    FStar_All.pipe_right uu____3876 binders_of_list
let is_implicit: aqual -> Prims.bool =
  fun uu___90_3881  ->
    match uu___90_3881 with
    | Some (Implicit uu____3882) -> true
    | uu____3883 -> false
let as_implicit: Prims.bool -> arg_qualifier option =
  fun uu___91_3886  -> if uu___91_3886 then Some imp_tag else None
let pat_bvs: pat -> bv Prims.list =
  fun p  ->
    let rec aux b p1 =
      match p1.v with
      | Pat_dot_term uu____3908 -> b
      | Pat_constant uu____3913 -> b
      | Pat_wild x -> x :: b
      | Pat_var x -> x :: b
      | Pat_cons (uu____3916,pats) ->
          FStar_List.fold_left
            (fun b1  ->
               fun uu____3934  ->
                 match uu____3934 with | (p2,uu____3942) -> aux b1 p2) b pats in
    let uu____3947 = aux [] p in
    FStar_All.pipe_left FStar_List.rev uu____3947
let gen_reset: ((Prims.unit -> Prims.int)* (Prims.unit -> Prims.unit)) =
  let x = FStar_Util.mk_ref (Prims.parse_int "0") in
  let gen1 uu____3963 = FStar_Util.incr x; FStar_ST.read x in
  let reset uu____3973 = FStar_ST.write x (Prims.parse_int "0") in
  (gen1, reset)
let next_id: Prims.unit -> Prims.int = fst gen_reset
let reset_gensym: Prims.unit -> Prims.unit = snd gen_reset
let range_of_ropt: FStar_Range.range option -> FStar_Range.range =
  fun uu___92_3995  ->
    match uu___92_3995 with | None  -> FStar_Range.dummyRange | Some r -> r
let gen_bv: Prims.string -> FStar_Range.range option -> typ -> bv =
  fun s  ->
    fun r  ->
      fun t  ->
        let id = FStar_Ident.mk_ident (s, (range_of_ropt r)) in
        let uu____4010 = next_id () in
        { ppname = id; index = uu____4010; sort = t }
let new_bv: FStar_Range.range option -> typ -> bv =
  fun ropt  -> fun t  -> gen_bv FStar_Ident.reserved_prefix ropt t
let freshen_bv: bv -> bv =
  fun bv  ->
    let uu____4022 = is_null_bv bv in
    if uu____4022
    then
      let uu____4023 = let uu____4025 = range_of_bv bv in Some uu____4025 in
      new_bv uu____4023 bv.sort
    else
      (let uu___95_4027 = bv in
       let uu____4028 = next_id () in
       {
         ppname = (uu___95_4027.ppname);
         index = uu____4028;
         sort = (uu___95_4027.sort)
       })
let new_univ_name: FStar_Range.range option -> FStar_Ident.ident =
  fun ropt  ->
    let id = next_id () in
    let uu____4035 =
      let uu____4038 =
        let uu____4039 = FStar_Util.string_of_int id in
        Prims.strcat FStar_Ident.reserved_prefix uu____4039 in
      (uu____4038, (range_of_ropt ropt)) in
    FStar_Ident.mk_ident uu____4035
let mkbv: FStar_Ident.ident -> Prims.int -> (term',term') syntax -> bv =
  fun x  -> fun y  -> fun t  -> { ppname = x; index = y; sort = t }
let lbname_eq:
  (bv,FStar_Ident.lident) FStar_Util.either ->
    (bv,FStar_Ident.lident) FStar_Util.either -> Prims.bool
  =
  fun l1  ->
    fun l2  ->
      match (l1, l2) with
      | (FStar_Util.Inl x,FStar_Util.Inl y) -> bv_eq x y
      | (FStar_Util.Inr l,FStar_Util.Inr m) -> FStar_Ident.lid_equals l m
      | uu____4083 -> false
let fv_eq: fv -> fv -> Prims.bool =
  fun fv1  ->
    fun fv2  -> FStar_Ident.lid_equals (fv1.fv_name).v (fv2.fv_name).v
let fv_eq_lid: fv -> FStar_Ident.lident -> Prims.bool =
  fun fv  -> fun lid  -> FStar_Ident.lid_equals (fv.fv_name).v lid
let set_bv_range: bv -> FStar_Range.range -> bv =
  fun bv  ->
    fun r  ->
      let uu___96_4120 = bv in
      {
        ppname = (FStar_Ident.mk_ident (((bv.ppname).FStar_Ident.idText), r));
        index = (uu___96_4120.index);
        sort = (uu___96_4120.sort)
      }
let lid_as_fv: FStar_Ident.lident -> delta_depth -> fv_qual option -> fv =
  fun l  ->
    fun dd  ->
      fun dq  ->
        let uu____4132 = withinfo l tun (FStar_Ident.range_of_lid l) in
        { fv_name = uu____4132; fv_delta = dd; fv_qual = dq }
let fv_to_tm: fv -> (term',term') syntax =
  fun fv  -> mk (Tm_fvar fv) None (FStar_Ident.range_of_lid (fv.fv_name).v)
let fvar: FStar_Ident.lident -> delta_depth -> fv_qual option -> term =
  fun l  ->
    fun dd  ->
      fun dq  -> let uu____4163 = lid_as_fv l dd dq in fv_to_tm uu____4163
let lid_of_fv: fv -> FStar_Ident.lident = fun fv  -> (fv.fv_name).v
let range_of_fv: fv -> FStar_Range.range =
  fun fv  ->
    let uu____4174 = lid_of_fv fv in FStar_Ident.range_of_lid uu____4174
let set_range_of_fv: fv -> FStar_Range.range -> fv =
  fun fv  ->
    fun r  ->
      let uu___97_4181 = fv in
      let uu____4182 =
        let uu___98_4186 = fv.fv_name in
        let uu____4191 =
          let uu____4192 = lid_of_fv fv in
          FStar_Ident.set_lid_range uu____4192 r in
        { v = uu____4191; ty = (uu___98_4186.ty); p = (uu___98_4186.p) } in
      {
        fv_name = uu____4182;
        fv_delta = (uu___97_4181.fv_delta);
        fv_qual = (uu___97_4181.fv_qual)
      }
let has_simple_attribute: term Prims.list -> Prims.string -> Prims.bool =
  fun l  ->
    fun s  ->
      FStar_List.existsb
        (fun uu___93_4216  ->
           match uu___93_4216 with
           | { n = Tm_constant (FStar_Const.Const_string (data,uu____4220));
               tk = uu____4221; pos = uu____4222; vars = uu____4223;_} when
               (FStar_Util.string_of_unicode data) = s -> true
           | uu____4228 -> false) l