# Modeling imprecise interpretation and production using probabilistic pragmatics 

This repository contains the code and visualizations associated with Waldon (2022), "A Novel Probabilistic Approach to Linguistic Imprecision", which appears in *Measurements, Numerals and Scales
Essays in Honour of Stephanie Solt* (eds. Nicole Gotzner and Uli Sauerland).

The repository consists of the following parts: 

## WebPPL simulation code: `model_code` and `model_code_morealts` 

Two extensionless files -- `model_code` and `model_code_morealts` -- contain WebPPL code that is executable either from R (see below) or directly in the online WebPPL interpreter (accessible at http://webppl.org/). 

`model_code` defines the context parameters for the simulations that correspond to Model 1 of the paper, while `model_code_morealts` defines those of the simulations that correspond to Model 2. 

### Constructing speaker and listener distributions 

The following commands may be appended (either in R or in the WebPPL interpreter) to the base simulation code to construct speaker and listener distributions, respectively.

#### `impSpeaker(state,alpha,beta,halos)` 

- `state`: an intended meaning (an element of `states`)
- `alpha`: the alpha optimality parameter
- `beta`: the global imprecision parameter that determines the degree of "Partial-Truth" (PT) activation for the speaker. When `beta` = 0, `impSpeaker` behaves as the classic RSA pragmtic speaker would.
- `halos`: an array, either `yeshalos` or `nohalos`. With `nohalos`, the degree of PT activation is equal for all non-numeral quantifiers in the alternative set. (This corresponds to Simulation #X). `nohalos` corresponds to Simulation #X: only `the` has the potential to be used imprecisely. 

#### `pragmaticListener(utterance,alpha,beta,halos)` 

- `utterance`: an utterance (an element of `utterances`)
- `alpha`, `beta`, `halos`: defined as above. (These parameters are passed to `impSpeaker` within the call to `pragmaticListener`)

NOTE: To explore the model predictions vis a vis imprecise production of numerals (as discusssed in Footnote 11), refer to the model code in `model_numerals`. 

## R interface to WebPPL and visualization scripts: `analysis.R` 

This file includes all the code for generating the distributions reported in the paper. It relies on MH Tessler's `rwebppl` package (see https://github.com/mhtess/rwebppl for more info). It also contains all the code necessary for reproducing the graphs reported in the paper. 
