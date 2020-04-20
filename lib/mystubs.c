#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <stdio.h>

#include <vowpalwabbit/vwdll.h>

CAMLprim value caml_vw_init(value v_args) {
 VW_HANDLE vw = VW_InitializeA(String_val(v_args));
 return (value)vw;
}

CAMLprim value caml_vw_finish(value v_handle) {
 VW_Finish((VW_HANDLE)v_handle);
 return Val_unit;
}

CAMLprim value caml_vw_read_example(value v_handle, value v_example) {
 VW_EXAMPLE ex =
     VW_ReadExampleA((VW_HANDLE)v_handle, (const char*)String_val(v_example));
 return (value)ex;
}

CAMLprim value caml_vw_finish_example(value v_handle, value v_example) {
 VW_FinishExample((VW_HANDLE)v_handle, (VW_EXAMPLE)v_example);
 return Val_unit;
}

CAMLprim value caml_vw_get_label(value v_example) {
 return caml_copy_double(VW_GetLabel((VW_EXAMPLE)v_example));
}

CAMLprim value caml_vw_learn(value v_handle, value v_example) {
 return caml_copy_double(VW_Learn((VW_HANDLE)v_handle, (VW_EXAMPLE)v_example));
}

CAMLprim value caml_vw_predict(value v_handle, value v_example) {
 return caml_copy_double(
     VW_Predict((VW_HANDLE)v_handle, (VW_EXAMPLE)v_example));
}

CAMLprim value caml_get_action_score(value v_example, value v_i) {
  return caml_copy_double(VW_GetActionScore((VW_EXAMPLE)v_example, (size_t)Int_val(v_i)));
}

CAMLprim value caml_vw_save_model(value v_handle) {
 VW_SaveModel((VW_HANDLE)v_handle);
 return Val_unit;
}
