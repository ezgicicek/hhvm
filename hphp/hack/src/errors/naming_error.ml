(*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the "hack" directory of this source tree.
 *
 *)
open Hh_prelude
open String_utils
module Error_code = Error_codes.Naming

type t =
  | Unsupported_trait_use_as of Pos.t
  | Unsupported_instead_of of Pos.t
  | Invalid_trait_use_as_visibility of Pos.t
  | Unexpected_arrow of {
      pos: Pos.t;
      cname: string;
    }
  | Missing_arrow of {
      pos: Pos.t;
      cname: string;
    }
  | Disallowed_xhp_type of {
      pos: Pos.t;
      ty_name: string;
    }
  | Name_is_reserved of {
      pos: Pos.t;
      name: string;
    }
  | Dollardollar_unused of Pos.t
  | Method_name_already_bound of {
      pos: Pos.t;
      meth_name: string;
    }
  | Error_name_already_bound of {
      pos: Pos.t;
      name: string;
      prev_pos: Pos.t;
      prev_name: string;
    }
  | Unbound_name of {
      pos: Pos.t;
      name: string;
      kind: Name_context.t;
    }
  | Invalid_fun_pointer of {
      pos: Pos.t;
      name: string;
    }
  | Undefined of {
      pos: Pos.t;
      var_name: string;
      did_you_mean: (string * Pos.t) option;
    }
  | This_reserved of Pos.t
  | Start_with_T of Pos.t
  | Already_bound of {
      pos: Pos.t;
      name: string;
    }
  | Unexpected_typedef of {
      pos: Pos.t;
      decl_pos: Pos.t;
      expected_kind: Name_context.t;
    }
  | Field_name_already_bound of Pos.t
  | Primitive_top_level of Pos.t
  | Primitive_invalid_alias of {
      pos: Pos.t;
      ty_name_used: string;
      ty_name_canon: string;
    }
  | Dynamic_new_in_strict_mode of Pos.t
  | Invalid_type_access_root of {
      pos: Pos.t;
      id: string;
    }
  | Duplicate_user_attribute of {
      pos: Pos.t;
      attr_name: string;
      prev_pos: Pos.t;
    }
  | Unbound_attribute_name of {
      pos: Pos.t;
      attr_name: string;
    }
  | This_no_argument of Pos.t
  | Object_cast of Pos.t
  | This_hint_outside_class of Pos.t
  | This_type_forbidden of Pos.t
  | Nonstatic_property_with_lsb of Pos.t
  | Lowercase_this of {
      pos: Pos.t;
      ty_name: string;
    }
  | Classname_param of Pos.t
  | Tparam_applied_to_type of {
      pos: Pos.t;
      tparam_name: string;
    }
  | Tparam_with_tparam of {
      pos: Pos.t;
      tparam_name: string;
    }
  | Shadowed_tparam of {
      pos: Pos.t;
      tparam_name: string;
      prev_pos: Pos.t;
    }
  | Missing_typehint of Pos.t
  | Expected_variable of Pos.t
  | Clone_too_many_arguments of Pos.t
  | Too_many_arguments of Pos.t
  | Too_few_arguments of Pos.t
  | Expected_collection of {
      pos: Pos.t;
      cname: string;
    }
  | Illegal_CLASS of Pos.t
  | Illegal_TRAIT of Pos.t
  | Illegal_fun of Pos.t
  | Illegal_member_variable_class of Pos.t
  | Illegal_meth_fun of Pos.t
  | Illegal_inst_meth of Pos.t
  | Illegal_meth_caller of Pos.t
  | Illegal_class_meth of Pos.t
  | Lvar_in_obj_get of Pos.t
  | Class_meth_non_final_self of {
      pos: Pos.t;
      class_name: string;
    }
  | Class_meth_non_final_CLASS of {
      pos: Pos.t;
      class_name: string;
      is_trait: bool;
    }
  | Const_without_typehint of {
      pos: Pos.t;
      const_name: string;
      ty_name: string;
    }
  | Prop_without_typehint of {
      pos: Pos.t;
      prop_name: string;
      vis: [ `public | `private_ | `internal | `protected ];
    }
  | Illegal_constant of Pos.t
  | Invalid_require_implements of Pos.t
  | Invalid_require_extends of Pos.t
  | Did_you_mean of {
      pos: Pos.t;
      name: string;
      suggest_pos: Pos.t;
      suggest_name: string;
    }
  | Using_internal_class of {
      pos: Pos.t;
      class_name: string;
    }
  | Too_few_type_arguments of Pos.t
  | Method_needs_visibility of Pos.t
  | Dynamic_class_name_in_strict_mode of Pos.t
  | Xhp_optional_required_attr of {
      pos: Pos.t;
      attr_name: string;
    }
  | Xhp_required_with_default of {
      pos: Pos.t;
      attr_name: string;
    }
  | Array_typehints_disallowed of Pos.t
  | Wildcard_hint_disallowed of Pos.t
  | Wildcard_tparam_disallowed of Pos.t
  | Illegal_use_of_dynamically_callable of {
      attr_pos: Pos.t;
      meth_pos: Pos.t;
      vis: [ `public | `private_ | `internal | `protected ];
    }
  | Parent_in_function_pointer of {
      pos: Pos.t;
      meth_name: string;
      parent_name: string option;
    }
  | Self_in_non_final_function_pointer of {
      pos: Pos.t;
      meth_name: string;
      class_name: string option;
    }
  | Invalid_wildcard_context of Pos.t
  | Return_only_typehint of {
      pos: Pos.t;
      kind: [ `noreturn | `void ];
    }
  | Unexpected_type_arguments of Pos.t
  | Too_many_type_arguments of Pos.t
  | This_as_lexical_variable of Pos.t
  | HKT_unsupported_feature of {
      pos: Pos.t;
      because_nested: bool;
      var_name: string;
      feature:
        [ `where_constraints
        | `constraints
        | `reification
        | `user_attrs
        | `variance
        ];
    }
  | HKT_partial_application of {
      pos: Pos.t;
      count: int;
    }
  | HKT_wildcard of Pos.t
  | HKT_implicit_argument of {
      pos: Pos.t;
      decl_pos: Pos_or_decl.t;
      param_name: string;
    }
  | HKT_class_with_constraints_used of {
      pos: Pos.t;
      class_name: string;
    }
  | HKT_alias_with_implicit_constraints of {
      pos: Pos.t;
      typedef_pos: Pos_or_decl.t;
      used_class_in_def_pos: Pos_or_decl.t;
      typedef_name: string;
      typedef_tparam_name: string;
      used_class_in_def_name: string;
      used_class_tparam_name: string;
    }

let const_without_typehint pos name type_ =
  let name = Utils.strip_all_ns name in
  let msg = Printf.sprintf "Please add a type hint `const SomeType %s`" name in
  let (title, new_text) =
    match type_ with
    | "string" -> ("Add string type annotation", "string " ^ name)
    | "int" -> ("Add integer type annotation", "int " ^ name)
    | "float" -> ("Add float type annotation", "float " ^ name)
    | _ -> ("Add mixed type annotation", "mixed " ^ name)
  in
  User_error.make
    Error_code.(to_enum AddATypehint)
    ~quickfixes:[Quickfix.make ~title ~new_text pos]
    (pos, msg)
    []

let prop_without_typehint pos name vis =
  let visibility = Render.vis_to_string vis in
  let msg =
    Printf.sprintf "Please add a type hint `%s SomeType %s`" visibility name
  in
  User_error.make Error_code.(to_enum AddATypehint) (pos, msg) []

let illegal_constant pos =
  User_error.make
    Error_code.(to_enum IllegalConstant)
    (pos, "Illegal constant value")
    []

let invalid_req_implements pos =
  User_error.make
    Error_code.(to_enum InvalidReqImplements)
    (pos, "Only traits may use `require implements`")
    []

let invalid_req_extends pos =
  User_error.make
    Error_code.(to_enum InvalidReqExtends)
    (pos, "Only traits and interfaces may use `require extends`")
    []

let did_you_mean_naming pos name suggest_pos suggest_name =
  let name = Render.strip_ns name in
  let suggest_name = Render.strip_ns suggest_name in
  let quickfixes =
    [
      Quickfix.make
        ~title:("Change to " ^ suggest_name)
        ~new_text:suggest_name
        pos;
    ]
  in
  User_error.make
    Error_code.(to_enum DidYouMeanNaming)
    ~quickfixes
    (pos, "Could not find " ^ Markdown_lite.md_codify name ^ ".")
    [
      Render.suggestion_message
        name
        suggest_name
        (Pos_or_decl.of_raw_pos suggest_pos);
    ]

let using_internal_class pos name =
  User_error.make
    Error_code.(to_enum UsingInternalClass)
    ( pos,
      Markdown_lite.md_codify name
      ^ " is an implementation internal class that cannot be used directly" )
    []

let too_few_type_arguments p =
  User_error.make
    Error_code.(to_enum TooFewTypeArguments)
    (p, "Too few type arguments for this type")
    []

let method_needs_visibility pos =
  User_error.make
    Error_code.(to_enum MethodNeedsVisibility)
    (pos, "Methods need to be marked `public`, `private`, or `protected`.")
    []

let dynamic_class_name_in_strict_mode pos =
  User_error.make
    Error_code.(to_enum DynamicClassNameInStrictMode)
    (pos, "Cannot use dynamic class name in strict mode")
    []

let xhp_optional_required_attr pos id =
  User_error.make
    Error_code.(to_enum XhpOptionalRequiredAttr)
    ( pos,
      "XHP attribute "
      ^ Markdown_lite.md_codify id
      ^ " cannot be marked as nullable and `@required`" )
    []

let xhp_required_with_default pos id =
  User_error.make
    Error_code.(to_enum XhpRequiredWithDefault)
    ( pos,
      "XHP attribute "
      ^ Markdown_lite.md_codify id
      ^ " cannot be marked `@required` and provide a default" )
    []

let array_typehints_disallowed pos =
  User_error.make
    Error_code.(to_enum ArrayTypehintsDisallowed)
    ( pos,
      "Array typehints are no longer legal; use `varray` or `darray` instead" )
    []

let wildcard_hint_disallowed pos =
  User_error.make
    Error_code.(to_enum WildcardHintDisallowed)
    (pos, "Wildcard typehints are not allowed in this position")
    []

let wildcard_param_disallowed pos =
  User_error.make
    Error_code.(to_enum WildcardTypeParamDisallowed)
    (pos, "Cannot use anonymous type parameter in this position.")
    []

let illegal_use_of_dynamically_callable attr_pos meth_pos vis =
  let visibility = Render.vis_to_string vis in
  User_error.make
    Error_code.(to_enum IllegalUseOfDynamicallyCallable)
    (attr_pos, "`__DynamicallyCallable` can only be used on public methods")
    [
      ( Pos_or_decl.of_raw_pos meth_pos,
        sprintf "But this method is %s" (Markdown_lite.md_codify visibility) );
    ]

let unsupported_trait_use_as pos =
  User_error.make
    Error_code.(to_enum UnsupportedTraitUseAs)
    ( pos,
      "Aliasing with `as` within a trait `use` is a PHP feature that is unsupported in Hack"
    )
    []

let unsupported_instead_of pos =
  User_error.make
    Error_code.(to_enum UnsupportedInsteadOf)
    (pos, "`insteadof` is a PHP feature that is unsupported in Hack")
    []

let invalid_trait_use_as_visibility pos =
  User_error.make
    Error_code.(to_enum InvalidTraitUseAsVisibility)
    (pos, "Cannot redeclare trait method's visibility in this manner")
    []

let unexpected_arrow pos cname =
  User_error.make
    Error_code.(to_enum UnexpectedArrow)
    ( pos,
      Format.sprintf {|Keys may not be specified for %s initialization|} cname
    )
    []

let parent_in_function_pointer pos meth_name parent_name =
  let msg =
    match parent_name with
    | None ->
      "Cannot use `parent::` in a function pointer due to class context ambiguity. Consider using the name of the parent class explicitly."
    | Some id ->
      let name =
        Markdown_lite.md_codify (Render.strip_ns id ^ "::" ^ meth_name)
      in
      Format.sprintf
        "Cannot use `parent::` in a function pointer due to class context ambiguity. Consider using %s instead"
        name
  in
  User_error.make Error_code.(to_enum ParentInFunctionPointer) (pos, msg) []

let missing_arrow pos cname =
  User_error.make
    Error_code.(to_enum MissingArrow)
    ( pos,
      Format.sprintf {|Keys must be specified for %s initialization|}
      @@ Markdown_lite.md_codify cname )
    []

let disallowed_xhp_type pos ty_name =
  User_error.make
    Error_code.(to_enum DisallowedXhpType)
    ( pos,
      Format.sprintf {|%s is not a valid type. Use `:xhp` or `XHPChild`.|}
      @@ Markdown_lite.md_codify ty_name )
    []

let name_is_reserved pos name =
  User_error.make
    Error_code.(to_enum NameIsReserved)
    ( pos,
      Format.sprintf {|%s cannot be used as it is reserved.|}
      @@ Markdown_lite.md_codify
      @@ Utils.strip_all_ns name )
    []

let dollardollar_unused pos =
  User_error.make
    Error_code.(to_enum DollardollarUnused)
    ( pos,
      "This expression does not contain a "
      ^ "usage of the special pipe variable. Did you forget to use the `$$` "
      ^ "variable?" )
    []

let already_bound pos name =
  User_error.make
    Error_code.(to_enum NameAlreadyBound)
    ( pos,
      Format.sprintf "Argument already bound: %s"
      @@ Markdown_lite.md_codify name )
    []

let method_name_already_bound pos meth_name =
  User_error.make
    Error_code.(to_enum MethodNameAlreadyBound)
    ( pos,
      Format.sprintf "Method name already bound: %s"
      @@ Markdown_lite.md_codify meth_name )
    []

let error_name_already_bound pos name prev_name prev_pos =
  let (name, prev_name) = Render.(strip_ns name, strip_ns prev_name) in

  let hhi_msg =
    "This appears to be defined in an hhi file included in your project "
    ^ "root. The hhi files for the standard library are now a part of the "
    ^ "typechecker and must be removed from your project. Typically, you can "
    ^ "do this by deleting the \"hhi\" directory you copied into your "
    ^ "project when first starting with Hack."
  in
  let suffix =
    if Relative_path.(is_hhi (prefix (Pos.filename pos))) then
      [(Pos_or_decl.of_raw_pos prev_pos, hhi_msg)]
    else if Pos.is_hhi prev_pos then
      [(Pos_or_decl.of_raw_pos pos, hhi_msg)]
    else
      []
  in
  let reasons =
    [
      ( Pos_or_decl.of_raw_pos prev_pos,
        if String.equal name prev_name then
          "Previous definition is here"
        else
          "Previous definition "
          ^ (Render.highlight_differences name prev_name
            |> Markdown_lite.md_codify)
          ^ " differs only by case " );
    ]
    @ suffix
  in

  User_error.make
    Error_code.(to_enum ErrorNameAlreadyBound)
    ( pos,
      Format.sprintf "Name already bound: %s"
      @@ Markdown_lite.md_codify
      @@ Render.strip_ns name )
    reasons

let invalid_fun_pointer pos name =
  User_error.make
    Error_code.(to_enum InvalidFunPointer)
    ( pos,
      Format.sprintf "Unbound global function: %s is not a valid name for fun()"
      @@ Markdown_lite.md_codify
      @@ Render.strip_ns name )
    []

let undefined pos var_name did_you_mean =
  let (reasons, quickfixes) =
    Option.value_map
      ~default:([], [])
      did_you_mean
      ~f:(fun (did_you_mean, did_you_mean_pos) ->
        ( [
            Render.(
              suggestion_message var_name did_you_mean did_you_mean_pos
              |> Tuple2.map_fst ~f:Pos_or_decl.of_raw_pos);
          ],
          [
            Quickfix.make
              ~title:("Change to " ^ did_you_mean)
              ~new_text:did_you_mean
              pos;
          ] ))
  in
  User_error.make
    Error_code.(to_enum Undefined)
    ( pos,
      Format.sprintf "Variable %s is undefined, or not always defined."
      @@ Markdown_lite.md_codify var_name )
    reasons
    ~quickfixes

let this_reserved pos =
  User_error.make
    Error_code.(to_enum ThisReserved)
    (pos, "The type parameter `this` is reserved")
    []

let start_with_T pos =
  User_error.make
    Error_code.(to_enum StartWith_T)
    (pos, "Please make your type parameter start with the letter `T` (capital)")
    []

let unexpected_typedef pos expected_kind decl_pos =
  User_error.make
    Error_code.(to_enum UnexpectedTypedef)
    ( pos,
      Printf.sprintf "Expected a %s but got a type alias."
      @@ Markdown_lite.md_codify
      @@ Name_context.to_string expected_kind )
    [(Pos_or_decl.of_raw_pos decl_pos, "Alias definition is here.")]

let field_name_already_bound pos =
  User_error.make
    Error_code.(to_enum FdNameAlreadyBound)
    (pos, "Field name already bound")
    []

let primitive_top_level pos =
  User_error.make
    Error_code.(to_enum PrimitiveToplevel)
    ( pos,
      "Primitive type annotations are always available and may no longer be referred to in the toplevel namespace."
    )
    []

let primitive_invalid_alias pos ty_name_used ty_name_canon =
  User_error.make
    Error_code.(to_enum PrimitiveInvalidAlias)
    ( pos,
      Format.sprintf
        "Invalid Hack type. Using %s in Hack is considered an error. Use %s instead, to keep the codebase consistent."
        (Markdown_lite.md_codify ty_name_used)
        (Markdown_lite.md_codify ty_name_canon) )
    []

let dynamic_new_in_strict_mode pos =
  User_error.make
    Error_code.(to_enum DynamicNewInStrictMode)
    (pos, "Cannot use dynamic `new`.")
    []

let invalid_type_access_root pos id =
  User_error.make
    Error_code.(to_enum InvalidTypeAccessRoot)
    ( pos,
      Format.sprintf "%s must be an identifier for a class, `self`, or `this`"
      @@ Markdown_lite.md_codify id )
    []

let duplicate_user_attribute attr_name prev_pos pos =
  User_error.make
    Error_code.(to_enum DuplicateUserAttribute)
    ( pos,
      Format.sprintf "You cannot reuse the attribute %s"
      @@ Markdown_lite.md_codify attr_name )
    [
      ( Pos_or_decl.of_raw_pos prev_pos,
        Markdown_lite.md_codify attr_name ^ " was already used here" );
    ]

let unbound_name pos name kind =
  let kind_str =
    match kind with
    | Name_context.ConstantNamespace -> " (a global constant)"
    | Name_context.FunctionNamespace -> " (a global function)"
    | Name_context.TypeNamespace -> ""
    | Name_context.ClassContext -> " (an object type)"
    | Name_context.TraitContext -> " (a trait)"
    | Name_context.RecordContext -> " (a record type)"
  in
  User_error.make
    Error_code.(to_enum UnboundName)
    ( pos,
      "Unbound name: "
      ^ Markdown_lite.md_codify (Render.strip_ns name)
      ^ kind_str )
    []

let unbound_attribute_name pos attr_name =
  let reason =
    if string_starts_with attr_name "__" then
      "starts with __ but is not a standard attribute"
    else
      "does not have a class. Please declare a class for the attribute."
  in

  User_error.make
    Error_code.(to_enum UnboundName)
    ( pos,
      Format.sprintf
        "Unrecognized user attribute: %s %s"
        (Render.strip_ns attr_name |> Markdown_lite.md_codify)
        reason )
    []

let this_no_argument pos =
  User_error.make
    Error_code.(to_enum ThisNoArgument)
    (pos, "`this` expects no arguments")
    []

let object_cast pos =
  User_error.make
    Error_code.(to_enum ObjectCast)
    (pos, "Casts are only supported for `bool`, `int`, `float` and `string`.")
    []

let this_hint_outside_class pos =
  User_error.make
    Error_code.(to_enum ThisHintOutsideClass)
    (pos, "Cannot use `this` outside of a class")
    []

let this_type_forbidden pos =
  User_error.make
    Error_code.(to_enum ThisMustBeReturn)
    ( pos,
      "The type `this` cannot be used as a constraint on a class generic, or as the type of a static member variable"
    )
    []

let nonstatic_property_with_lsb pos =
  User_error.make
    Error_code.(to_enum NonstaticPropertyWithLSB)
    (pos, "`__LSB` attribute may only be used on static properties")
    []

let lowercase_this pos ty_name =
  User_error.make
    Error_code.(to_enum LowercaseThis)
    ( pos,
      Format.sprintf "Invalid Hack type %s. Use `this` instead."
      @@ Markdown_lite.md_codify ty_name )
    []

let classname_param pos =
  User_error.make
    Error_code.(to_enum ClassnameParam)
    ( pos,
      "Missing type parameter to `classname`; `classname` is entirely"
      ^ " meaningless without one" )
    []

let tparam_applied_to_type pos tparam_name =
  User_error.make
    Error_code.(to_enum HigherKindedTypesUnsupportedFeature)
    ( pos,
      Printf.sprintf
        "`%s` is a type parameter. Type parameters cannot take type arguments (e.g. `%s<int>` isn't allowed)"
        tparam_name
        tparam_name )
    []

let tparam_with_tparam pos tparam_name =
  User_error.make
    Error_code.(to_enum HigherKindedTypesUnsupportedFeature)
    ( pos,
      if String.equal tparam_name "_" then
        "Type parameters cannot themselves have type parameters"
      else
        Format.sprintf
          "%s is a type parameter. Type parameters cannot themselves have type parameters"
        @@ Markdown_lite.md_codify tparam_name )
    []

let shadowed_tparam prev_pos tparam_name pos =
  User_error.make
    Error_code.(to_enum ShadowedTypeParam)
    ( pos,
      Printf.sprintf
        "You cannot re-bind the type parameter %s"
        (Markdown_lite.md_codify tparam_name) )
    [
      ( Pos_or_decl.of_raw_pos prev_pos,
        Printf.sprintf
          "%s is already bound here"
          (Markdown_lite.md_codify tparam_name) );
    ]

let missing_typehint pos =
  User_error.make
    Error_code.(to_enum MissingTypehint)
    (pos, "Please add a type hint")
    []

let expected_variable pos =
  User_error.make
    Error_code.(to_enum ExpectedVariable)
    (pos, "Was expecting a variable name")
    []

let clone_too_many_arguments pos =
  User_error.make
    Error_code.(to_enum NamingTooManyArguments)
    (pos, "`__clone` method cannot take arguments")
    []

let too_many_arguments pos =
  User_error.make
    Error_code.(to_enum NamingTooManyArguments)
    (pos, "Too many arguments")
    []

let too_few_arguments pos =
  User_error.make
    Error_code.(to_enum NamingTooFewArguments)
    (pos, "Too few arguments")
    []

let expected_collection pos cname =
  User_error.make
    Error_code.(to_enum ExpectedCollection)
    ( pos,
      Format.sprintf
        "Unexpected collection type %s"
        (Render.strip_ns cname |> Markdown_lite.md_codify) )
    []

let illegal_CLASS pos =
  User_error.make
    Error_code.(to_enum IllegalClass)
    (pos, "Using `__CLASS__` outside a class or trait")
    []

let illegal_TRAIT pos =
  User_error.make
    Error_code.(to_enum IllegalTrait)
    (pos, "Using `__TRAIT__` outside a trait")
    []

let illegal_fun pos =
  User_error.make
    Error_code.(to_enum IllegalFun)
    ( pos,
      "The argument to `fun()` must be a single-quoted, constant "
      ^ "literal string representing a valid function name." )
    []

let illegal_member_variable_class pos =
  User_error.make
    Error_code.(to_enum IllegalMemberVariableClass)
    ( pos,
      "Cannot declare a constant named `class`. The name `class` is reserved for the class constant that represents the name of the class"
    )
    []

let illegal_meth_fun pos =
  User_error.make
    Error_code.(to_enum IllegalMethFun)
    ( pos,
      "String argument to `fun()` contains `:`;"
      ^ " for static class methods, use"
      ^ " `class_meth(Cls::class, 'method_name')`, not `fun('Cls::method_name')`"
    )
    []

let illegal_inst_meth pos =
  User_error.make
    Error_code.(to_enum IllegalInstMeth)
    ( pos,
      "The argument to `inst_meth()` must be an expression and a "
      ^ "constant literal string representing a valid method name." )
    []

let illegal_meth_caller pos =
  User_error.make
    Error_code.(to_enum IllegalMethCaller)
    ( pos,
      "The two arguments to `meth_caller()` must be:"
      ^ "\n - first: `ClassOrInterface::class`"
      ^ "\n - second: a single-quoted string literal containing the name"
      ^ " of a non-static method of that class" )
    []

let illegal_class_meth pos =
  User_error.make
    Error_code.(to_enum IllegalClassMeth)
    ( pos,
      "The two arguments to `class_meth()` must be:"
      ^ "\n - first: `ValidClassname::class`"
      ^ "\n - second: a single-quoted string literal containing the name"
      ^ " of a static method of that class" )
    []

let illegal_constant pos = illegal_constant pos

let lvar_in_obj_get pos =
  User_error.make
    Error_code.(to_enum LvarInObjGet)
    ( pos,
      "Dynamic method or attribute access is not allowed on a non-dynamic value."
    )
    []

let class_meth_non_final_self pos class_name =
  User_error.make
    Error_code.(to_enum ClassMethNonFinalSelf)
    ( pos,
      Format.sprintf
        "`class_meth` with `self::class` does not preserve class calling context.\nUse `static::class`, or `%s::class` explicitly"
      @@ Render.strip_ns class_name )
    []

let class_meth_non_final_CLASS pos class_name is_trait =
  User_error.make
    Error_code.(to_enum ClassMethNonFinalCLASS)
    ( pos,
      if is_trait then
        "`class_meth` with `__CLASS__` in non-final classes is not allowed.\n"
      else
        Format.sprintf
          "`class_meth` with `__CLASS__` in non-final classes is not allowed.\nUse `%s::class` explicitly"
        @@ Render.strip_ns class_name )
    []

let self_in_non_final_function_pointer pos class_name meth_name =
  let suggestion =
    match class_name with
    | None -> ""
    | Some id ->
      let name =
        Markdown_lite.md_codify (Render.strip_ns id ^ "::" ^ meth_name)
      in
      "Consider using " ^ name ^ " instead"
  in
  User_error.make
    Error_code.(to_enum SelfInNonFinalFunctionPointer)
    ( pos,
      "Cannot use `self::` in a function pointer in a non-final class due to class context ambiguity. "
      ^ suggestion )
    []

let invalid_wildcard_context pos =
  User_error.make
    Error_code.(to_enum InvalidWildcardContext)
    ( pos,
      "A wildcard can only be used as a context when it is the sole context of a callable parameter in a higher-order function. The parameter must also be referenced with `ctx` in the higher-order function's context list, e.g. `function hof((function ()[_]: void) $f)[ctx $f]: void {}`"
    )
    []

let return_only_typehint pos kind =
  let kstr =
    Markdown_lite.md_codify
    @@
    match kind with
    | `void -> "void"
    | `noreturn -> "noreturn"
  in
  User_error.make
    Error_code.(to_enum ReturnOnlyTypehint)
    ( pos,
      Format.sprintf
        "The %s typehint can only be used to describe a function return type"
        kstr )
    []

let unexpected_type_arguments pos =
  User_error.make
    Error_code.(to_enum UnexpectedTypeArguments)
    (pos, "Type arguments are not expected for this type")
    []

let too_many_type_arguments pos =
  User_error.make
    Error_code.(to_enum TooManyTypeArguments)
    (pos, "Too many type arguments for this type")
    []

let this_as_lexical_variable pos =
  User_error.make
    Error_code.(to_enum ThisAsLexicalVariable)
    (pos, "Cannot use `$this` as lexical variable")
    []

let hkt_unsupported_feature pos because_nested var_name feature =
  let var_name = Markdown_lite.md_codify var_name in
  let var_desc =
    Format.sprintf
      (if because_nested then
        {|%s is a generic parameter of another (higher-kinded) generic parameter.|}
      else
        {|%s is a higher-kinded type parameter, standing for a type that has type parameters itself.|})
      var_name
  in
  let feature_desc =
    match feature with
    | `where_constraints -> "where constraints mentioning"
    | `constraints -> "constraints on"
    | `reification -> "reification of"
    | `user_attrs -> "user attributes on"
    | `variance -> "variance other than invariant for"
  in
  User_error.make
    Error_code.(to_enum HigherKindedTypesUnsupportedFeature)
    ( pos,
      Format.sprintf
        {|%s We don't support %s parameters like %s.|}
        var_desc
        feature_desc
        var_name )
    []

let hkt_partial_application pos count =
  User_error.make
    Error_code.(to_enum HigherKindedTypesUnsupportedFeature)
    ( pos,
      Format.sprintf
        {|A higher-kinded type is expected here. We do not not support partial applications to yield higher-kinded types, but you are providing %n type argument(s).|}
        count )
    []

let hkt_wildcard pos =
  User_error.make
    Error_code.(to_enum HigherKindedTypesUnsupportedFeature)
    ( pos,
      "You are supplying _ where a higher-kinded type is expected."
      ^ " We cannot infer higher-kinded type arguments at this time, please state the actual type."
    )
    []

let hkt_implicit_argument decl_pos param_name pos =
  let param_desc =
    (* This should be Naming_special_names.Typehints.wildcard, but its not available in this
       module *)
    if String.equal param_name "_" then
      "the anonymous generic parameter"
    else
      "the generic parameter " ^ param_name
  in
  User_error.make
    Error_code.(to_enum HigherKindedTypesUnsupportedFeature)
    ( pos,
      "You left out the type arguments here such that they may be inferred."
      ^ " However, a higher-kinded type is expected in place of "
      ^ param_desc
      ^ ", meaning that the type arguments cannot be inferred."
      ^ " Please provide the type arguments explicitly." )
    [
      ( decl_pos,
        Format.sprintf {|%s was declared to be higher-kinded here.|} param_desc
      );
    ]

let hkt_class_with_constraints_used pos class_name =
  User_error.make
    Error_code.(to_enum HigherKindedTypesUnsupportedFeature)
    ( pos,
      Format.sprintf
        "The class %s imposes constraints on some of its type parameters. Classes that do this cannot be used as higher-kinded types at this time."
      @@ Render.strip_ns class_name )
    []

let hkt_alias_with_implicit_constraints
    typedef_pos
    typedef_name
    used_class_in_def_pos
    used_class_in_def_name
    used_class_tparam_name
    typedef_tparam_name
    pos =
  let typedef_name = Render.strip_ns typedef_name
  and used_class_in_def_name = Render.strip_ns used_class_in_def_name
  and used_class_tparam_name = Render.strip_ns used_class_tparam_name in
  User_error.make
    Error_code.(to_enum HigherKindedTypesUnsupportedFeature)
    ( pos,
      Format.sprintf
        "The type %s implicitly imposes constraints on its type parameters. Therefore, it cannot be used as a higher-kinded type at this time."
        typedef_name )
    [
      (typedef_pos, "The definition of " ^ typedef_name ^ " is here.");
      ( used_class_in_def_pos,
        "The definition of "
        ^ typedef_name
        ^ " relies on "
        ^ used_class_in_def_name
        ^ " and the constraints that "
        ^ used_class_in_def_name
        ^ " imposes on its type parameter "
        ^ used_class_tparam_name
        ^ " then become implicit constraints on the type parameter "
        ^ typedef_tparam_name
        ^ " of "
        ^ typedef_name
        ^ "." );
    ]

let to_user_error = function
  | Unsupported_trait_use_as pos -> unsupported_trait_use_as pos
  | Unsupported_instead_of pos -> unsupported_instead_of pos
  | Invalid_trait_use_as_visibility pos -> invalid_trait_use_as_visibility pos
  | Unexpected_arrow { pos; cname } -> unexpected_arrow pos cname
  | Missing_arrow { pos; cname } -> missing_arrow pos cname
  | Disallowed_xhp_type { pos; ty_name } -> disallowed_xhp_type pos ty_name
  | Name_is_reserved { pos; name } -> name_is_reserved pos name
  | Dollardollar_unused pos -> dollardollar_unused pos
  | Already_bound { pos; name } -> already_bound pos name
  | Method_name_already_bound { pos; meth_name } ->
    method_name_already_bound pos meth_name
  | Error_name_already_bound { pos; name; prev_name; prev_pos } ->
    error_name_already_bound pos name prev_name prev_pos
  | Invalid_fun_pointer { pos; name } -> invalid_fun_pointer pos name
  | Undefined { pos; var_name; did_you_mean } ->
    undefined pos var_name did_you_mean
  | This_reserved pos -> this_reserved pos
  | Start_with_T pos -> start_with_T pos
  | Unexpected_typedef { pos; expected_kind; decl_pos } ->
    unexpected_typedef pos expected_kind decl_pos
  | Field_name_already_bound pos -> field_name_already_bound pos
  | Primitive_top_level pos -> primitive_top_level pos
  | Primitive_invalid_alias { pos; ty_name_used; ty_name_canon } ->
    primitive_invalid_alias pos ty_name_used ty_name_canon
  | Dynamic_new_in_strict_mode pos -> dynamic_new_in_strict_mode pos
  | Invalid_type_access_root { pos; id } -> invalid_type_access_root pos id
  | Duplicate_user_attribute { attr_name; prev_pos; pos } ->
    duplicate_user_attribute attr_name prev_pos pos
  | Unbound_name { pos; name; kind } -> unbound_name pos name kind
  | Unbound_attribute_name { pos; attr_name } ->
    unbound_attribute_name pos attr_name
  | This_no_argument pos -> this_no_argument pos
  | Object_cast pos -> object_cast pos
  | This_hint_outside_class pos -> this_hint_outside_class pos
  | This_type_forbidden pos -> this_type_forbidden pos
  | Nonstatic_property_with_lsb pos -> nonstatic_property_with_lsb pos
  | Lowercase_this { pos; ty_name } -> lowercase_this pos ty_name
  | Classname_param pos -> classname_param pos
  | Tparam_applied_to_type { pos; tparam_name } ->
    tparam_applied_to_type pos tparam_name
  | Tparam_with_tparam { pos; tparam_name } ->
    tparam_with_tparam pos tparam_name
  | Shadowed_tparam { prev_pos; tparam_name; pos } ->
    shadowed_tparam prev_pos tparam_name pos
  | Missing_typehint pos -> missing_typehint pos
  | Expected_variable pos -> expected_variable pos
  | Clone_too_many_arguments pos -> clone_too_many_arguments pos
  | Too_many_arguments pos -> too_many_arguments pos
  | Too_few_arguments pos -> too_few_arguments pos
  | Expected_collection { pos; cname } -> expected_collection pos cname
  | Illegal_CLASS pos -> illegal_CLASS pos
  | Illegal_TRAIT pos -> illegal_TRAIT pos
  | Illegal_fun pos -> illegal_fun pos
  | Illegal_member_variable_class pos -> illegal_member_variable_class pos
  | Illegal_meth_fun pos -> illegal_meth_fun pos
  | Illegal_inst_meth pos -> illegal_inst_meth pos
  | Illegal_meth_caller pos -> illegal_meth_caller pos
  | Illegal_class_meth pos -> illegal_class_meth pos
  | Illegal_constant pos -> illegal_constant pos
  | Lvar_in_obj_get pos -> lvar_in_obj_get pos
  | Class_meth_non_final_self { pos; class_name } ->
    class_meth_non_final_self pos class_name
  | Class_meth_non_final_CLASS { pos; class_name; is_trait } ->
    class_meth_non_final_CLASS pos class_name is_trait
  | Const_without_typehint { pos; const_name; ty_name } ->
    const_without_typehint pos const_name ty_name
  | Prop_without_typehint { pos; prop_name; vis } ->
    prop_without_typehint pos prop_name vis
  | Invalid_require_implements pos -> invalid_req_implements pos
  | Invalid_require_extends pos -> invalid_req_extends pos
  | Invalid_wildcard_context pos -> invalid_wildcard_context pos
  | Did_you_mean { name; suggest_pos; suggest_name; pos } ->
    did_you_mean_naming pos name suggest_pos suggest_name
  | Using_internal_class { pos; class_name } ->
    using_internal_class pos class_name
  | Too_few_type_arguments pos -> too_few_type_arguments pos
  | Method_needs_visibility pos -> method_needs_visibility pos
  | Dynamic_class_name_in_strict_mode pos ->
    dynamic_class_name_in_strict_mode pos
  | Xhp_optional_required_attr { pos; attr_name } ->
    xhp_optional_required_attr pos attr_name
  | Xhp_required_with_default { pos; attr_name } ->
    xhp_required_with_default pos attr_name
  | Array_typehints_disallowed pos -> array_typehints_disallowed pos
  | Wildcard_hint_disallowed pos -> wildcard_hint_disallowed pos
  | Wildcard_tparam_disallowed pos -> wildcard_param_disallowed pos
  | Illegal_use_of_dynamically_callable { meth_pos; vis; attr_pos } ->
    illegal_use_of_dynamically_callable attr_pos meth_pos vis
  | Parent_in_function_pointer { pos; meth_name; parent_name } ->
    parent_in_function_pointer pos meth_name parent_name
  | Self_in_non_final_function_pointer { pos; class_name; meth_name } ->
    self_in_non_final_function_pointer pos class_name meth_name
  | Return_only_typehint { pos; kind } -> return_only_typehint pos kind
  | Unexpected_type_arguments pos -> unexpected_type_arguments pos
  | Too_many_type_arguments pos -> too_many_type_arguments pos
  | This_as_lexical_variable pos -> this_as_lexical_variable pos
  | HKT_unsupported_feature { pos; because_nested; var_name; feature } ->
    hkt_unsupported_feature pos because_nested var_name feature
  | HKT_partial_application { pos; count } -> hkt_partial_application pos count
  | HKT_wildcard pos -> hkt_wildcard pos
  | HKT_implicit_argument { decl_pos; param_name; pos } ->
    hkt_implicit_argument decl_pos param_name pos
  | HKT_class_with_constraints_used { pos; class_name } ->
    hkt_class_with_constraints_used pos class_name
  | HKT_alias_with_implicit_constraints
      {
        typedef_pos;
        typedef_name;
        used_class_in_def_pos;
        used_class_in_def_name;
        used_class_tparam_name;
        typedef_tparam_name;
        pos;
      } ->
    hkt_alias_with_implicit_constraints
      typedef_pos
      typedef_name
      used_class_in_def_pos
      used_class_in_def_name
      used_class_tparam_name
      typedef_tparam_name
      pos