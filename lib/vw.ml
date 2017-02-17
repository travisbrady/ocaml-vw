open Ctypes

module C = Vw_bindings.C(Vw_generated)

let initialize args = C.vw_initialize args
