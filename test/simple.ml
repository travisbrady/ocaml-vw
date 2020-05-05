let test_regression () =
  let vw = Vw.initialize "-f /tmp/testmodel.vw -l 100.0" in
  let _ = Vw.learn_string vw "1 | f1:1 f2:2" in
  let _ = Vw.learn_string vw "2 | f1:3 f2:4" in
  let _ = Vw.learn_string vw "3 | f1:5 f2:6" in
  let _ = Vw.learn_string vw "4 | f1:7 f2:8" in
  let p = Vw.predict_string vw "| f1:1 f2:2" in
  Vw.save_model vw ;
  Alcotest.(check @@ float epsilon_float) "pred = input" 1.0 p ;
  Alcotest.(check @@ float epsilon_float)
    "intercept = input" 0.3333333432674408 (Vw.get_intercept vw) ;
  Vw.finish vw

let test_classification () =
  let vw =
    Vw.initialize "-l 0.01 --l2 0.1 --link logistic --loss_function logistic"
  in
  let _ = Vw.learn_string vw "-1 | f1:1 f2:2" in
  let _ = Vw.learn_string vw "-1 | f1:3 f2:4" in
  let _ = Vw.learn_string vw "1 | f1:5 f2:6" in
  let _ = Vw.learn_string vw "1 | f1:7 f2:8" in
  let p = Vw.predict_string vw "| f1:1 f2:2" in
  Alcotest.(check @@ float 2.0) "pred in 0 to 1" 1.0 (p -. 1.0) ;
  Vw.finish vw

let test_bandit () =
  let vw = Vw.initialize "--cb 4" in
  let _ = Vw.learn_string vw "1:2:0.4 | a c" in
  let _ = Vw.learn_string vw "3:0:0.2 | b d" in
  let _ = Vw.learn_string vw "4:1:0.5 | a b" in
  let _ = Vw.learn_string vw "2:1:0.3 | a b c" in
  let _ = Vw.learn_string vw "3:1:0.7 | a d" in
  let test_x = ["| b c"; "| a b"; "| b b"; "| a b"] in
  let preds =
    List.map (fun x -> Vw.cb_predict_string vw x |> int_of_float) test_x
  in
  Alcotest.(check (list int)) "cb preds should be all 3" [3; 3; 3; 3] preds

let test_num_weights () =
  let bit_precisions = [18; 19; 20; 21; 22; 23; 24] in
  let expected =
    [262144; 524288; 1048576; 2097152; 4194304; 8388608; 16777216]
  in
  let nw_results =
    List.map
      (fun i ->
        let init_str =
          Printf.sprintf
            "-b %d -l 0.1 --l2 0.1 --link logistic --loss_function logistic"
            i
        in
        let vw = Vw.initialize init_str in
        let num_weights = Vw.num_weights vw in
        Vw.finish vw ; num_weights)
      bit_precisions
  in
  Alcotest.(check (list int))
    "num weights should be 2^`bit_precisions`" expected nw_results

let () =
  Alcotest.run "Utils"
    [ ( "test_models"
      , [ Alcotest.test_case "Test Regression" `Quick test_regression
        ; Alcotest.test_case "Test Classification" `Quick test_classification
        ; Alcotest.test_case "Test Bandit" `Quick test_bandit
        ; Alcotest.test_case "Test Num Weights" `Quick test_num_weights ] )
    ]
