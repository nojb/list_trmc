open! Core
open Core_bench

let[@tail_mod_cons] rec of_seq seq =
  match seq () with
  | Seq.Nil -> []
  | Seq.Cons (x, seq) -> x :: of_seq seq

let[@tail_mod_cons] rec init i n f =
  if i >= n then []
  else
    let r = f i in
    r :: init (i+1) n f

let init len f =
  if len < 0 then invalid_arg "List.init" else
  init 0 len f

let g = ref []

let test n =
  Command_unix.run
    (Bench.make_command
      [
        Bench.Test.create ~name:(Printf.sprintf "stdlib  %d" n) (fun () -> g := Stdlib.List.init n Fun.id);
        Bench.Test.create ~name:(Printf.sprintf "trmc    %d" n) (fun () -> g := init n Fun.id);
      ]
    )

let test2 n =
  let l = Stdlib.List.to_seq (Stdlib.List.init n Fun.id) in
  Command_unix.run
    (Bench.make_command
      [
        Bench.Test.create ~name:(Printf.sprintf "stdlib  %d" n) (fun () -> g := Stdlib.List.of_seq l);
        Bench.Test.create ~name:(Printf.sprintf "trmc    %d" n) (fun () -> g := of_seq l);
      ]
    )


let cases = [1; 2; 3; 4; 5; 10; 100; 1000; 10001; 100000; (*1000000*)]

let () =
  Stdlib.List.iter test cases;
  Stdlib.List.iter test2 cases;
