open! Core
open Core_bench

let[@tail_mod_cons] rec trmc_map f = function
  | [] -> []
  | [x1] ->
    let y1 = f x1 in
    [y1]
  | [x1; x2] ->
    let y1 = f x1 in
    let y2 = f x2 in
    [y1; y2]
  | [x1; x2; x3] ->
    let y1 = f x1 in
    let y2 = f x2 in
    let y3 = f x3 in
    [y1; y2; y3]
  | x1 :: x2 :: x3 :: xs ->
    let y1 = f x1 in
    let y2 = f x2 in
    let y3 = f x3 in
    y1 :: y2 :: y3 :: trmc_map f xs

let rec map f = function
  | [] -> []
  | x :: xs -> let y = f x in y :: map f xs

let g = ref []

let test n =
  let l = Stdlib.List.init n Fun.id in
  Command_unix.run
    (Bench.make_command
      [
        Bench.Test.create ~name:(Printf.sprintf "  trmc %d" n) (fun () -> g := trmc_map Fun.id l);
        Bench.Test.create ~name:(Printf.sprintf "stdlib %d" n) (fun () -> g := map Fun.id l);
      ]
    )

let cases = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 100; 1000; 10000; 100000]

let () =
  Stdlib.List.iter test cases
