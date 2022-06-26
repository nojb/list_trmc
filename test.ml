open! Core
open Core_bench

let[@tail_mod_cons] rec trmc_map f l =
  match l with
  |[] -> []
  | x :: xs -> let y = f x in y :: trmc_map f xs

let rec map f l =
  match l with
  |[] -> []
  | x :: xs -> let y = f x in y :: map f xs

let test n =
  let l = Stdlib.List.init n Fun.id in
  Command_unix.run
    (Bench.make_command
      [
        Bench.Test.create ~name:(Printf.sprintf "stdlib %d" n) (fun () -> ignore (map Fun.id l));
        Bench.Test.create ~name:(Printf.sprintf "  trmc %d" n) (fun () -> ignore (trmc_map Fun.id l));
      ]
    )

let () =
  for n = 1 to 10 do
    test n
  done
