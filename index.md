# oncoPoS

## Overview

`oncoPoS` performs Probability of Success (PoS) calculations for a phase
3 oncology study using a Bayesian Hierarchical model. The prior in this
model is based on the data observed in an earlier study, design features
for the phase 3 study that is being assessed and the industry benchmark
for success.

## Installation

You can install development version of `oncoPoS` from GitHub with:

``` r
if (!requireNamespace("remotes")) {
  install.packages("remotes")
}
remotes::install_github("MSDLLCPapers/oncoPoS")
```

## Example

Below is a simple example which assumes the following information is
available for the an oncology phase 3 trial PoS calculation:

- Design features of a phase 3 trial:

  - Progression-free survival (PFS) is the primary endpoint with the
    target hazard ratio (HR) of 0.7;
  - Two analyses using group sequential approach are planned;
  - The number of target events at each analysis is 370 and 468;
  - The approximate HR bound at each analysis is 0.7790 and 0.8204;
  - The randomization ratio is 2:1.

- The above phase 3 trial is planned following promising results in an
  earlier phase 2 study, which reported PFS HR (95% CI) of 0.53 (0.31,
  0.91).

- The industry benchmark for success is 0.57 for this type of phase 3
  trial.

All the above information is synthesized in
[`oncoPoS::gen_pos()`](msdllcpapers.github.io/oncoPoS/reference/gen_pos.md)
using Bayesian Hierarchical model to generate a PoS estimate:

``` r
gen_pos(
  target_hr =  0.70,
  J = 2,
  nevents3 = c(370, 468),
  hr_bound = c(0.7790, 0.8204),
  est_obs_pfs = 0.53,
  low_obs_pfs = 0.31,
  upp_obs_pfs = 0.91,
  omega = 0.57,
  seed = 574,
  ratio = 2,
  use_pfs = TRUE,
  nchains = 4,
  niter = 1000
) 
```
