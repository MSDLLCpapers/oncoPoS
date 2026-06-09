# Run Stan to Predict Probability of Success (PoS) for Phase III Trial

A wrapper function to run stan in order to generate a PoS prediction

## Usage

``` r
run_stan(
  target_hr,
  J,
  nevents3,
  hr_bound,
  omega_mean = 0.52,
  omega_var = 0.02,
  est_obs_pfs,
  low_obs_pfs,
  upp_obs_pfs,
  obs_pfs_conf_level = 0.95,
  thres = 0.01,
  n_trt2,
  n_ctrl2,
  n_resp_trt2,
  n_resp_ctrl2,
  low_soc_rr,
  upp_soc_rr,
  ci_rr = 0.8,
  use_orr = FALSE,
  single_arm = FALSE,
  use_pfs = FALSE,
  het_degree_p2 = "small",
  het_degree_p3 = "very small",
  ratio = 1,
  indication = 6,
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

- omega_mean:

  Mean of the Beta prior for `omega`. `omega` is the probability that a
  treatment effect comes from a enthusiastic prior component, i.e.,
  initial benchmarking probability for the study success

- omega_var:

  Variance of the Beta prior for `omega`.

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

- low_soc_rr:

  Lower bound of historical control response rate for single-arm
  estimation.

- upp_soc_rr:

  Upper bound of historical control response rate for single-arm
  estimation.

- ci_rr:

  Confidence level for control response rate bounds, Default: 0.8.

- use_orr:

  whether response data from a prior/earlier study should be used,
  Default: FALSE

- single_arm:

  whether ORR data is from a single-arm trial, Default: FALSE.

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

- indication:

  Integer from 1 to 6 for selecting indication-specific ORR-PFS
  regression parameters, as follows: 1 = hematologic malignancies 2 =
  gynecologic cancers 3 = thoracic cancers 4 = other solid tumors 5 =
  breast cancer 6 = any tumor type Default: 6

- m_0:

  intercept for linear regression of log treatment effect of PFS on log
  treatment effect on response. A value is expected only when
  `use_orr = TRUE` and `use_pfs = TRUE`. Auto-filled based on
  `indication` if not supplied.

- m_1:

  slope for linear regression of log treatment effect of PFS on log
  treatment effect on response. A value is expected only when
  `use_orr = TRUE` and `use_pfs = TRUE`. Auto-filled based on
  `indication` if not supplied.

- nu_0:

  standard error of `m_0`. A value is expected only when
  `use_orr = TRUE` and `use_pfs = TRUE`. Auto-filled based on
  `indication` if not supplied.

- nu_1:

  standard error of `m_1`. A value is expected only when
  `use_orr = TRUE` and `use_pfs = TRUE`. Auto-filled based on
  `indication` if not supplied.

- lm_sd:

  linear regression residual variance of log treatment effect of PFS on
  log treatment effect on response. A value is expected only when
  `use_orr = TRUE` and `use_pfs = TRUE`. Auto-filled based on
  `indication` if not supplied.

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
# use single arm ORR data from a prior study
  run_stan(
  target_hr =  0.70,
  J = 2,
  nevents3 = c(370, 468),
  hr_bound = c(0.7790, 0.8204),
  thres = 0.01, 
  n_trt2 = 100, 
  n_resp_trt2 = 40, 
  low_soc_rr = 0.05, 
  upp_soc_rr = 0.2, 
  use_orr = TRUE, 
  single_arm = TRUE,
  ncores = 1,
  nchains = 1,
  seed=111)
#> 
#> SAMPLING FOR MODEL 'anon_model' NOW (CHAIN 1).
#> Chain 1: 
#> Chain 1: Gradient evaluation took 7e-06 seconds
#> Chain 1: 1000 transitions using 10 leapfrog steps per transition would take 0.07 seconds.
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
#> Chain 1:  Elapsed Time: 0.011 seconds (Warm-up)
#> Chain 1:                0.007 seconds (Sampling)
#> Chain 1:                0.018 seconds (Total)
#> Chain 1: 
#> $fit_rstan
#> Inference for Stan model: anon_model.
#> 1 chains, each with iter=1000; warmup=500; thin=1; 
#> post-warmup draws per chain=500, total post-warmup draws=500.
#> 
#>                   mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff
#> beta_0_raw       -0.41    0.04 0.94  -2.17  -1.02  -0.38   0.25   1.29   545
#> beta_1_raw        0.28    0.04 0.99  -1.69  -0.39   0.29   0.97   2.18   738
#> orr_P_raw        -0.34    0.03 0.97  -2.28  -0.96  -0.34   0.29   1.60   767
#> mu_P             -0.39    0.01 0.17  -0.69  -0.50  -0.41  -0.29   0.03   312
#> tau_P2            0.07    0.00 0.05   0.00   0.03   0.06   0.10   0.21   582
#> tau_P3            0.03    0.00 0.03   0.00   0.01   0.03   0.05   0.10   465
#> theta_P2_raw     -0.25    0.04 1.00  -2.15  -0.87  -0.28   0.46   1.63   642
#> theta_P3_raw     -0.05    0.04 0.96  -1.87  -0.70  -0.10   0.59   1.91   494
#> omega             0.55    0.01 0.14   0.27   0.46   0.55   0.65   0.79   579
#> theta_P2         -0.41    0.01 0.18  -0.78  -0.54  -0.43  -0.31   0.00   410
#> theta_P3         -0.39    0.01 0.18  -0.71  -0.51  -0.41  -0.28   0.03   357
#> beta_0           -0.10    0.01 0.17  -0.42  -0.21  -0.10   0.02   0.20   545
#> beta_1            1.87    0.01 0.36   1.16   1.63   1.88   2.12   2.56   738
#> orr_P            -0.94    0.02 0.38  -1.66  -1.18  -0.97  -0.69  -0.14   475
#> theta_P3_hat[1]  -0.39    0.01 0.20  -0.75  -0.52  -0.40  -0.26   0.01   433
#> theta_P3_hat[2]  -0.39    0.01 0.19  -0.73  -0.52  -0.40  -0.27   0.02   405
#> vec_ones[1]       1.00     NaN 0.00   1.00   1.00   1.00   1.00   1.00   NaN
#> vec_ones[2]       1.00     NaN 0.00   1.00   1.00   1.00   1.00   1.00   NaN
#> lp__            -19.85    0.16 2.25 -24.65 -21.21 -19.59 -18.22 -16.36   200
#>                 Rhat
#> beta_0_raw      1.00
#> beta_1_raw      1.00
#> orr_P_raw       1.00
#> mu_P            1.00
#> tau_P2          1.00
#> tau_P3          1.00
#> theta_P2_raw    1.00
#> theta_P3_raw    1.00
#> omega           1.00
#> theta_P2        1.00
#> theta_P3        1.00
#> beta_0          1.00
#> beta_1          1.00
#> orr_P           1.00
#> theta_P3_hat[1] 1.00
#> theta_P3_hat[2] 1.00
#> vec_ones[1]      NaN
#> vec_ones[2]      NaN
#> lp__            1.01
#> 
#> Samples were drawn using NUTS(diag_e) at Tue Jun  9 13:14:06 2026.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).
#> 
#> $stan_list
#> $stan_list$omega_alpha
#> [1] 5.9696
#> 
#> $stan_list$omega_beta
#> [1] 5.5104
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
#> $stan_list$orr_hat
#> [1] -1.743023
#> 
#> $stan_list$orr_hat_sd
#> [1] 0.6377326
#> 
#> $stan_list$m_0
#> [1] -0.03014321
#> 
#> $stan_list$m_1
#> [1] 1.771319
#> 
#> $stan_list$nu_0
#> [1] 0.1789729
#> 
#> $stan_list$nu_1
#> [1] 0.3598188
#> 
#> $stan_list$wls_sd
#> [1] 0.202218
#> 
#> 
#> $stan_file
#> [1] "phase23_interim_orr.stan"
#> 
```
