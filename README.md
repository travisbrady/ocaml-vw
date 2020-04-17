# ocaml-vw
OCaml bindings to [Vowpal Wabbit](https://vowpalwabbit.org/) aka `vw`

## Summary
This package provides experimental bindings to [Vowpal Wabbit](https://github.com/JohnLangford/vowpal_wabbit) via its C API using OCaml's [ctypes](https://github.com/ocamllabs/ocaml-ctypes) package.

Thus far these bindings expose an interface very similar to vw's command line interface. Essentially you pass command-line style switches
and then make sure your data match the VW input format.

## Basics
Vowpal Wabbit can be used for all sorts of standard supervised learning problems (regression and classification, bag-of-words style text classification, etc) but most recently has won renown for its [contextual bandits](https://getstream.io/blog/introduction-contextual-bandits/)
