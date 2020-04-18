type handle
type example

external initialize : string -> handle = "caml_vw_init"
external finish : handle -> unit = "caml_vw_finish"
external read_example : handle -> string -> example = "caml_vw_read_example"
external finish_example : handle -> example -> unit = "caml_vw_finish_example"
external get_label : example -> float = "caml_vw_get_label"
external learn : handle -> example -> float = "caml_vw_learn"
