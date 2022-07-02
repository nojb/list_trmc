open! Core
open Core_bench

let[@tail_mod_cons] rec map2 f l1 l2 =
  match (l1, l2) with
  | [], [] -> []
  | [a1], [b1] ->
      let r1 = f a1 b1 in
      [r1]
  | a1::a2::l1, b1::b2::l2 ->
    let r1 = f a1 b1 in
    let r2 = f a2 b2 in
      r1::r2::map2 f l1 l2
  | _, _ -> invalid_arg "map2"


let[@tail_mod_cons] rec map f = function
  | [] -> []
  | [a1] ->
      let r1 = f a1 in
      [r1]
  | a1::a2::l ->
    let r1 = f a1 in
    let r2 = f a2 in
      r1::r2::map f l

let[@tail_mod_cons] rec mapi f i = function
  | [] -> []
  | [a1] ->
      let r1 = f i a1 in
      [r1]
  | a1::a2::l ->
    let r1 = f i a1 in
    let r2 = f (i+1) a2 in
      r1::r2::mapi f (i+2) l

let mapi f l = mapi f 0 l

let g = ref []

let map2_test n =
  let lst = Stdlib.List.init n Fun.id in
  Command_unix.run
    (Bench.make_command
      [
        Bench.Test.create ~name:(Printf.sprintf "map2 trmc unrolled %d" n) (fun () -> g := map2 (+) lst lst);
        Bench.Test.create ~name:(Printf.sprintf "map2 stdlib        %d" n) (fun () -> g := Stdlib.List.map2 (+) lst lst);
      ]
    )

let map_test n =
  let lst = Stdlib.List.init n Fun.id in
  Command_unix.run
    (Bench.make_command
      [
        Bench.Test.create ~name:(Printf.sprintf "map trmc unrolled %d" n) (fun () -> g := map succ lst);
        Bench.Test.create ~name:(Printf.sprintf "map stdlib        %d" n) (fun () -> g := Stdlib.List.map succ lst);
      ]
    )

let mapi_test n =
  let lst = Stdlib.List.init n Fun.id in
  Command_unix.run
    (Bench.make_command
      [
        Bench.Test.create ~name:(Printf.sprintf "mapi trmc unrolled %d" n) (fun () -> g := mapi (+) lst);
        Bench.Test.create ~name:(Printf.sprintf "mapi stdlib        %d" n) (fun () -> g := Stdlib.List.mapi (+) lst);
      ]
    )

let cases = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 100; 1000; 10000; 100000; (*1000000*)]

let () =
  Stdlib.List.iter map_test cases;
  Stdlib.List.iter mapi_test cases;
  Stdlib.List.iter map2_test cases
