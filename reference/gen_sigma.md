# Generate covariance matrix for observed treatment effect in phase 3

Generates covariance matrix for an observed treatment effect, i.e., log
of hazard ratio in a phase 3 trial

## Usage

``` r
gen_sigma(n_events, ratio = 1)
```

## Arguments

- n_events:

  numeric vector of target number of events in phase 3

- ratio:

  randomization ratio of experimental arm compared to control

## Value

sigma_unit and covariance matrix to be used for PoS prediction

## Specification

The contents of this section are shown in PDF user manual only.

## Examples

``` r
if (FALSE) gen_sigma(c(100, 150), ratio = 1) # \dontrun{}
```
