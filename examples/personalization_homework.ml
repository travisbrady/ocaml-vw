open Core_kernel

let printf = Printf.printf
let sprintf = Printf.sprintf

let () =
  let vw = Vw.initialize "--quiet --cb 10 --epsilon 0.1 --cb_type ips" in
  let ic = In_channel.create "data/dataset.txt" in
  let ctr = ref 0 in
  let numerator_sum = ref 0.0 in
  let denom_sum = ref 0.0 in
  In_channel.iter_lines ic ~f:(fun line ->
    let chunks = String.split line ~on:' ' in
    let features = List.mapi (List.drop chunks 2) ~f:(fun i x -> sprintf "f%d:%s.0" (i+1) x) |> String.concat ~sep:" " in

    let lab = List.hd_exn chunks in
    let labf = Float.of_string lab in
    let reward = Float.of_string (List.nth_exn chunks 1) in
    let cost = 1.0 /. (1.0 +. reward) in
    let vw_string = sprintf "%s:%.3f:0.1 |%s" lab cost features in
    let ex = Vw.read_example vw vw_string in

    if !ctr > 0 then begin
      let test_string = sprintf "|%s" features in
      let testx = Vw.read_example vw test_string in
      let _ = Vw.predict vw testx in
      let p = Vw.get_cost_sensitive_prediction ex in
      let are_same = if (Float.equal labf p) then 1.0 else 0.0 in
      denom_sum := !denom_sum +. are_same;
      let num = reward *. are_same in
      numerator_sum := !numerator_sum +. num;
      let _ = Vw.finish_example vw testx in
      if (!ctr mod 100) = 0 then 
        printf "Take Rate: %f\n" (!numerator_sum /. !denom_sum)
      else ();
      ()
    end else ();
      
    let _ = Vw.learn vw ex in
    let _ = Vw.finish_example vw ex in
    incr ctr;
  )
