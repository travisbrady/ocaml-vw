open Ctypes

module C = Vw_bindings.C(Vw_generated)

let initialize args = C.vw_initialize args
let read_example vw ex_str = C.vw_read_example vw ex_str
let get_example vw = C.vw_get_example vw
let finish_example ex = C.vw_finish_example ex
let get_label ex = C.vw_get_label ex
let learn handle ex = C.vw_learn handle ex
let predict handle ex = C.vw_predict handle ex
let save_model handle = C.vw_save_model handle
