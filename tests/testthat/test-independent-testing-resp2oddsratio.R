test_that("compare the results of resp2oddsratio() to the expected values", {
  n_resp_trt1=30; n_resp_ctrl1=20
  n_resp_trt2=20; n_resp_ctrl2=30
  n_trt=100; n_ctrl=100
  
  ORR_OR1 = resp2oddsratio(n_resp_trt1, n_resp_ctrl1, n_trt, n_ctrl)
  ORR_OR2 = resp2oddsratio(n_resp_trt2, n_resp_ctrl2, n_trt, n_ctrl)
  
  expect_lt(exp(ORR_OR1$est), 1)
  expect_gt(ORR_OR1$se, 0)
  
  expect_gt(exp(ORR_OR2$est), 1)
  expect_gt(ORR_OR2$se, 0)
  
  # use example 1 to compare the results with expected values
  est = log(n_resp_ctrl1/n_ctrl / (1 - n_resp_ctrl1/n_ctrl) / (n_resp_trt1/n_trt / (1 - n_resp_trt1/n_trt)))
  se = sqrt(1/n_resp_ctrl1 + 1/(n_ctrl - n_resp_ctrl1) + 1/n_resp_trt1 + 1/(n_trt - n_resp_trt1))
  
  expect_equal(ORR_OR1$est, est)
  expect_equal(ORR_OR1$se, se)
})
