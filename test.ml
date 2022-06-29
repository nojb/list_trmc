open! Core
open Core_bench

let[@tail_mod_cons] rec init_tailrec_aux i n f =
  if i >= n then []
  else f i :: init_tailrec_aux (i+1) n f

let init len f =
  if len < 0 then invalid_arg "List.init" else
  init_tailrec_aux 0 len f

let g = ref []

let test n =
  Command_unix.run
    (Bench.make_command
      [
        Bench.Test.create ~name:(Printf.sprintf "  trmc %d" n) (fun () -> g := init n Fun.id);
        Bench.Test.create ~name:(Printf.sprintf "stdlib %d" n) (fun () -> g := Stdlib.List.init n Fun.id);
      ]
    )

let cases = [(*1; 2; 3; 4; 5; 6; 7; 8; 9; 10; *)100; 1000; 10000; 100000]

let () =
  Stdlib.List.iter test cases
