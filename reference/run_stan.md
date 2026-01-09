# Run stan to generate a PoS prediction

A wrapper function to run stan in order to generate a PoS prediction

## Usage

``` r
run_stan(
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

- ...:

  params to pass to stan run

## Value

list which includes the generated stan object, list of data that was
supplied to
[`rstan::stan()`](https://mc-stan.org/rstan/reference/stan.html), and
the name of the stan file which was run

## Specification

The contents of this section are shown in PDF user manual only.

## See also

[`Normal`](https://rdrr.io/r/stats/Normal.html)
[`erf`](https://rdrr.io/pkg/pracma/man/erfz.html)
[`stan`](https://mc-stan.org/rstan/reference/stan.html)

## Examples

``` r
# use PFS data from a prior study
  run_stan(
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
#> Chain 1: Gradient evaluation took 5e-06 seconds
#> Chain 1: 1000 transitions using 10 leapfrog steps per transition would take 0.05 seconds.
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
#> Chain 1:                0.008 seconds (Sampling)
#> Chain 1:                0.025 seconds (Total)
#> Chain 1: 
#> $fit_rstan
#> Inference for Stan model: anon_model.
#> 1 chains, each with iter=1000; warmup=500; thin=1; 
#> post-warmup draws per chain=500, total post-warmup draws=500.
#> 
#>                  mean se_mean   sd   2.5%   25%   50%   75% 97.5% n_eff Rhat
#> mu_P            -0.14    0.01 0.11  -0.35 -0.22 -0.14 -0.06  0.08   200    1
#> tau_P2           0.07    0.00 0.06   0.00  0.03  0.06  0.11  0.19   333    1
#> tau_P3           0.04    0.00 0.03   0.00  0.02  0.03  0.06  0.11   433    1
#> theta_P2_raw     0.13    0.06 1.00  -1.77 -0.52  0.12  0.80  2.02   277    1
#> theta_P3_raw     0.01    0.05 0.99  -1.87 -0.67  0.04  0.71  2.03   351    1
#> theta_P2        -0.13    0.00 0.09  -0.29 -0.19 -0.13 -0.07  0.03   395    1
#> theta_P3        -0.14    0.01 0.12  -0.36 -0.23 -0.13 -0.06  0.09   237    1
#> theta_P3_hat[1] -0.14    0.01 0.14  -0.39 -0.23 -0.13 -0.05  0.15   289    1
#> theta_P3_hat[2] -0.14    0.01 0.13  -0.38 -0.22 -0.14 -0.05  0.13   315    1
#> vec_ones[1]      1.00     NaN 0.00   1.00  1.00  1.00  1.00  1.00   NaN  NaN
#> vec_ones[2]      1.00     NaN 0.00   1.00  1.00  1.00  1.00  1.00   NaN  NaN
#> lp__            -8.88    0.11 1.60 -12.56 -9.72 -8.66 -7.61 -6.65   224    1
#> 
#> Samples were drawn using NUTS(diag_e) at Fri Jan  9 01:11:48 2026.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).
#> 
#> $stan_list
#> $stan_list$omega
#> [1] 0.5
#> 
#> $stan_list$delta_P
#> [1] -0.3566749
#> 
#> $stan_list$sigma_P1
#> [1] 0.1533197
#> 
#> $stan_list$sigma_P2
#> [1] 0.1533197
#> 
#> $stan_list$tau_sd2
#> [1] 0.09266264
#> 
#> $stan_list$tau_sd3
#> [1] 0.04633132
#> 
#> $stan_list$J
#> [1] 2
#> 
#> $stan_list$Sigma
#>             [,1]        [,2]
#> [1,] 0.005405405 0.004273504
#> [2,] 0.004273504 0.004273504
#> 
#> $stan_list$theta_hat
#> [1] -0.1278334
#> 
#> $stan_list$theta_hat_sd
#> [1] 0.08926063
#> 
#> 
#> $stan_file
#> [1] "phase23_interim_pfs.stan"
#> 
```
