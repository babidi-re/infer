open! IStd
open GhidraATD
let x: Functions_t.address = {string_representation="a b";}

let () = Functions_j.string_of_address x |> print_string