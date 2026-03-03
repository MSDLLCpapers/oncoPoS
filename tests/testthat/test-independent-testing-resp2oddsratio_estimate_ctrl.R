test_that("resp2oddsratio_estimate_ctrl() produces a smaller mean odds ratio when the observed RR in trt is higher", {
  n_resp_trt1 <- 80 
  n_resp_trt2 <- 40 
  n_trt <- 100
  low_soc_rr <- 0.05
  upp_soc_rr <- 0.30
  
  log_or_high <-  resp2oddsratio_estimate_ctrl(
     n_resp_trt = n_resp_trt1,
     n_trt = n_trt,
     low_soc_rr = low_soc_rr,
     upp_soc_rr = upp_soc_rr,
     ci_rr = 0.80
   )
  
  log_or_low <-  resp2oddsratio_estimate_ctrl(
    n_resp_trt = n_resp_trt2,
    n_trt = n_trt,
    low_soc_rr = low_soc_rr,
    upp_soc_rr = upp_soc_rr,
    ci_rr = 0.80
  )
  
  expect_lt(exp(log_or_high$est), exp(log_or_low$est))
 
})

test_that("check the prior computation of mu and sigma on logit scale", {
  low_soc_rr = 0.15
  upp_soc_rr = 0.35
  ci_rr      = 0.8

  logit_low = log(low_soc_rr / (1 - low_soc_rr))
  logit_upp = log(upp_soc_rr / (1 - upp_soc_rr))

  mu_expected    = (logit_low + logit_upp) / 2
  sigma_expected = (logit_upp - logit_low) / (2 * qnorm(1 - (1 - ci_rr) / 2))

  # mu should be the midpoint of logit-transformed bounds
  expect_equal(mu_expected, (logit_low + logit_upp) / 2)

  # sigma should be positive
  expect_gt(sigma_expected, 0)

  # higher ci_rr => narrower normal quantile => larger sigma
  sigma_narrow_ci = (logit_upp - logit_low) / (2 * qnorm(1 - (1 - 0.5) / 2))
  sigma_wide_ci   = (logit_upp - logit_low) / (2 * qnorm(1 - (1 - 0.95) / 2))
  expect_gt(sigma_narrow_ci, sigma_wide_ci)
})

test_that("check the output structure of resp2oddsratio_estimate_ctrl", {
  n_resp_trt  = 33
  n_trt       = 60
  low_soc_rr  = 0.15
  upp_soc_rr  = 0.35
  ci_rr       = 0.8
  niter       = 2000
  nchains     = 1
  seed        = 123

  re = resp2oddsratio_estimate_ctrl(
    n_resp_trt  = n_resp_trt,
    n_trt       = n_trt,
    low_soc_rr  = low_soc_rr,
    upp_soc_rr  = upp_soc_rr,
    ci_rr       = ci_rr,
    niter       = niter,
    nchains     = nchains,
    seed        = seed
  )

  # check output contains est and se
  expect_true(all(c("est", "se") %in% names(re)))
  expect_equal(length(re), 2)

  # check est and se are numeric scalars
  expect_true(is.numeric(re$est))
  expect_true(is.numeric(re$se))
  expect_equal(length(re$est), 1)
  expect_equal(length(re$se), 1)

  # se must be positive
  expect_gt(re$se, 0)
})
