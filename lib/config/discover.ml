module C = Configurator.V1

let () =
  C.main ~name:"vw" (fun c ->
  let default : C.Pkg_config.package_conf =
   { libs   = ["-L/usr/local/Cellar/vowpal-wabbit/8.8.1_1/lib"; "-lvw_c_wrapper"]
    ; cflags = ["-I /usr/local/Cellar/vowpal-wabbit/8.8.1_1/include"]
    }
  in
  let conf =
    match C.Pkg_config.get c with
    | None -> default
    | Some pc ->
       match (C.Pkg_config.query pc ~package:"libvw_c_wrapper") with
       | None ->
         default
       | Some deps ->
         (* This is a hack.
          * Remove the boost flags that confused OCaml
          * e.g. Boost::program_options Boost::system Boost::thread Boost::unit_test_framework
          *)
         let clean_libs = List.filter (fun x -> String.contains x ':' |> not) deps.libs in
         (*deps*)
         {deps with libs = clean_libs}
  in

  C.Flags.write_sexp "c_flags.sexp"         conf.cflags;
  C.Flags.write_sexp "c_library_flags.sexp" conf.libs)
