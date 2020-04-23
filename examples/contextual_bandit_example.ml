(*
 * A trivial contextual bandit example intended to match the Python example here:
  * https://github.com/VowpalWabbit/vowpal_wabbit/blob/master/python/examples/Contextual_Bandit_Example_with_VW_Python_Wrapper.ipynb
  *
*)
let printf = Printf.printf

let train = [
 "1:2:0.4 | a c";
  "3:0:0.2 | b d";
  "4:1:0.5 | a b";
  "2:1:0.3 | a b c";
  "3:1:0.7 | a d"]

let test = [
  "| b c"; 
  "| a b";
  "| b b";
  "| a b"]

let () =
  let vw = Vw.initialize "--quiet --cb 4" in
  let _ = List.map (fun x -> Vw.learn_string vw x) train in

  let testx = List.map (fun x -> Vw.read_example vw x) test in
  printf "testx done\n%!";

  let _ = List.map (fun x -> Vw.predict vw x) testx in
  printf "predict done\n%!";

  let _ = List.map (fun x -> Vw.get_cost_sensitive_prediction x) testx in
  printf "p done\n%!";

  List.iter (fun x -> printf "pred=%f  |  conf=%f\n" (Vw.get_cost_sensitive_prediction x) (Vw.get_confidence x)) testx;

  List.iter (fun x -> Vw.finish_example vw x) testx;
  Vw.finish vw
