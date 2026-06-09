# Estimate Log Odds Ratio Using Observed Response Data and Prior on Control Arm

Estimates the log odds ratio (log OR) between treatment and control arms
in a single-arm trial by combining observed responses in treatment arm
with prior knowledge of the control response rate. The prior
distribution on the control arm's response rate is specified through a
credible interval.

## Usage

``` r
resp2oddsratio_estimate_ctrl(
  n_resp_trt,
  n_trt,
  low_soc_rr,
  upp_soc_rr,
  ci_rr = 0.8,
  niter = 1000,
  nchains = 1,
  ncores = 1,
  seed = 123,
  refresh = 0,
  ...
)
```

## Arguments

- n_resp_trt:

  number of responses in the treatment arm

- n_trt:

  sample size in the treatment arm

- low_soc_rr:

  lower bound of the control arm's response rate

- upp_soc_rr:

  upper bound of the control arm's response rate

- ci_rr:

  confidence level (e.g., 0.80) for the control arm response rate
  interval.

- niter:

  number of iterations to be used in stan run, Default: 1000

- nchains:

  number of chains to be used in stan run, Default: 4

- ncores:

  number of cores to be used in stan run, Default: 4

- seed:

  seed to be used in stan run

- refresh:

  integer, progress indicator, Default: 0 (turned off)

- ...:

  params to pass to stan run

## Value

A list containing:

- `est`:

  Posterior mean of the log odds ratio.

- `se`:

  Posterior standard deviation (i.e., standard error) of the log odds
  ratio.

## Details

This function is useful in single-arm trials where the control arm is
not directly observed. A prior on the control arm's response rate
provided as a credible interval, is transformed into a normal prior on
the logit scale. The posterior distribution of the log odds ratio is
then estimated using Bayesian inference via Stan.

The Stan model (`estimate_ctrl.stan`) is loaded from the installed
package directory.

## Specification

The contents of this section are shown in the PDF user manual only.

## Examples

``` r
if (FALSE) { # \dontrun{
resp2oddsratio_estimate_ctrl(
  n_resp_trt = 40,
  n_trt = 100,
  low_soc_rr = 0.05,
  upp_soc_rr = 0.30,
  ci_rr = 0.80
)
} # }
```
