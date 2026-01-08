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