let [@tail_mod_cons] rec map f l = match l with [] -> [] | x :: xs -> f x :: map f xs

let test f n =
  let l = List.init n Fun.id in
  let t0 = Unix.gettimeofday () in
  for _ = 1 to 100 do
    f Fun.id l
  done;
  let t1 = Unix.gettimeofday () in
  t1 -. t0

let cases = [10; 100; 1000; 10000; 100000; 1000000]

let () =
  let l1 = List.map (test List.map) cases in
  let l2 = List.map (test map) cases in
  Printf.printf "       n    List.map   trmc map\n";
  List.iter2 (fun n (t1, t2) ->
    Printf.printf "%8d    %.2f       %.2f\n" n t1 t2
             ) cases (List.combine l1 l2)
