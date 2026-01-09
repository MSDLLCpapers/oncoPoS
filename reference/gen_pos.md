# PoS estimation

PoS estimation

## Usage

``` r
gen_pos(
  target_hr,
  J,
  nevents3,
  hr_bound,
  omega,
  est_obs_pfs,
  low_obs_pfs,
  upp_obs_pfs,
  obs_pfs_conf_level = 0.95,
  thres = 0.01,
  n_trt2,
  n_ctrl2,
  n_resp_trt2,
  n_resp_ctrl2,
  use_orr = FALSE,
  use_pfs = FALSE,
  het_degree_p2 = "small",
  het_degree_p3 = "very small",
  ratio = 1,
  m_0 = NA,
  m_1 = NA,
  nu_0 = NA,
  nu_1 = NA,
  lm_sd = NA,
  niter = 1000,
  nchains = 4,
  ncores = 4,
  seed,
  plots_out = FALSE,
  ...
)
```

## Arguments

- target_hr:

  target hazard ration in phase 3 study (i.e., under alternative
  hypothesis)

- J:

  number of planned analyses in phase 3 study

- nevents3:

  numeric vector of target number of events in phase 3 study

- hr_bound:

  numeric vector of hazard ratio bounds for analyses in phase 3 study

- omega:

  probability that a treatment effect comes from a enthusiastic prior
  component, i.e., initial benchmarking probability for the study
  success

- est_obs_pfs:

  estimated PFS hazard ratio based on prior/earlier study

- low_obs_pfs:

  lower bound of estimated PFS hazard ratio based on prior/earlier study

- upp_obs_pfs:

  upper bound of estimated PFS hazard ratio based on prior/earlier study

- obs_pfs_conf_level:

  confidence level for the estimated PFS hazard ratio bounds, Default:
  0.95

- thres:

  probability of either lack treatment effect under the enthusiastic
  prior or substantial treatment effect under the pessimistic prior.
  Should be set to a small value, close to 0, Default: 0.01

- n_trt2:

  sample size in treatment arm from a prior/earlier study

- n_ctrl2:

  sample size in control arm from a prior/earlier study

- n_resp_trt2:

  number of responses in treatment arm from a prior/earlier study

- n_resp_ctrl2:

  number of responses in control arm from a prior/earlier study

- use_orr:

  whether response data from a prior/earlier study should be used,
  Default: FALSE

- use_pfs:

  whether PFS data from a prior/earlier study should be used, Default:
  FALSE

- het_degree_p2:

  indicates the degree of heterogeneity of a study level parameter for a
  prior/earlier study and must be one of "large", "substantial",
  "moderate", "small", "very small", Default: 'small'.

- het_degree_p3:

  indicates the degree of heterogeneity of a study level parameter for a
  phase 3 study and must be one of "large", "substantial", "moderate",
  "small", "very small", Default: 'very small'

- ratio:

  randomization ratio of experimental arm compared to control

- m_0:

  intercept for linear regression of log treatment effect of PFS on log
  treatment effect on response. A value is expected only when
  `use_orr = TRUE` and `use_pfs = TRUE`, Default: NA

- m_1:

  slope for linear regression of log treatment effect of PFS on log
  treatment effect on response. A value is expected only when
  `use_orr = TRUE` and `use_pfs = TRUE`, Default: NA

- nu_0:

  standard error of `m_0`. A value is expected only when
  `use_orr = TRUE` and `use_pfs = TRUE`, Default: NA

- nu_1:

  standard error of `m_1`. A value is expected only when
  `use_orr = TRUE` and `use_pfs = TRUE`, Default: NA

- lm_sd:

  linear regression residual variance of log treatment effect of PFS on
  log treatment effect on response. A value is expected only when
  `use_orr = TRUE` and `use_pfs = TRUE`, Default: NA

- niter:

  number of iterations to be used in stan run, Default: 1000

- nchains:

  number of chains to be used in stan run, Default: 4

- ncores:

  number of cores to be used in stan run, Default: 4

- seed:

  seed to be used in stan run

- plots_out:

  whether plots for MCMC chains and autocorrelation should be printed,
  Default: FALSE

- ...:

  params to pass to stan run

## Value

tibble of PoS estimates and the corresponding standard errors for each
analysis. If `plots_out` is turned on, then the MCMC chains mixing and
autocorrelation plots are provided as well.

## Specification

The contents of this section are shown in PDF user manual only.

## See also

[`gather_draws`](https://mjskay.github.io/tidybayes/reference/spread_draws.html)
[`mutate`](https://dplyr.tidyverse.org/reference/mutate.html),
[`group_by`](https://dplyr.tidyverse.org/reference/group_by.html),
[`summarise`](https://dplyr.tidyverse.org/reference/summarise.html)
[`map2`](https://purrr.tidyverse.org/reference/map2.html),
[`reexports`](https://purrr.tidyverse.org/reference/reexports.html)
[`MCMC-traces`](https://mc-stan.org/bayesplot/reference/MCMC-traces.html),
[`MCMC-diagnostics`](https://mc-stan.org/bayesplot/reference/MCMC-diagnostics.html)

## Examples

``` r
# use PFS data from a prior study

  gen_pos(
    target_hr = 0.7, 
    J = 2,  
    nevents3 = c(370, 468), 
    hr_bound = c(0.779, 0.8204), 
    omega = 0.5, 
    est_obs_pfs = 0.88, 
    low_obs_pfs = 0.74, 
    upp_obs_pfs = 1.05, 
    use_pfs = TRUE, 
    seed = 325,
    ncores = 1,
    nchains = 1) 
#> 
#> SAMPLING FOR MODEL 'anon_model' NOW (CHAIN 1).
#> Chain 1: 
#> Chain 1: Gradient evaluation took 6e-06 seconds
#> Chain 1: 1000 transitions using 10 leapfrog steps per transition would take 0.06 seconds.
#> Chain 1: Adjust your expectations accordingly!
#> Chain 1: 
#> Chain 1: 
#> Chain 1: Iteration:   1 / 1000 [  0%]  (Warmup)
#> Chain 1: Iteration: 100 / 1000 [ 10%]  (Warmup)
#> Chain 1: Iteration: 200 / 1000 [ 20%]  (Warmup)
#> Chain 1: Iteration: 300 / 1000 [ 30%]  (Warmup)
#> Chain 1: Iteration: 400 / 1000 [ 40%]  (Warmup)
#> Chain 1: Iteration: 500 / 1000 [ 50%]  (Warmup)
#> Chain 1: Iteration: 501 / 1000 [ 50%]  (Sampling)
#> Chain 1: Iteration: 600 / 1000 [ 60%]  (Sampling)
#> Chain 1: Iteration: 700 / 1000 [ 70%]  (Sampling)
#> Chain 1: Iteration: 800 / 1000 [ 80%]  (Sampling)
#> Chain 1: Iteration: 900 / 1000 [ 90%]  (Sampling)
#> Chain 1: Iteration: 1000 / 1000 [100%]  (Sampling)
#> Chain 1: 
#> Chain 1:  Elapsed Time: 0.017 seconds (Warm-up)
#> Chain 1:                0.009 seconds (Sampling)
#> Chain 1:                0.026 seconds (Total)
#> Chain 1: 
#> # A tibble: 2 × 3
#>       J   pos pos_se
#>   <int> <dbl>  <dbl>
#> 1     1 0.202 0.0180
#> 2     2 0.322 0.0209
```
