# Examples

A few examples of using vw from OCaml with the bindings provided herein.

* [simple.ml](simple.ml) A trivial example showing how to create a vw instance and learn from a few examples
* [contextual_bandit_example.ml](contextual_bandit_example.ml) Shows very basic CB interface with learning and arm prediction
* [personalization_homework.ml](personalization_homework.ml) An OCaml/vw solution to the CS homework found at http://www.cs.columbia.edu/~jebara/6998/hw1.pdf
  * This is taken from Tony Jebara's "Machine Learning for Personalization" course at Columbia
* [criteo_conversion/criteo_conversion.ml](criteo_conversion.ml) The goal here is to estimate user conversion conditional on having clicked an ad. 
  * This is a simple demo of a conversion estimation task with some basic features
  * Original paper: http://olivier.chapelle.cc/pub/delayedConv.pdf
