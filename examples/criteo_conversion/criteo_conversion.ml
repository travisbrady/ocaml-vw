open Core

let printf = Printf.printf
let eprintf = Printf.eprintf
let sprintf = Printf.sprintf
let log1_5 = Float.log 1.5

type example = {
    chunks : string list;
    label : string;
    train_string : string;
    test_string : string
 }

let encode_int_feature v =
  if (String.is_empty v) then v
  else (
    let open Float in
    let fv = of_string v in
    let encoded = match fv > 0.0 with
      | true ->  (Float.log (fv + 0.5)) / log1_5
      | false -> fv
    in
    sprintf "%.0f" encoded
  )

let eps = 1e-15

let clip x =
    let x' = Float.max eps x in
    let x'' = Float.min x' (1.0 -. eps) in
    x''

let logloss y_true y_pred =
    let p = clip y_pred in
    match y_true with
    | "1" -> -1.0 *. (Float.log p)
    | _ -> -1.0 *. (Float.log (1.0 -. p))

let parse_line line =
  let chunks = String.split line ~on:'\t' in
  let conv_ts = List.nth_exn chunks 1 in
  let label = if (String.is_empty conv_ts) then "-1" else "1" in
  let int_features = List.sub chunks ~pos:2 ~len:8
    |> List.filter ~f:(fun x -> String.is_empty x |> not)
    |> List.map ~f:encode_int_feature
    |> List.mapi ~f:(fun i x -> sprintf "intf%d_%s" i x)
    |> String.concat ~sep:" "
  in
  let cat_features = List.drop chunks 10
    |> List.filter ~f:(fun x -> String.is_empty x |> not)
    |> List.mapi ~f:(fun i x -> sprintf "catf%d_%s" i x)
    |> String.concat ~sep:" " in
  let train_string = sprintf "%s | %s %s" label int_features cat_features in
  let test_string = sprintf "| %s %s" int_features cat_features in
  {chunks=chunks; label=label; train_string=train_string; test_string=test_string}
  
let () =
  let ctr = ref 0 in
  let ll = ref 0.0 in
  let correct = ref 0 in
  let logloss_sum = ref 0.0 in
  let vw = Vw.initialize "-b 22 -l 0.05 --loss_function logistic --link=logistic" in
  In_channel.iter_lines In_channel.stdin ~f:(fun line ->
    let fi = Float.of_int !ctr in
    let acc = (Float.of_int !correct) /. (Float.of_int !ctr) in
    if !ctr mod 10_000 = 0 then eprintf "line num: %9d AvgLogloss: %.5f NLL:%.5f Correct:%d (acc: %.4f)\r%!" !ctr (!logloss_sum /. fi) (!ll /. fi) !correct acc;
    let ex = parse_line line in
    let p = Vw.learn_string vw ex.train_string in
    logloss_sum := !logloss_sum +. (logloss ex.label p);
    if ((String.equal ex.label "1" && Float.(>=) p 0.5) || (String.equal ex.label "-1" && Float.(<) p 0.5)) then incr correct;
    let dp = if (String.equal ex.label "1") then (-1.0 *. p) else p in
    ll := !ll +. (Float.log (1.0 +. (Float.exp dp)));
    incr ctr;
  );
  printf "N: %d\n" !ctr;
  printf "Average Test Log Likelihood: %f\n" (!ll /. (Float.of_int !ctr));
  let fi = Float.of_int !ctr in
  let acc = (Float.of_int !correct) /. (Float.of_int !ctr) in
  Vw.finish_passes vw;
  printf "line num: %9d AvgLogloss: %.5f NLL:%.5f Correct:%d (acc: %.4f)\n" !ctr (!logloss_sum /. fi) (!ll /. fi) !correct acc
