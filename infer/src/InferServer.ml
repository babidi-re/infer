open! IStd
open Async

module GhidraNP: JsonAnalyze.NameParsers = struct 
    let lang = Language.Clang

    let parse_procname _ = raise (Failure "proc name not implemented")
    let fieldname_of_string _ = raise (Failure "fieldname parse not implemented")

    let typename_of_classname _ = raise (Failure "classname parse not implemented")
end

module GhidraAnalyze = JsonAnalyze.NameParsersToAnalyzer(GhidraNP)

let port_param = let open Command.Param in anon ("port" %: int)


let read_single_message = let parse_message = GhidraATD.Functions_j.json_analyze_req_of_string in (fun rdr -> GhidraATD.Framing.t_from_reader rdr parse_message)

let read_and_print_everyting _addr (r:Reader.t) _w = let message_pipe = Reader.read_all r read_single_message in Pipe.iter message_pipe ~f:(fun (msg:GhidraATD.Functions_t.json_analyze_req) -> GhidraAnalyze.analyze_json msg.cfg msg.tenv |> return)

let run port =
  let%bind server =
    Tcp.Server.create
      ~on_handler_error:`Raise
      (Tcp.Where_to_listen.of_port port)
      read_and_print_everyting
  in
  Tcp.Server.close_finished server
let final_param_set = Command.Param.map port_param ~f:(fun port -> fun () -> run port)

let command = Command.async ~summary:"Starts an infer server" ~readme: (fun _ -> "This starts an infer on the given port that will respond to commands which add functions to the server.") final_param_set

let () = Command.run command