ratio1 = 1; ratio2= 2
n_events1 = c(125, 180)
n_events2 = c(75, 110, 150, 188, 220)

# generate matrix of denominator for the covariance matrix based on target number of events in phase 3
event_mat = function(n_events){
  L = length(n_events)
  
  event_mat=matrix(NA, nrow=L, ncol=L)
  for (i in 1:L) {
    for (j in 1:L) {
      m_idx = max(i, j)
      event_mat[i, j] = n_events[m_idx]
    }
  }
  
  event_mat
}


test_that("check the expected output when ratio = 1, 2", {
  sigma_unit1 = 1 / sqrt(1 / (1 + ratio1) * (1 - 1/(1 + ratio1)))
  sigma_unit2 = 1 / sqrt(1 / (1 + ratio2) * (1 - 1/(1 + ratio2)))
  
  cov_matrix1 = sigma_unit1 / event_mat(n_events1)
  cov_matrix2 = sigma_unit2 / event_mat(n_events1)
  
  gen_sigma_re1 = gen_sigma(n_events1, ratio1)
  gen_sigma_re2 = gen_sigma(n_events1, ratio2)
  
  expect_equal(gen_sigma_re1$sigma_unit, sigma_unit1)
  expect_equal(gen_sigma_re2$sigma_unit, sigma_unit2)
  
  expect_equal(gen_sigma_re1$cov_matrix, cov_matrix1)
  expect_equal(gen_sigma_re2$cov_matrix, cov_matrix2)
  
  expect_lt(gen_sigma_re1$cov_matrix[2,2], gen_sigma_re1$cov_matrix[1,1])
  expect_lt(gen_sigma_re2$cov_matrix[2,2], gen_sigma_re2$cov_matrix[1,1])
})


test_that("check the dimensions of the cov_matrix are correct based on length of n_events", {
  gen_sigma_re3 = gen_sigma(n_events2, ratio1)
  
  expect_equal(dim(gen_sigma_re3$cov_matrix)[1], length(n_events2))
})
