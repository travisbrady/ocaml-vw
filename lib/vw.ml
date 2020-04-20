type handle
type example

external initialize : string -> handle = "caml_vw_init"
external finish : handle -> unit = "caml_vw_finish"
external read_example : handle -> string -> example = "caml_vw_read_example"
external finish_example : handle -> example -> unit = "caml_vw_finish_example"
external get_label : example -> float = "caml_vw_get_label"
external learn : handle -> example -> float = "caml_vw_learn"
external predict : handle -> example -> float = "caml_vw_predict"
external get_action_score : example -> int -> float = "caml_get_action_score"
external save_model : handle -> unit = "caml_vw_save_model"

let fit vw example_strings num_passes =
    let examples = Array.map (fun x -> read_example vw x) example_strings in
    for _ = 0 to num_passes do
        for i = 0 to (Array.length examples) do
            let _ = learn vw examples.(i) in ()
        done;
    done;
    ()
