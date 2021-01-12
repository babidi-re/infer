(*
 * Copyright (c) 2009-2013, Monoidics ltd.
 * Copyright (c) 2013-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

open! IStd



module type NameParsers = sig
    val parse_procname: Yojson.Safe.t -> Procname.t
    val fieldname_of_string: string -> Fieldname.t
  
    val lang: Language.t
end
  
module NameParsersToAnalyzer(NP: NameParsers): sig 
    val analyze_json: string -> string -> unit
end
