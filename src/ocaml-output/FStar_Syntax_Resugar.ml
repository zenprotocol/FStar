open Prims
let bv_as_unique_ident: FStar_Syntax_Syntax.bv -> FStar_Ident.ident =
  fun x  ->
    let unique_name = (x.FStar_Syntax_Syntax.ppname).FStar_Ident.idText in
    FStar_Ident.mk_ident
      (unique_name, ((x.FStar_Syntax_Syntax.ppname).FStar_Ident.idRange))
let resugar_arg_qual:
  FStar_Syntax_Syntax.arg_qualifier Prims.option ->
    FStar_Parser_AST.arg_qualifier Prims.option
  =
  fun q  ->
    match q with
    | None  -> None
    | Some (FStar_Syntax_Syntax.Implicit b) -> Some FStar_Parser_AST.Implicit
    | Some (FStar_Syntax_Syntax.Equality ) -> Some FStar_Parser_AST.Equality
let rec universe_to_int:
  Prims.int ->
    FStar_Syntax_Syntax.universe -> (Prims.int* FStar_Syntax_Syntax.universe)
  =
  fun n1  ->
    fun u  ->
      match u with
      | FStar_Syntax_Syntax.U_succ u1 ->
          universe_to_int (n1 + (Prims.parse_int "1")) u1
      | uu____25 -> (n1, u)
let rec resugar_universe:
  FStar_Syntax_Syntax.universe -> FStar_Range.range -> FStar_Parser_AST.term
  =
  fun u  ->
    fun r  ->
      let mk1 a r1 = FStar_Parser_AST.mk_term a r1 FStar_Parser_AST.Un in
      match u with
      | FStar_Syntax_Syntax.U_zero  ->
          mk1 (FStar_Parser_AST.Const (FStar_Const.Const_int ("0", None))) r
      | FStar_Syntax_Syntax.U_succ uu____44 ->
          let uu____45 = universe_to_int (Prims.parse_int "0") u in
          (match uu____45 with
           | (n1,u1) ->
               (match u1 with
                | FStar_Syntax_Syntax.U_zero  ->
                    let uu____50 =
                      let uu____51 =
                        let uu____52 =
                          let uu____58 = FStar_Util.string_of_int n1 in
                          (uu____58, None) in
                        FStar_Const.Const_int uu____52 in
                      FStar_Parser_AST.Const uu____51 in
                    mk1 uu____50 r
                | uu____64 ->
                    let e1 =
                      let uu____66 =
                        let uu____67 =
                          let uu____68 =
                            let uu____74 = FStar_Util.string_of_int n1 in
                            (uu____74, None) in
                          FStar_Const.Const_int uu____68 in
                        FStar_Parser_AST.Const uu____67 in
                      mk1 uu____66 r in
                    let e2 = resugar_universe u1 r in
                    mk1 (FStar_Parser_AST.Op ("+", [e1; e2])) r))
      | FStar_Syntax_Syntax.U_max l ->
          (match l with
           | [] -> failwith "Impossible: U_max without arguments"
           | uu____84 ->
               let t =
                 let uu____87 =
                   let uu____88 = FStar_Ident.lid_of_path ["max"] r in
                   FStar_Parser_AST.Var uu____88 in
                 mk1 uu____87 r in
               FStar_List.fold_left
                 (fun acc  ->
                    fun x  ->
                      let uu____91 =
                        let uu____92 =
                          let uu____96 = resugar_universe x r in
                          (acc, uu____96, FStar_Parser_AST.Nothing) in
                        FStar_Parser_AST.App uu____92 in
                      mk1 uu____91 r) t l)
      | FStar_Syntax_Syntax.U_name u1 -> mk1 (FStar_Parser_AST.Uvar u1) r
      | FStar_Syntax_Syntax.U_unif uu____98 -> mk1 FStar_Parser_AST.Wild r
      | FStar_Syntax_Syntax.U_bvar x ->
          let id =
            let uu____103 =
              let uu____106 =
                let uu____107 = FStar_Util.string_of_int x in
                FStar_Util.strcat "uu__univ_bvar_" uu____107 in
              (uu____106, r) in
            FStar_Ident.mk_ident uu____103 in
          mk1 (FStar_Parser_AST.Uvar id) r
      | FStar_Syntax_Syntax.U_unknown  -> mk1 FStar_Parser_AST.Wild r
let string_to_op: Prims.string -> Prims.string Prims.option =
  fun s  ->
    let name_of_op uu___192_116 =
      match uu___192_116 with
      | "Amp" -> Some "&"
      | "At" -> Some "@"
      | "Plus" -> Some "+"
      | "Minus" -> Some "-"
      | "Subtraction" -> Some "-"
      | "Slash" -> Some "/"
      | "Less" -> Some "<"
      | "Equals" -> Some "="
      | "Greater" -> Some ">"
      | "Underscore" -> Some "_"
      | "Bar" -> Some "|"
      | "Bang" -> Some "!"
      | "Hat" -> Some "^"
      | "Percent" -> Some "%"
      | "Star" -> Some "*"
      | "Question" -> Some "?"
      | "Colon" -> Some ":"
      | uu____118 -> None in
    match s with
    | "op_String_Assignment" -> Some ".[]<-"
    | "op_Array_Assignment" -> Some ".()<-"
    | "op_String_Access" -> Some ".[]"
    | "op_Array_Access" -> Some ".()"
    | uu____120 ->
        if FStar_Util.starts_with s "op_"
        then
          let s1 =
            let uu____124 =
              FStar_Util.substring_from s (FStar_String.length "op_") in
            FStar_Util.split uu____124 "_" in
          (match s1 with
           | op::[] -> name_of_op op
           | uu____129 ->
               let op =
                 let uu____132 = FStar_List.map name_of_op s1 in
                 FStar_List.fold_left
                   (fun acc  ->
                      fun x  ->
                        match x with
                        | Some op -> Prims.strcat acc op
                        | None  -> failwith "wrong composed operator format")
                   "" uu____132 in
               Some op)
        else None
