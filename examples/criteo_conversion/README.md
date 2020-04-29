# ocaml-vw Example: Criteo Conversion

## Summary
This directory contains a simple example showing the use of [Criteo's Conversion Logs Dataset](https://labs.criteo.com/2014/08/criteo-release-public-datasets/)
for the purpose of estimating conversion probability given a click on a display ad. This dataset has been pretty widely
used at this point for testing ML algorithms and libraries as it's an example of what real data tend to look like
within a company.
The data was originally used in Olivier Chapelle's [Modeling Delayed Feedback in Display Advertising](http://olivier.chapelle.cc/pub/delayedConv.pdf)
specifically to address the problems associated with estimating conversion (i.e. purchase) conditional on an ad having been clicked.

## How To
1. Download the data
  a. Visit http://labs.criteo.com/2013/12/conversion-logs-dataset/ and agree to the terms of use
  b. `wget` (or whatever) the data to the `data` directory in this repo
1. Build the project with `dune build`
1. Run `cat data.txt |  _build/default/examples/criteo_conversion/criteo_conversion.exe`

## Example Results
```
$ cat data.txt |  _build/default/examples/criteo_conversion/criteo_conversion.exe
Num weight bits = 22
learning rate = 0.05
initial_t = 0
power_t = 0.5
using no cache
Reading datafile =
num sources = 1
N: 1589888315890000 AvgLogloss: 0.38463 NLL:0.71457 Correct:13201145 (acc: 0.8308)
Average Test Log Likelihood: 0.714576
line num:  15898883 AvgLogloss: 0.38463 NLL:0.71458 Correct:13208560 (acc: 0.8308)
```
