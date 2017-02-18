open Ctypes

module C (F : Cstubs.FOREIGN) = struct
    let (@->) = F.(@->)
    let returning = F.returning

    type vw_handle
    let vw_handle = ptr void

    type vw_example
    let vw_example = ptr void

    type vw_feature_space
    let vw_feature_space = ptr void

    let vw_initialize = F.foreign "VW_InitializeA" (string @-> returning vw_handle)
    let vw_finish_passes = F.foreign "VW_Finish_Passes" (vw_handle @-> returning void)
    let vw_finish = F.foreign "VW_Finish" (vw_handle @-> returning void)

    let vw_import_example = F.foreign "VW_ImportExample" (vw_handle @-> string @-> ptr vw_feature_space @-> size_t @-> returning vw_example)
    let vw_read_example = F.foreign "VW_ReadExampleA" (vw_handle @-> string @-> returning vw_example)
    let vw_get_label = F.foreign "VW_GetLabel" (vw_example @-> returning float)
    let vw_learn = F.foreign "VW_Learn" (vw_handle @-> vw_example @-> returning float)

end