let rec resugar_term_as_op:
  FStar_Syntax_Syntax.term -> Prims.string Prims.option =
  fun t  ->
    let infix_prim_ops =
      [(FStar_Syntax_Const.op_Addition, "+");
      (FStar_Syntax_Const.op_Subtraction, "-");
      (FStar_Syntax_Const.op_Minus, "-");
      (FStar_Syntax_Const.op_Multiply, "*");
      (FStar_Syntax_Const.op_Division, "/");
      (FStar_Syntax_Const.op_Modulus, "%");
      (FStar_Syntax_Const.read_lid, "!");
      (FStar_Syntax_Const.list_append_lid, "@");
      (FStar_Syntax_Const.list_tot_append_lid, "@");
      (FStar_Syntax_Const.strcat_lid, "^");
      (FStar_Syntax_Const.pipe_right_lid, "|>");
      (FStar_Syntax_Const.pipe_left_lid, "<|");
      (FStar_Syntax_Const.op_Eq, "=");
      (FStar_Syntax_Const.op_ColonEq, ":=");
      (FStar_Syntax_Const.op_notEq, "<>");
      (FStar_Syntax_Const.not_lid, "~");
      (FStar_Syntax_Const.op_And, "&&");
      (FStar_Syntax_Const.op_Or, "||");
      (FStar_Syntax_Const.op_LTE, "<=");
      (FStar_Syntax_Const.op_GTE, ">=");
      (FStar_Syntax_Const.op_LT, "<");
      (FStar_Syntax_Const.op_GT, ">");
      (FStar_Syntax_Const.op_Modulus, "mod");
      (FStar_Syntax_Const.and_lid, "/\\");
      (FStar_Syntax_Const.or_lid, "\\/");
      (FStar_Syntax_Const.imp_lid, "==>");
      (FStar_Syntax_Const.iff_lid, "<==>");
      (FStar_Syntax_Const.precedes_lid, "<<");
      (FStar_Syntax_Const.eq2_lid, "==");
      (FStar_Syntax_Const.precedes_lid, "<<");
      (FStar_Syntax_Const.eq3_lid, "===");
      (FStar_Syntax_Const.forall_lid, "forall");
      (FStar_Syntax_Const.exists_lid, "exists");
      (FStar_Syntax_Const.salloc_lid, "alloc")] in
    let fallback fv =
      let uu____226 =
        FStar_All.pipe_right infix_prim_ops
          (FStar_Util.find_opt
             (fun d  -> FStar_Syntax_Syntax.fv_eq_lid fv (Prims.fst d))) in
      match uu____226 with
      | Some op -> Some (Prims.snd op)
      | uu____247 ->
          let length1 =
            FStar_String.length
              ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.nsstr in
          let str =
            if length1 = (Prims.parse_int "0")
            then
              ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.str
            else
              FStar_Util.substring_from
                ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.str
                (length1 + (Prims.parse_int "1")) in
          if FStar_Util.starts_with str "dtuple"
          then Some "dtuple"
          else
            if FStar_Util.starts_with str "tuple"
            then Some "tuple"
            else
              if FStar_Util.starts_with str "try_with"
              then Some "try_with"
              else
                (let uu____278 =
                   FStar_Syntax_Syntax.fv_eq_lid fv
                     FStar_Syntax_Const.sread_lid in
                 if uu____278
                 then
                   Some
                     (((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.str)
                 else None) in
    let uu____285 =
      let uu____286 = FStar_Syntax_Subst.compress t in
      uu____286.FStar_Syntax_Syntax.n in
    match uu____285 with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        let length1 =
          FStar_String.length
            ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.nsstr in
        let s =
          if length1 = (Prims.parse_int "0")
          then
            ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.str
          else
            FStar_Util.substring_from
              ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.str
              (length1 + (Prims.parse_int "1")) in
        let uu____312 = string_to_op s in
        (match uu____312 with | Some t1 -> Some t1 | uu____316 -> fallback fv)
    | FStar_Syntax_Syntax.Tm_uinst (e,us) -> resugar_term_as_op e
    | uu____324 -> None
let is_true_pat: FStar_Syntax_Syntax.pat -> Prims.bool =
  fun p  ->
    match p.FStar_Syntax_Syntax.v with
    | FStar_Syntax_Syntax.Pat_constant (FStar_Const.Const_bool (true )) ->
        true
    | uu____328 -> false
let is_wild_pat: FStar_Syntax_Syntax.pat -> Prims.bool =
  fun p  ->
    match p.FStar_Syntax_Syntax.v with
    | FStar_Syntax_Syntax.Pat_wild uu____332 -> true
    | uu____333 -> false
let rec resugar_term: FStar_Syntax_Syntax.term -> FStar_Parser_AST.term =
  fun t  ->
    let mk1 a =
      FStar_Parser_AST.mk_term a t.FStar_Syntax_Syntax.pos
        FStar_Parser_AST.Un in
    let name a r =
      let uu____360 = FStar_Ident.lid_of_path [a] r in
      FStar_Parser_AST.Name uu____360 in
    let var a r =
      let uu____368 = FStar_Ident.lid_of_path [a] r in
      FStar_Parser_AST.Var uu____368 in
    let uu____369 =
      let uu____370 = FStar_Syntax_Subst.compress t in
      uu____370.FStar_Syntax_Syntax.n in
    match uu____369 with
    | FStar_Syntax_Syntax.Tm_delayed uu____373 ->
        failwith "Tm_delayed is impossible after compress"
    | FStar_Syntax_Syntax.Tm_bvar x ->
        let l =
          let uu____396 = let uu____398 = bv_as_unique_ident x in [uu____398] in
          FStar_Ident.lid_of_ids uu____396 in
        mk1 (FStar_Parser_AST.Var l)
    | FStar_Syntax_Syntax.Tm_name x ->
        let l =
          let uu____401 = let uu____403 = bv_as_unique_ident x in [uu____403] in
          FStar_Ident.lid_of_ids uu____401 in
        mk1 (FStar_Parser_AST.Var l)
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        let a = (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
        let length1 =
          FStar_String.length
            ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.nsstr in
        let s =
          if length1 = (Prims.parse_int "0")
          then a.FStar_Ident.str
          else
            FStar_Util.substring_from a.FStar_Ident.str
              (length1 + (Prims.parse_int "1")) in
        let is_prefix = Prims.strcat FStar_Ident.reserved_prefix "is_" in
        if FStar_Util.starts_with s is_prefix
        then
          let rest =
            FStar_Util.substring_from s (FStar_String.length is_prefix) in
          let uu____427 =
            let uu____428 =
              FStar_Ident.lid_of_path [rest] t.FStar_Syntax_Syntax.pos in
            FStar_Parser_AST.Discrim uu____428 in
          mk1 uu____427
        else
          if
            FStar_Util.starts_with s FStar_Syntax_Util.field_projector_prefix
          then
            (let rest =
               FStar_Util.substring_from s
                 (FStar_String.length
                    FStar_Syntax_Util.field_projector_prefix) in
             let r =
               FStar_Util.split rest FStar_Syntax_Util.field_projector_sep in
             match r with
             | fst1::snd1::[] ->
                 let l =
                   FStar_Ident.lid_of_path [fst1] t.FStar_Syntax_Syntax.pos in
                 let r1 =
                   FStar_Ident.mk_ident (snd1, (t.FStar_Syntax_Syntax.pos)) in
                 mk1 (FStar_Parser_AST.Projector (l, r1))
             | uu____439 -> failwith "wrong projector format")
          else
            (let uu____442 =
               ((FStar_Ident.lid_equals a FStar_Syntax_Const.assert_lid) ||
                  (FStar_Ident.lid_equals a FStar_Syntax_Const.assume_lid))
                 ||
                 (let uu____443 =
                    let uu____444 = FStar_String.get s (Prims.parse_int "0") in
                    FStar_Char.uppercase uu____444 in
                  let uu____445 = FStar_String.get s (Prims.parse_int "0") in
                  uu____443 <> uu____445) in
             if uu____442
             then
               let uu____446 = var s t.FStar_Syntax_Syntax.pos in
               mk1 uu____446
             else
               (let uu____448 = name s t.FStar_Syntax_Syntax.pos in
                mk1 uu____448))
    | FStar_Syntax_Syntax.Tm_uinst (e,universes) ->
        let e1 = resugar_term e in
        FStar_List.fold_left
          (fun acc  ->
             fun x  ->
               let uu____458 =
                 let uu____459 =
                   let uu____463 =
                     resugar_universe x t.FStar_Syntax_Syntax.pos in
                   (acc, uu____463, FStar_Parser_AST.UnivApp) in
                 FStar_Parser_AST.App uu____459 in
               mk1 uu____458) e1 universes
    | FStar_Syntax_Syntax.Tm_constant c ->
        let uu____465 = FStar_Syntax_Syntax.is_teff t in
        if uu____465
        then
          let uu____466 = name "Effect" t.FStar_Syntax_Syntax.pos in
          mk1 uu____466
        else mk1 (FStar_Parser_AST.Const c)
    | FStar_Syntax_Syntax.Tm_type u ->
        (match u with
         | FStar_Syntax_Syntax.U_zero  ->
             let uu____469 = name "Type0" t.FStar_Syntax_Syntax.pos in
             mk1 uu____469
         | FStar_Syntax_Syntax.U_unknown  ->
             let uu____470 = name "Type" t.FStar_Syntax_Syntax.pos in
             mk1 uu____470
         | uu____471 ->
             let u1 = resugar_universe u t.FStar_Syntax_Syntax.pos in
             let l =
               FStar_Ident.lid_of_path ["Type"] t.FStar_Syntax_Syntax.pos in
             mk1
               (FStar_Parser_AST.Construct
                  (l, [(u1, FStar_Parser_AST.UnivApp)])))
    | FStar_Syntax_Syntax.Tm_abs (xs,body,uu____483) ->
        let uu____506 = FStar_Syntax_Subst.open_term xs body in
        (match uu____506 with
         | (xs1,body1) ->
             let patterns =
               FStar_All.pipe_right xs1
                 (FStar_List.map
                    (fun uu____516  ->
                       match uu____516 with
                       | (x,qual) -> resugar_bv_as_pat x qual)) in
             let body2 = resugar_term body1 in
             mk1 (FStar_Parser_AST.Abs (patterns, body2)))
    | FStar_Syntax_Syntax.Tm_arrow (xs,body) ->
        let uu____535 = FStar_Syntax_Subst.open_comp xs body in
        (match uu____535 with
         | (xs1,body1) ->
             let body2 = resugar_comp body1 in
             let xs2 =
               let uu____543 =
                 FStar_All.pipe_right xs1
                   (FStar_List.map
                      (fun uu____548  ->
                         match uu____548 with
                         | (b,qual) ->
                             resugar_bv_as_binder b t.FStar_Syntax_Syntax.pos)) in
               FStar_All.pipe_right uu____543 FStar_List.rev in
             let rec aux body3 uu___193_562 =
               match uu___193_562 with
               | [] -> body3
               | hd1::tl1 ->
                   let body4 = mk1 (FStar_Parser_AST.Product ([hd1], body3)) in
                   aux body4 tl1 in
             aux body2 xs2)
    | FStar_Syntax_Syntax.Tm_refine (x,phi) ->
        let uu____575 =
          let uu____578 =
            let uu____579 = FStar_Syntax_Syntax.mk_binder x in [uu____579] in
          FStar_Syntax_Subst.open_term uu____578 phi in
        (match uu____575 with
         | (x1,phi1) ->
             let uu____582 = FStar_List.hd x1 in
             (match uu____582 with
              | (b,uu____588) ->
                  let b1 = resugar_bv_as_binder b t.FStar_Syntax_Syntax.pos in
                  let uu____590 =
                    let uu____591 =
                      let uu____594 = resugar_term phi1 in (b1, uu____594) in
                    FStar_Parser_AST.Refine uu____591 in
                  mk1 uu____590))
    | FStar_Syntax_Syntax.Tm_app (e,args) ->
        let rec last1 uu___194_624 =
          match uu___194_624 with
          | hd1::[] -> [hd1]
          | hd1::tl1 -> last1 tl1
          | uu____671 -> failwith "last of an empty list" in
        let rec last_two uu___195_695 =
          match uu___195_695 with
          | []|_::[] ->
              failwith
                "last two elements of a list with less than two elements "
          | a1::a2::[] -> [a1; a2]
          | uu____758::t1 -> last_two t1 in
        let rec last_three uu___196_786 =
          match uu___196_786 with
          | []|_::[]|_::_::[] ->
              failwith
                "last three elements of a list with less than three elements "
          | a1::a2::a3::[] -> [a1; a2; a3]
          | uu____876::t1 -> last_three t1 in
        let resugar_as_app e1 args1 =
          let args2 =
            FStar_All.pipe_right args1
              (FStar_List.map
                 (fun uu____912  ->
                    match uu____912 with | (e2,qual) -> resugar_term e2)) in
          let e2 = resugar_term e1 in
          FStar_List.fold_left
            (fun acc  ->
               fun x  ->
                 mk1
                   (FStar_Parser_AST.App (acc, x, FStar_Parser_AST.Nothing)))
            e2 args2 in
        let uu____920 = resugar_term_as_op e in
        (match uu____920 with
         | None  -> resugar_as_app e args
         | Some "tuple" ->
             let args1 =
               FStar_All.pipe_right args
                 (FStar_List.map
                    (fun uu____932  ->
                       match uu____932 with | (e1,qual) -> resugar_term e1)) in
             (match args1 with
              | fst1::snd1::rest ->
                  let e1 = mk1 (FStar_Parser_AST.Op ("*", [fst1; snd1])) in
                  FStar_List.fold_left
                    (fun acc  ->
                       fun x  -> mk1 (FStar_Parser_AST.Op ("*", [e1; x]))) e1
                    rest
              | uu____946 -> failwith "tuple needs at least two arguments.")
         | Some "dtuple" ->
             let args1 = last1 args in
             let body =
               match args1 with
               | (b,uu____960)::[] -> b
               | uu____973 -> failwith "wrong arguments to dtuple" in
             let uu____981 =
               let uu____982 = FStar_Syntax_Subst.compress body in
               uu____982.FStar_Syntax_Syntax.n in
             (match uu____981 with
              | FStar_Syntax_Syntax.Tm_abs (xs,body1,uu____987) ->
                  let uu____1010 = FStar_Syntax_Subst.open_term xs body1 in
                  (match uu____1010 with
                   | (xs1,body2) ->
                       let xs2 =
                         FStar_All.pipe_right xs1
                           (FStar_List.map
                              (fun uu____1020  ->
                                 match uu____1020 with
                                 | (b,qual) ->
                                     resugar_bv_as_binder b
                                       t.FStar_Syntax_Syntax.pos)) in
                       let body3 = resugar_term body2 in
                       mk1 (FStar_Parser_AST.Sum (xs2, body3)))
              | uu____1027 ->
                  let args2 =
                    FStar_All.pipe_right args1
                      (FStar_List.map
                         (fun uu____1038  ->
                            match uu____1038 with
                            | (e1,qual) -> resugar_term e1)) in
                  let e1 = resugar_term e in
                  FStar_List.fold_left
                    (fun acc  ->
                       fun x  ->
                         mk1
                           (FStar_Parser_AST.App
                              (acc, x, FStar_Parser_AST.Nothing))) e1 args2)
         | Some ref_read when
             ref_read = FStar_Syntax_Const.sread_lid.FStar_Ident.str ->
             let uu____1047 = FStar_List.hd args in
             (match uu____1047 with
              | (t1,uu____1057) ->
                  let uu____1062 =
                    let uu____1063 = FStar_Syntax_Subst.compress t1 in
                    uu____1063.FStar_Syntax_Syntax.n in
                  (match uu____1062 with
                   | FStar_Syntax_Syntax.Tm_fvar fv when
                       FStar_Syntax_Util.field_projector_contains_constructor
                         ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.str
                       ->
                       let f =
                         FStar_Ident.lid_of_path
                           [((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.str]
                           t1.FStar_Syntax_Syntax.pos in
                       let uu____1076 =
                         let uu____1077 =
                           let uu____1080 = resugar_term t1 in
                           (uu____1080, f) in
                         FStar_Parser_AST.Project uu____1077 in
                       mk1 uu____1076
                   | uu____1081 -> resugar_term t1))
         | Some "try_with" ->
             let new_args = last_two args in
             let uu____1088 =
               match new_args with
               | (a1,uu____1102)::(a2,uu____1104)::[] -> (a1, a2)
               | uu____1129 -> failwith "wrong arguments to try_with" in
             (match uu____1088 with
              | (body,handler) ->
                  let decomp term =
                    let uu____1155 =
                      let uu____1156 = FStar_Syntax_Subst.compress term in
                      uu____1156.FStar_Syntax_Syntax.n in
                    match uu____1155 with
                    | FStar_Syntax_Syntax.Tm_abs (x,e1,uu____1161) ->
                        let uu____1184 = FStar_Syntax_Subst.open_term x e1 in
                        (match uu____1184 with | (x1,e2) -> e2)
                    | uu____1189 ->
                        failwith "wrong argument format to try_with" in
                  let body1 =
                    let uu____1191 = decomp body in resugar_term uu____1191 in
                  let handler1 =
                    let uu____1193 = decomp handler in
                    resugar_term uu____1193 in
                  let rec resugar_body t1 =
                    match t1.FStar_Parser_AST.tm with
                    | FStar_Parser_AST.Match
                        (e1,(uu____1199,uu____1200,b)::[]) -> b
                    | FStar_Parser_AST.Ascribed (t11,t2,t3) ->
                        let uu____1222 =
                          let uu____1223 =
                            let uu____1228 = resugar_body t11 in
                            (uu____1228, t2, t3) in
                          FStar_Parser_AST.Ascribed uu____1223 in
                        mk1 uu____1222
                    | uu____1230 ->
                        failwith "unexpected body format to try_with" in
                  let e1 = resugar_body body1 in
                  let rec resugar_branches t1 =
                    match t1.FStar_Parser_AST.tm with
                    | FStar_Parser_AST.Match (e2,branches) -> branches
                    | FStar_Parser_AST.Ascribed (t11,t2,t3) ->
                        resugar_branches t11
                    | uu____1263 -> [] in
                  let branches = resugar_branches handler1 in
                  mk1 (FStar_Parser_AST.TryWith (e1, branches)))
         | Some op when (op = "forall") || (op = "exists") ->
             let rec uncurry xs pat t1 =
               match t1.FStar_Parser_AST.tm with
               | FStar_Parser_AST.QExists (x,p,body)|FStar_Parser_AST.QForall
                 (x,p,body) ->
                   uncurry (FStar_List.append x xs) (FStar_List.append p pat)
                     body
               | uu____1324 -> (xs, pat, t1) in
             let resugar body =
               let uu____1332 =
                 let uu____1333 = FStar_Syntax_Subst.compress body in
                 uu____1333.FStar_Syntax_Syntax.n in
               match uu____1332 with
               | FStar_Syntax_Syntax.Tm_abs (xs,body1,uu____1338) ->
                   let uu____1361 = FStar_Syntax_Subst.open_term xs body1 in
                   (match uu____1361 with
                    | (xs1,body2) ->
                        let xs2 =
                          FStar_All.pipe_right xs1
                            (FStar_List.map
                               (fun uu____1371  ->
                                  match uu____1371 with
                                  | (b,qual) ->
                                      resugar_bv_as_binder b
                                        t.FStar_Syntax_Syntax.pos)) in
                        let uu____1376 =
                          let uu____1381 =
                            let uu____1382 =
                              FStar_Syntax_Subst.compress body2 in
                            uu____1382.FStar_Syntax_Syntax.n in
                          match uu____1381 with
                          | FStar_Syntax_Syntax.Tm_meta (e1,m) ->
                              let body3 = resugar_term e1 in
                              let resugar_pats pats =
                                FStar_List.map
                                  (fun es  ->
                                     FStar_All.pipe_right es
                                       (FStar_List.map
                                          (fun uu____1424  ->
                                             match uu____1424 with
                                             | (e2,uu____1428) ->
                                                 resugar_term e2))) pats in
                              let pats =
                                match m with
                                | FStar_Syntax_Syntax.Meta_pattern pats ->
                                    resugar_pats pats
                                | FStar_Syntax_Syntax.Meta_labeled
                                    (s,r,uu____1443) ->
                                    let uu____1444 =
                                      let uu____1446 =
                                        let uu____1447 = name s r in
                                        mk1 uu____1447 in
                                      [uu____1446] in
                                    [uu____1444]
                                | uu____1450 ->
                                    failwith
                                      "wrong pattern format for QForall/QExists" in
                              (pats, body3)
                          | uu____1455 ->
                              let uu____1456 = resugar_term body2 in
                              ([], uu____1456) in
                        (match uu____1376 with
                         | (pats,body3) ->
                             let uu____1466 = uncurry xs2 pats body3 in
                             (match uu____1466 with
                              | (xs3,pats1,body4) ->
                                  let xs4 =
                                    FStar_All.pipe_right xs3 FStar_List.rev in
                                  if op = "forall"
                                  then
                                    mk1
                                      (FStar_Parser_AST.QForall
                                         (xs4, pats1, body4))
                                  else
                                    mk1
                                      (FStar_Parser_AST.QExists
                                         (xs4, pats1, body4)))))
               | uu____1493 ->
                   if op = "forall"
                   then
                     let uu____1494 =
                       let uu____1495 =
                         let uu____1502 = resugar_term body in
                         ([], [[]], uu____1502) in
                       FStar_Parser_AST.QForall uu____1495 in
                     mk1 uu____1494
                   else
                     (let uu____1509 =
                        let uu____1510 =
                          let uu____1517 = resugar_term body in
                          ([], [[]], uu____1517) in
                        FStar_Parser_AST.QExists uu____1510 in
                      mk1 uu____1509) in
             let args1 = last1 args in
             (match args1 with
              | (b,uu____1530)::[] -> resugar b
              | uu____1543 -> failwith "wrong args format to QForall")
         | Some "alloc" ->
             let uu____1549 = FStar_List.hd args in
             (match uu____1549 with | (e1,uu____1559) -> resugar_term e1)
         | Some op ->
             let resugar args1 =
               FStar_All.pipe_right args1
                 (FStar_List.map
                    (fun uu____1582  ->
                       match uu____1582 with | (e1,qual) -> resugar_term e1)) in
             let uu____1587 =
               FStar_Parser_ToDocument.handleable_args_length op in
             (match uu____1587 with
              | _0_27 when _0_27 = (Prims.parse_int "1") ->
                  let uu____1588 =
                    let uu____1589 =
                      let uu____1593 =
                        let uu____1595 = last1 args in resugar uu____1595 in
                      (op, uu____1593) in
                    FStar_Parser_AST.Op uu____1589 in
                  mk1 uu____1588
              | _0_28 when _0_28 = (Prims.parse_int "2") ->
                  let uu____1600 =
                    let uu____1601 =
                      let uu____1605 =
                        let uu____1607 = last_two args in resugar uu____1607 in
                      (op, uu____1605) in
                    FStar_Parser_AST.Op uu____1601 in
                  mk1 uu____1600
              | _0_29 when _0_29 = (Prims.parse_int "3") ->
                  let uu____1612 =
                    let uu____1613 =
                      let uu____1617 =
                        let uu____1619 = last_three args in
                        resugar uu____1619 in
                      (op, uu____1617) in
                    FStar_Parser_AST.Op uu____1613 in
                  mk1 uu____1612
              | uu____1624 -> resugar_as_app e args))
    | FStar_Syntax_Syntax.Tm_match
        (e,(pat1,uu____1627,t1)::(pat2,uu____1630,t2)::[]) when
        (is_true_pat pat1) && (is_wild_pat pat2) ->
        let uu____1705 =
          let uu____1706 =
            let uu____1710 = resugar_term e in
            let uu____1711 = resugar_term t1 in
            let uu____1712 = resugar_term t2 in
            (uu____1710, uu____1711, uu____1712) in
          FStar_Parser_AST.If uu____1706 in
        mk1 uu____1705
    | FStar_Syntax_Syntax.Tm_match (e,branches) ->
        let resugar_branch uu____1752 =
          match uu____1752 with
          | (pat,wopt,b) ->
              let pat1 = resugar_match_pat pat in
              let wopt1 =
                match wopt with
                | None  -> None
                | Some e1 ->
                    let uu____1771 = resugar_term e1 in Some uu____1771 in
              let b1 = resugar_term b in (pat1, wopt1, b1) in
        let uu____1774 =
          let uu____1775 =
            let uu____1783 = resugar_term e in
            let uu____1784 = FStar_List.map resugar_branch branches in
            (uu____1783, uu____1784) in
          FStar_Parser_AST.Match uu____1775 in
        mk1 uu____1774
    | FStar_Syntax_Syntax.Tm_ascribed (e,(asc,tac_opt),uu____1806) ->
        let term =
          match asc with
          | FStar_Util.Inl n1 -> resugar_term n1
          | FStar_Util.Inr n1 -> resugar_comp n1 in
        let tac_opt1 = FStar_Option.map resugar_term tac_opt in
        let uu____1859 =
          let uu____1860 =
            let uu____1865 = resugar_term e in (uu____1865, term, tac_opt1) in
          FStar_Parser_AST.Ascribed uu____1860 in
        mk1 uu____1859
    | FStar_Syntax_Syntax.Tm_let ((is_rec,bnds),body) ->
        let mk_pat a =
          FStar_Parser_AST.mk_pattern a t.FStar_Syntax_Syntax.pos in
        let uu____1883 = FStar_Syntax_Subst.open_let_rec bnds body in
        (match uu____1883 with
         | (bnd,body1) ->
             let resugar_one_binding bnd1 =
               let uu____1899 =
                 let uu____1902 =
                   FStar_Syntax_Util.mk_conj bnd1.FStar_Syntax_Syntax.lbtyp
                     bnd1.FStar_Syntax_Syntax.lbdef in
                 FStar_Syntax_Subst.open_univ_vars
                   bnd1.FStar_Syntax_Syntax.lbunivs uu____1902 in
               match uu____1899 with
               | (univs1,td) ->
                   let uu____1909 =
                     let uu____1916 =
                       let uu____1917 = FStar_Syntax_Subst.compress td in
                       uu____1917.FStar_Syntax_Syntax.n in
                     match uu____1916 with
                     | FStar_Syntax_Syntax.Tm_app
                         (uu____1926,(t1,uu____1928)::(d,uu____1930)::[]) ->
                         (t1, d)
                     | uu____1964 -> failwith "wrong let binding format" in
                   (match uu____1909 with
                    | (typ,def) ->
                        let uu____1985 =
                          let uu____1989 =
                            let uu____1990 = FStar_Syntax_Subst.compress def in
                            uu____1990.FStar_Syntax_Syntax.n in
                          match uu____1989 with
                          | FStar_Syntax_Syntax.Tm_abs (b,t1,uu____1998) ->
                              let uu____2021 =
                                FStar_Syntax_Subst.open_term b t1 in
                              (match uu____2021 with
                               | (b1,t2) -> (b1, t2, true))
                          | uu____2029 -> ([], def, false) in
                        (match uu____1985 with
                         | (binders,term,is_pat_app) ->
                             let uu____2044 =
                               match bnd1.FStar_Syntax_Syntax.lbname with
                               | FStar_Util.Inr fv ->
                                   ((mk_pat
                                       (FStar_Parser_AST.PatName
                                          ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v))),
                                     term)
                               | FStar_Util.Inl bv ->
                                   let uu____2055 =
                                     let uu____2058 =
                                       let uu____2059 =
                                         FStar_Syntax_Syntax.mk_binder bv in
                                       [uu____2059] in
                                     FStar_Syntax_Subst.open_term uu____2058
                                       term in
                                   (match uu____2055 with
                                    | (x,term1) ->
                                        let uu____2064 = FStar_List.hd x in
                                        (match uu____2064 with
                                         | (bv1,uu____2072) ->
                                             let uu____2073 =
                                               let uu____2074 =
                                                 let uu____2075 =
                                                   let uu____2079 =
                                                     bv_as_unique_ident bv1 in
                                                   (uu____2079, None) in
                                                 FStar_Parser_AST.PatVar
                                                   uu____2075 in
                                               mk_pat uu____2074 in
                                             (uu____2073, term1))) in
                             (match uu____2044 with
                              | (pat,term1) ->
                                  if is_pat_app
                                  then
                                    let args =
                                      FStar_All.pipe_right binders
                                        (FStar_List.map
                                           (fun uu____2096  ->
                                              match uu____2096 with
                                              | (bv,uu____2100) ->
                                                  let uu____2101 =
                                                    let uu____2102 =
                                                      let uu____2106 =
                                                        bv_as_unique_ident bv in
                                                      (uu____2106, None) in
                                                    FStar_Parser_AST.PatVar
                                                      uu____2102 in
                                                  mk_pat uu____2101)) in
                                    let uu____2108 =
                                      let uu____2111 = resugar_term term1 in
                                      ((mk_pat
                                          (FStar_Parser_AST.PatApp
                                             (pat, args))), uu____2111) in
                                    let uu____2113 =
                                      let uu____2114 =
                                        FStar_List.map
                                          (fun x  -> x.FStar_Ident.idText)
                                          univs1 in
                                      FStar_All.pipe_right uu____2114
                                        (FStar_String.concat ", ") in
                                    (uu____2108, uu____2113)
                                  else
                                    (let uu____2121 =
                                       let uu____2124 = resugar_term term1 in
                                       (pat, uu____2124) in
                                     let uu____2125 =
                                       let uu____2126 =
                                         FStar_List.map
                                           (fun x  -> x.FStar_Ident.idText)
                                           univs1 in
                                       FStar_All.pipe_right uu____2126
                                         (FStar_String.concat ", ") in
                                     (uu____2121, uu____2125))))) in
             let r = FStar_List.map resugar_one_binding bnds in
             let bnds1 = FStar_List.map Prims.fst r in
             let comments = FStar_List.map Prims.snd r in
             let body2 = resugar_term body1 in
             mk1
               (FStar_Parser_AST.Let
                  ((if is_rec
                    then FStar_Parser_AST.Rec
                    else FStar_Parser_AST.NoLetQualifier), bnds1, body2)))
    | FStar_Syntax_Syntax.Tm_uvar (u,uu____2168) ->
        let s =
          let uu____2182 =
            let uu____2183 = FStar_Unionfind.uvar_id u in
            FStar_All.pipe_right uu____2183 FStar_Util.string_of_int in
          Prims.strcat "uu___unification_ " uu____2182 in
        let uu____2187 = var s t.FStar_Syntax_Syntax.pos in mk1 uu____2187
    | FStar_Syntax_Syntax.Tm_meta (e,m) ->
        let resugar_meta_desugared uu___197_2197 =
          match uu___197_2197 with
          | FStar_Syntax_Syntax.Data_app  ->
              let uu____2198 =
                let uu____2199 = FStar_Syntax_Subst.compress e in
                uu____2199.FStar_Syntax_Syntax.n in
              (match uu____2198 with
               | FStar_Syntax_Syntax.Tm_app (head1,args) ->
                   let rec aux h =
                     let uu____2225 =
                       let uu____2226 = FStar_Syntax_Subst.compress h in
                       uu____2226.FStar_Syntax_Syntax.n in
                     match uu____2225 with
                     | FStar_Syntax_Syntax.Tm_fvar fv ->
                         let uu____2233 = FStar_Syntax_Syntax.lid_of_fv fv in
                         (uu____2233, [])
                     | FStar_Syntax_Syntax.Tm_uinst (h1,u) ->
                         let uu____2241 = aux h1 in
                         (match uu____2241 with
                          | (h2,l) -> (h2, (FStar_List.append l u)))
                     | uu____2253 -> failwith "wrong Data_app head format" in
                   let uu____2257 = aux head1 in
                   (match uu____2257 with
                    | (head2,universes) ->
                        let universes1 =
                          FStar_List.map
                            (fun u  ->
                               let uu____2272 =
                                 resugar_universe u t.FStar_Syntax_Syntax.pos in
                               (uu____2272, FStar_Parser_AST.UnivApp))
                            universes in
                        let args1 =
                          FStar_List.map
                            (fun uu____2281  ->
                               match uu____2281 with
                               | (t1,uu____2287) ->
                                   let uu____2288 = resugar_term t1 in
                                   (uu____2288, FStar_Parser_AST.Nothing))
                            args in
                        if FStar_Syntax_Util.is_tuple_data_lid' head2
                        then mk1 (FStar_Parser_AST.Construct (head2, args1))
                        else
                          mk1
                            (FStar_Parser_AST.Construct
                               (head2, (FStar_List.append args1 universes1))))
               | FStar_Syntax_Syntax.Tm_meta (uu____2298,m1) ->
                   (match m1 with
                    | FStar_Syntax_Syntax.Meta_monadic
                        (uu____2304,uu____2305) -> resugar_term e
                    | uu____2310 ->
                        failwith "wrong Tm_meta format in Meta_desugared")
               | uu____2311 -> failwith "wrong Data_app format")
          | FStar_Syntax_Syntax.Sequence  ->
              let term = resugar_term e in
              let rec resugar_seq t1 =
                match t1.FStar_Parser_AST.tm with
                | FStar_Parser_AST.Let (uu____2317,(p,t11)::[],t2) ->
                    mk1 (FStar_Parser_AST.Seq (t11, t2))
                | FStar_Parser_AST.Ascribed (t11,t2,t3) ->
                    let uu____2333 =
                      let uu____2334 =
                        let uu____2339 = resugar_seq t11 in
                        (uu____2339, t2, t3) in
                      FStar_Parser_AST.Ascribed uu____2334 in
                    mk1 uu____2333
                | uu____2341 -> t1 in
              resugar_seq term
          | FStar_Syntax_Syntax.Primop 
            |FStar_Syntax_Syntax.Masked_effect 
             |FStar_Syntax_Syntax.Meta_smt_pat  -> resugar_term e
          | FStar_Syntax_Syntax.Mutable_alloc  ->
              let term = resugar_term e in
              (match term.FStar_Parser_AST.tm with
               | FStar_Parser_AST.Let (FStar_Parser_AST.NoLetQualifier ,l,t1)
                   ->
                   mk1
                     (FStar_Parser_AST.Let (FStar_Parser_AST.Mutable, l, t1))
               | uu____2354 ->
                   failwith
                     "mutable_alloc should have let term with no qualifier")
          | FStar_Syntax_Syntax.Mutable_rval  ->
              let fv =
                FStar_Syntax_Syntax.lid_as_fv FStar_Syntax_Const.sread_lid
                  FStar_Syntax_Syntax.Delta_constant None in
              let uu____2356 =
                let uu____2357 = FStar_Syntax_Subst.compress e in
                uu____2357.FStar_Syntax_Syntax.n in
              (match uu____2356 with
               | FStar_Syntax_Syntax.Tm_app
                   ({
                      FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar fv1;
                      FStar_Syntax_Syntax.tk = uu____2361;
                      FStar_Syntax_Syntax.pos = uu____2362;
                      FStar_Syntax_Syntax.vars = uu____2363;_},(term,uu____2365)::[])
                   -> resugar_term term
               | uu____2387 -> failwith "mutable_rval should have app term") in
        (match m with
         | FStar_Syntax_Syntax.Meta_pattern pats ->
             let pats1 =
               FStar_All.pipe_right (FStar_List.flatten pats)
                 (FStar_List.map
                    (fun uu____2409  ->
                       match uu____2409 with
                       | (x,uu____2413) -> resugar_term x)) in
             mk1 (FStar_Parser_AST.Attributes pats1)
         | FStar_Syntax_Syntax.Meta_labeled (l,uu____2415,p) ->
             let uu____2417 =
               let uu____2418 =
                 let uu____2422 = resugar_term e in (uu____2422, l, p) in
               FStar_Parser_AST.Labeled uu____2418 in
             mk1 uu____2417
         | FStar_Syntax_Syntax.Meta_desugared i -> resugar_meta_desugared i
         | FStar_Syntax_Syntax.Meta_named t1 ->
             mk1 (FStar_Parser_AST.Name t1)
         | FStar_Syntax_Syntax.Meta_monadic (name1,t1)
           |FStar_Syntax_Syntax.Meta_monadic_lift (name1,_,t1) ->
             let uu____2436 =
               let uu____2437 =
                 let uu____2442 = resugar_term e in
                 let uu____2443 =
                   let uu____2444 =
                     let uu____2445 =
                       let uu____2451 =
                         let uu____2455 =
                           let uu____2458 = resugar_term t1 in
                           (uu____2458, FStar_Parser_AST.Nothing) in
                         [uu____2455] in
                       (name1, uu____2451) in
                     FStar_Parser_AST.Construct uu____2445 in
                   mk1 uu____2444 in
                 (uu____2442, uu____2443, None) in
               FStar_Parser_AST.Ascribed uu____2437 in
             mk1 uu____2436)
    | FStar_Syntax_Syntax.Tm_unknown  -> mk1 FStar_Parser_AST.Wild
and resugar_comp: FStar_Syntax_Syntax.comp -> FStar_Parser_AST.term =
  fun c  ->
    let mk1 a =
      FStar_Parser_AST.mk_term a c.FStar_Syntax_Syntax.pos
        FStar_Parser_AST.Un in
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Total (typ,u) ->
        let t = resugar_term typ in
        (match u with
         | None  ->
             mk1
               (FStar_Parser_AST.Construct
                  (FStar_Syntax_Const.effect_Tot_lid,
                    [(t, FStar_Parser_AST.Nothing)]))
         | Some u1 ->
             let u2 = resugar_universe u1 c.FStar_Syntax_Syntax.pos in
             mk1
               (FStar_Parser_AST.Construct
                  (FStar_Syntax_Const.effect_Tot_lid,
                    [(u2, FStar_Parser_AST.UnivApp);
                    (t, FStar_Parser_AST.Nothing)])))
    | FStar_Syntax_Syntax.GTotal (typ,u) ->
        let t = resugar_term typ in
        (match u with
         | None  ->
             mk1
               (FStar_Parser_AST.Construct
                  (FStar_Syntax_Const.effect_GTot_lid,
                    [(t, FStar_Parser_AST.Nothing)]))
         | Some u1 ->
             let u2 = resugar_universe u1 c.FStar_Syntax_Syntax.pos in
             mk1
               (FStar_Parser_AST.Construct
                  (FStar_Syntax_Const.effect_GTot_lid,
                    [(u2, FStar_Parser_AST.UnivApp);
                    (t, FStar_Parser_AST.Nothing)])))
    | FStar_Syntax_Syntax.Comp c1 ->
        let universe =
          FStar_List.map (fun u  -> resugar_universe u)
            c1.FStar_Syntax_Syntax.comp_univs in
        let result =
          let uu____2537 = resugar_term c1.FStar_Syntax_Syntax.result_typ in
          (uu____2537, FStar_Parser_AST.Nothing) in
        let args =
          if
            FStar_Ident.lid_equals c1.FStar_Syntax_Syntax.effect_name
              FStar_Syntax_Const.effect_Lemma_lid
          then
            let rec aux l uu___198_2570 =
              match uu___198_2570 with
              | [] -> l
              | (t,aq)::tl1 ->
                  (match t.FStar_Syntax_Syntax.n with
                   | FStar_Syntax_Syntax.Tm_fvar fv when
                       FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Syntax_Const.true_lid
                       -> aux l tl1
                   | FStar_Syntax_Syntax.Tm_meta uu____2612 -> aux l tl1
                   | uu____2617 -> aux ((t, aq) :: l) tl1) in
            aux [] c1.FStar_Syntax_Syntax.effect_args
          else c1.FStar_Syntax_Syntax.effect_args in
        let args1 =
          FStar_List.map
            (fun uu____2637  ->
               match uu____2637 with
               | (e,uu____2643) ->
                   let uu____2644 = resugar_term e in
                   (uu____2644, FStar_Parser_AST.Nothing)) args in
        let rec aux l uu___199_2658 =
          match uu___199_2658 with
          | [] -> l
          | hd1::tl1 ->
              (match hd1 with
               | FStar_Syntax_Syntax.DECREASES e ->
                   let e1 =
                     let uu____2678 = resugar_term e in
                     (uu____2678, FStar_Parser_AST.Nothing) in
                   aux (e1 :: l) tl1
               | uu____2681 -> aux l tl1) in
        let decrease = aux [] c1.FStar_Syntax_Syntax.flags in
        mk1
          (FStar_Parser_AST.Construct
             ((c1.FStar_Syntax_Syntax.effect_name),
               (FStar_List.append (result :: decrease) args1)))
and resugar_bv_as_binder:
  FStar_Syntax_Syntax.bv -> FStar_Range.range -> FStar_Parser_AST.binder =
  fun x  ->
    fun r  ->
      let e = resugar_term x.FStar_Syntax_Syntax.sort in
      match e.FStar_Parser_AST.tm with
      | FStar_Parser_AST.Wild  ->
          let uu____2698 =
            let uu____2699 = bv_as_unique_ident x in
            FStar_Parser_AST.Variable uu____2699 in
          FStar_Parser_AST.mk_binder uu____2698 r FStar_Parser_AST.Type_level
            None
      | uu____2700 ->
          let uu____2701 = FStar_Syntax_Syntax.is_null_bv x in
          if uu____2701
          then
            FStar_Parser_AST.mk_binder (FStar_Parser_AST.NoName e) r
              FStar_Parser_AST.Type_level None
          else
            (let uu____2703 =
               let uu____2704 =
                 let uu____2707 = bv_as_unique_ident x in (uu____2707, e) in
               FStar_Parser_AST.Annotated uu____2704 in
             FStar_Parser_AST.mk_binder uu____2703 r
               FStar_Parser_AST.Type_level None)
and resugar_bv_as_pat:
  FStar_Syntax_Syntax.bv ->
    FStar_Syntax_Syntax.aqual -> FStar_Parser_AST.pattern
  =
  fun x  ->
    fun qual  ->
      let mk1 a =
        let uu____2714 = FStar_Syntax_Syntax.range_of_bv x in
        FStar_Parser_AST.mk_pattern a uu____2714 in
      let uu____2715 =
        let uu____2716 =
          FStar_Syntax_Subst.compress x.FStar_Syntax_Syntax.sort in
        uu____2716.FStar_Syntax_Syntax.n in
      match uu____2715 with
      | FStar_Syntax_Syntax.Tm_unknown  ->
          let i =
            FStar_String.compare
              (x.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
              FStar_Ident.reserved_prefix in
          if i = (Prims.parse_int "0")
          then mk1 FStar_Parser_AST.PatWild
          else
            (let uu____2721 =
               let uu____2722 =
                 let uu____2726 = bv_as_unique_ident x in
                 let uu____2727 = resugar_arg_qual qual in
                 (uu____2726, uu____2727) in
               FStar_Parser_AST.PatVar uu____2722 in
             mk1 uu____2721)
      | uu____2730 ->
          let pat =
            let uu____2732 =
              let uu____2733 =
                let uu____2737 = bv_as_unique_ident x in
                let uu____2738 = resugar_arg_qual qual in
                (uu____2737, uu____2738) in
              FStar_Parser_AST.PatVar uu____2733 in
            mk1 uu____2732 in
          let uu____2741 =
            let uu____2742 =
              let uu____2745 = resugar_term x.FStar_Syntax_Syntax.sort in
              (pat, uu____2745) in
            FStar_Parser_AST.PatAscribed uu____2742 in
          mk1 uu____2741
and resugar_match_pat: FStar_Syntax_Syntax.pat -> FStar_Parser_AST.pattern =
  fun p  ->
    let mk1 a = FStar_Parser_AST.mk_pattern a p.FStar_Syntax_Syntax.p in
    let rec aux p1 =
      match p1.FStar_Syntax_Syntax.v with
      | FStar_Syntax_Syntax.Pat_constant c ->
          mk1 (FStar_Parser_AST.PatConst c)
      | FStar_Syntax_Syntax.Pat_disj args ->
          let args1 = FStar_List.map (fun p2  -> aux p2) args in
          mk1 (FStar_Parser_AST.PatOr args1)
      | FStar_Syntax_Syntax.Pat_cons (fv,[]) ->
          mk1
            (FStar_Parser_AST.PatName
               ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v))
      | FStar_Syntax_Syntax.Pat_cons (fv,args) when
          FStar_Ident.lid_equals
            (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
            FStar_Syntax_Const.cons_lid
          ->
          let args1 =
            FStar_List.map
              (fun uu____2797  -> match uu____2797 with | (p2,b) -> aux p2)
              args in
          mk1 (FStar_Parser_AST.PatList args1)
      | FStar_Syntax_Syntax.Pat_cons (fv,args) when
          (FStar_Syntax_Util.is_tuple_data_lid'
             (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v)
            ||
            (FStar_Syntax_Util.is_dtuple_data_lid'
               (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v)
          ->
          let args1 =
            FStar_List.map
              (fun uu____2826  -> match uu____2826 with | (p2,b) -> aux p2)
              args in
          if
            FStar_Syntax_Util.is_dtuple_data_lid'
              (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
          then mk1 (FStar_Parser_AST.PatTuple (args1, true))
          else mk1 (FStar_Parser_AST.PatTuple (args1, false))
      | FStar_Syntax_Syntax.Pat_cons
          ({ FStar_Syntax_Syntax.fv_name = uu____2838;
             FStar_Syntax_Syntax.fv_delta = uu____2839;
             FStar_Syntax_Syntax.fv_qual = Some
               (FStar_Syntax_Syntax.Record_ctor (name,fields));_},args)
          ->
          let fields1 =
            let uu____2860 =
              FStar_All.pipe_right fields
                (FStar_List.map (fun f  -> FStar_Ident.lid_of_ids [f])) in
            FStar_All.pipe_right uu____2860 FStar_List.rev in
          let args1 =
            let uu____2869 =
              FStar_All.pipe_right args
                (FStar_List.map
                   (fun uu____2879  ->
                      match uu____2879 with | (p2,b) -> aux p2)) in
            FStar_All.pipe_right uu____2869 FStar_List.rev in
          let rec map21 l1 l2 =
            match (l1, l2) with
            | ([],[]) -> []
            | ([],hd1::tl1) -> []
            | (hd1::tl1,[]) ->
                let uu____2921 = map21 tl1 [] in
                (hd1, (mk1 FStar_Parser_AST.PatWild)) :: uu____2921
            | (hd1::tl1,hd2::tl2) ->
                let uu____2935 = map21 tl1 tl2 in (hd1, hd2) :: uu____2935 in
          let args2 =
            let uu____2945 = map21 fields1 args1 in
            FStar_All.pipe_right uu____2945 FStar_List.rev in
          mk1 (FStar_Parser_AST.PatRecord args2)
      | FStar_Syntax_Syntax.Pat_cons (fv,args) ->
          let args1 =
            FStar_List.map
              (fun uu____2973  -> match uu____2973 with | (p2,b) -> aux p2)
              args in
          mk1
            (FStar_Parser_AST.PatApp
               ((mk1
                   (FStar_Parser_AST.PatName
                      ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v))),
                 args1))
      | FStar_Syntax_Syntax.Pat_var v1 ->
          let uu____2984 =
            string_to_op (v1.FStar_Syntax_Syntax.ppname).FStar_Ident.idText in
          (match uu____2984 with
           | Some op -> mk1 (FStar_Parser_AST.PatOp op)
           | None  ->
               let uu____2987 =
                 let uu____2988 =
                   let uu____2992 = bv_as_unique_ident v1 in
                   (uu____2992, None) in
                 FStar_Parser_AST.PatVar uu____2988 in
               mk1 uu____2987)
      | FStar_Syntax_Syntax.Pat_wild uu____2994 ->
          mk1 FStar_Parser_AST.PatWild
      | FStar_Syntax_Syntax.Pat_dot_term (bv,term) ->
          let pat =
            let uu____3002 =
              let uu____3003 =
                let uu____3007 = bv_as_unique_ident bv in (uu____3007, None) in
              FStar_Parser_AST.PatVar uu____3003 in
            mk1 uu____3002 in
          let uu____3009 =
            let uu____3010 =
              let uu____3013 = resugar_term term in (pat, uu____3013) in
            FStar_Parser_AST.PatAscribed uu____3010 in
          mk1 uu____3009 in
    aux p