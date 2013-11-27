let get_workspace prompt =
  let open Dmlenu in
  let app_state = {
    prompt ;
    compl = Completion.make_state [ Extra_sources.i3_workspaces () ] ;
  }
  in
  run app_state default_conf

let () =
  try
    match Sys.argv.(1) with
    | "rename" ->
      let ws = get_workspace "rename to:" in
      Unix.execvp "i3-msg" [| "i3-msg"; "-q"; "rename"; "workspace"; "to"; ws |]
    | _ ->
      let ws = get_workspace "Go to:" in
      Unix.execvp "i3-msg" [| "i3-msg" ; "-q" ; "workspace" ; ws |]
  with e ->
    exit 1