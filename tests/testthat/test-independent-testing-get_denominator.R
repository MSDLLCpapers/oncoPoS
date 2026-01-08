test_that("check the output equals to expected values given different degrees of heterogeneity", {
  expect_error(get_denominator("very large"))
  
  expect_equal(get_denominator("large"), 1/4)
  expect_equal(get_denominator("substantial"), 1/8)
  expect_equal(get_denominator("moderate"), 1/16)
  expect_equal(get_denominator("small"), 1/32)
  expect_equal(get_denominator("very small"), 1/64)
})
