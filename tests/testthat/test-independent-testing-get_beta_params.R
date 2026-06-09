test_that("check the output equals to expected values given different mean and var", {
  mean1 = 0.52
  var1 = 0.02

  mean2 = 0.3
  var2 = 0.05

  re1 = get_beta_params(mean1, var1)
  re2 = get_beta_params(mean2, var2)

  # compare to manually computed values
  alpha1 = mean1 * ((mean1 * (1 - mean1)) / var1 - 1)
  beta1  = (1 - mean1) * ((mean1 * (1 - mean1)) / var1 - 1)

  alpha2 = mean2 * ((mean2 * (1 - mean2)) / var2 - 1)
  beta2  = (1 - mean2) * ((mean2 * (1 - mean2)) / var2 - 1)

  expect_equal(re1$alpha, alpha1)
  expect_equal(re1$beta, beta1)

  expect_equal(re2$alpha, alpha2)
  expect_equal(re2$beta, beta2)
})

test_that("check the output list contains alpha and beta", {
  re = get_beta_params(mean = 0.52, var = 0.02)

  expect_true(all(c("alpha", "beta") %in% names(re)))
  expect_equal(length(re), 2)
})

test_that("check alpha and beta are both positive for valid inputs", {
  re1 = get_beta_params(mean = 0.5,  var = 0.01)
  re2 = get_beta_params(mean = 0.2,  var = 0.05)
  re3 = get_beta_params(mean = 0.8,  var = 0.03)

  expect_gt(re1$alpha, 0)
  expect_gt(re1$beta,  0)

  expect_gt(re2$alpha, 0)
  expect_gt(re2$beta,  0)

  expect_gt(re3$alpha, 0)
  expect_gt(re3$beta,  0)
})

test_that("check the relationship between alpha and beta reflects the mean", {
  # when mean > 0.5, alpha should be greater than beta
  re_high = get_beta_params(mean = 0.7, var = 0.02)
  expect_gt(re_high$alpha, re_high$beta)

  # when mean < 0.5, alpha should be less than beta
  re_low = get_beta_params(mean = 0.3, var = 0.02)
  expect_lt(re_low$alpha, re_low$beta)

  # when mean = 0.5, alpha should equal beta
  re_mid = get_beta_params(mean = 0.5, var = 0.02)
  expect_equal(re_mid$alpha, re_mid$beta)
})


test_that("check that alpha / (alpha + beta) recovers the original mean", {
  mean1 = 0.52; var1 = 0.02
  mean2 = 0.35; var2 = 0.04

  re1 = get_beta_params(mean1, var1)
  re2 = get_beta_params(mean2, var2)

  expect_equal(re1$alpha / (re1$alpha + re1$beta), mean1)
  expect_equal(re2$alpha / (re2$alpha + re2$beta), mean2)
})
