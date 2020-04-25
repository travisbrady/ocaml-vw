(*
 * A quick test based on this homework assignment: http://www.cs.columbia.edu/~jebara/6998/hw2.pdf
 *)
open Core

let printf = Printf.printf
let sprintf = Printf.sprintf

let show_tables left right =
  printf "\n";
  let al = Float.Table.to_alist left |> List.sort ~compare:(fun a b -> Float.compare (fst a) (fst b)) in
  List.iter al ~f:(fun (key, data) ->
    match Float.Table.find right key with
    | Some x -> printf "key:%.0f real=%d recd=%d\n" key data x
    | None -> printf "key:%.0f real=%d recd=\n" key data
  )

type example_components = {
    chunks : string list;
    features : string;
    lab : string;
    labf : float;
    reward : float;
    train_string : string;
    test_string : string
}

let parse_line line =
  let chunks = String.split line ~on:' ' in
  let features = List.mapi (List.drop chunks 2) ~f:(fun i x -> sprintf "f%d:%s.0" (i+1) x) |> String.concat ~sep:" " in

  let lab = List.hd_exn chunks in
  let labf = Float.of_string lab in
  let reward = Float.of_string (List.nth_exn chunks 1) in
  let cost = 1.0 -. reward in
  let vw_string = sprintf "%s:%.4f:0.1 |%s" lab cost features in
  let test_string = sprintf "|%s" features in
  {chunks=chunks; features=features; lab=lab; labf=labf;
    reward=reward; test_string=test_string;
    train_string=vw_string}

let () =
  let vw = Vw.initialize "--cb 10 --cover 3 --cb_type dm" in
  let ic = In_channel.create "data/dataset.txt" in
  let ctr = ref 0 in
  let numerator_sum = ref 0.0 in
  let denom_sum = ref 0.0 in

  let real_actions : int Float.Table.t = Float.Table.create () in
  let reco_arms : int Float.Table.t = Float.Table.create () in
  let correct_pred = Float.Table.create () in

  In_channel.iter_lines ic ~f:(fun line ->
    let ec = parse_line line in
    Float.Table.incr real_actions ec.labf;

    let p = Vw.cb_predict_string vw ec.test_string in
    Float.Table.incr reco_arms p;
    let are_same = if (Float.equal ec.labf p) then 1.0 else 0.0 in
    denom_sum := !denom_sum +. are_same;
    numerator_sum := !numerator_sum +. (ec.reward *. are_same);
    Float.Table.incr correct_pred ~by:(Int.of_float are_same) p;

    if (!ctr mod 200) = 0 then (
        printf "%.2f %.2f Take Rate: %f\n" !numerator_sum !denom_sum (!numerator_sum /. !denom_sum));

    let _ = Vw.learn_string vw ec.train_string in
    incr ctr;
  );
  Vw.finish vw;
  show_tables real_actions reco_arms;
  printf "Total Agreements: %.0f\n" !denom_sum;
  let al = Float.Table.to_alist correct_pred |> List.sort ~compare:(fun a b -> Float.compare (fst a) (fst b)) in

  printf "\nCorrect Preds\n";
  List.iter al ~f:(fun (key, data) ->
      printf "key:%.0f count:%d\n" key data
   );
   printf "%.2f %.2f Take Rate: %f\n" !numerator_sum !denom_sum (!numerator_sum /. !denom_sum)
