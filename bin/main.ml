
let setup_terminal () = 
  let stdin_settings = Unix.tcgetattr Unix.stdin in
  let updated_stdin_settings = { stdin_settings with
    Unix.c_icanon = false ; 
    Unix.c_echo = false ;
  } in
  Unix.tcsetattr Unix.stdin Unix.TCSANOW updated_stdin_settings;

  let stdout_settings = Unix.tcgetattr Unix.stdout in
  let updated_stdout_settings = { stdout_settings with 
    Unix.c_icanon = false ; 
  } in
  Unix.tcsetattr Unix.stdout Unix.TCSADRAIN updated_stdout_settings

let () = 
  setup_terminal ();

  let b = Bytes.of_string "> " in
  ignore (Unix.write Unix.stdout b 0 (Bytes.length b));
  Unix.fsync Unix.stdout;
  
  let rec command_line_loop = (fun () ->
    let c = input_char stdin in
    let b = match c with
    | '\n' -> Bytes.of_string "\n> "
    | c -> Bytes.of_string (Printf.sprintf "%c" c)
    in
    ignore (Unix.write Unix.stdout b 0 (Bytes.length b));
    Unix.fsync Unix.stdout;
    command_line_loop ()    
  ) in command_line_loop ()
