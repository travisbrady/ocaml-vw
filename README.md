# ocaml-vw
OCaml bindings to vowpal wabbit

## Summary
This package provides experimental bindings to [Vowpal Wabbit](https://github.com/JohnLangford/vowpal_wabbit) via its C API using OCaml's [ctypes](https://github.com/ocamllabs/ocaml-ctypes) package.

Thus far these bindings expose an interface very similar to vw's command line interface. Essentially you passes command-line style switches
and then make sure your data match the VW input format.
