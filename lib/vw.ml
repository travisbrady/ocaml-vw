open Ctypes

module C = Vw_bindings.C(Vw_generated)

let initialize args = C.vw_initialize args
let read_example ex_str = C.vw_read_example ex_str
let get_label ex = C.vw_get_label ex
let learn handle ex = C.vw_learn handle ex
