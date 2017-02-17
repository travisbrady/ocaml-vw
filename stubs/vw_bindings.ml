open Ctypes

module C (F : Cstubs.FOREIGN) = struct
    let (@->) = F.(@->)
    let returning = F.returning

    type vw_handle
    let vw_handle = ptr void

    let vw_initialize = F.foreign "VW_Initialize" (string @-> returning vw_handle)
end
