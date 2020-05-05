type handle
type example

external initialize : string -> handle = "caml_vw_init"
external finish_passes : handle -> unit = "caml_vw_finish_passes"
external finish : handle -> unit = "caml_vw_finish"
external read_example : handle -> string -> example = "caml_vw_read_example"
external finish_example : handle -> example -> unit = "caml_vw_finish_example"
external get_label : example -> float = "caml_vw_get_label"
external get_prediction : example -> float = "caml_vw_get_prediction"
external get_cost_sensitive_prediction : example -> float = "caml_vw_get_cost_sensitive_prediction"
external learn : handle -> example -> float = "caml_vw_learn"
external predict : handle -> example -> float = "caml_vw_predict"
external get_action_score : example -> int -> float = "caml_get_action_score"
external get_action_score_length : example -> int = "caml_get_action_score_length"
external get_tag_length : example -> int = "caml_vw_get_tag_length"
external get_tag : example -> string = "caml_vw_get_tag"
external get_feature_number : example -> int = "caml_vw_get_feature_number"
external get_confidence : example -> float = "caml_vw_get_confidence"
external get_weight : handle -> int -> int -> float = "caml_vw_get_weight"
external num_weights : handle -> int = "caml_vw_num_weights"
external save_model : handle -> unit = "caml_vw_save_model"

let learn_string vw ex_str =
  let ex = read_example vw ex_str in
  let ret = learn vw ex in
  finish_example vw ex;
  ret

let predict_string vw ex_str =
  let ex = read_example vw ex_str in
  let _ = predict vw ex in
  let ret = get_prediction ex in
  finish_example vw ex;
  ret

let cb_predict_string vw ex_str =
  let ex = read_example vw ex_str in
  let _ = predict vw ex in
  let ret = get_cost_sensitive_prediction ex in
  finish_example vw ex;
  ret

let fit vw example_strings num_passes =
    let examples = Array.map (fun x -> read_example vw x) example_strings in
    for _ = 0 to num_passes do
        for i = 0 to (Array.length examples) do
            let _ = learn vw examples.(i) in ()
        done;
    done;
    Array.iter (fun x -> finish_example vw x) examples;
    ()

let get_intercept vw =
  get_weight vw 116060 0
