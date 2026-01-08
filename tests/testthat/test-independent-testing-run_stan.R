test_that("Test the stan_list and stan_file when different combinations of endpoints are used", {
  target_hr = 0.7
  J = 2
  nevents3 = c(370, 468)
  hr_bound = c(0.779, 0.8204)
  omega_mean = 0.7
  omega_var = 0.03
  est_obs_pfs = 0.53
  low_obs_pfs = 0.31
  upp_obs_pfs = 0.91
  obs_pfs_conf_level = 0.95
  thres = 0.01
  n_trt2 = 60
  n_ctrl2 = 63
  n_resp_trt2 = 33
  n_resp_ctrl2 = 18
  het_degree_p2 = "small"
  het_degree_p3 = "very small"
  ratio = 1
  m_0 = 0.05
  m_1 = 0.4
  nu_0 = 0.05
  nu_1 = 0.2
  lm_sd = 5
  niter = 3000
  nchains = 1
  ncores = 1
  seed = 123
  
  NoPFS_NoORR <- run_stan(
    target_hr = target_hr,
    J = J,
    nevents3 = nevents3,
    hr_bound = hr_bound, 
    omega_mean = omega_mean,
    omega_var = omega_var,
    est_obs_pfs = est_obs_pfs,
    low_obs_pfs = low_obs_pfs,
    upp_obs_pfs = upp_obs_pfs,
    obs_pfs_conf_level = obs_pfs_conf_level,
    thres = thres,
    n_trt2 = n_trt2, 
    n_ctrl2 = n_ctrl2,
    n_resp_trt2 = n_resp_trt2, 
    n_resp_ctrl2 = n_resp_ctrl2,
    use_orr = FALSE,
    use_pfs = FALSE,
    het_degree_p2 = het_degree_p2,
    het_degree_p3 = het_degree_p3,
    ratio = ratio,
    m_0 = m_0,
    m_1 = m_1,
    nu_0 = nu_0,
    nu_1 = nu_1,
    lm_sd = lm_sd,
    niter = niter,
    nchains = nchains,
    ncores = ncores,
    seed = seed
    )
  
  PFS_NoORR <- run_stan(
    target_hr = target_hr,
    J = J,
    nevents3 = nevents3,
    hr_bound = hr_bound, 
    omega_mean = omega_mean,
    omega_var = omega_var,
    est_obs_pfs = est_obs_pfs,
    low_obs_pfs = low_obs_pfs,
    upp_obs_pfs = upp_obs_pfs,
    obs_pfs_conf_level = obs_pfs_conf_level,
    thres = thres,
    n_trt2 = n_trt2, 
    n_ctrl2 = n_ctrl2,
    n_resp_trt2 = n_resp_trt2, 
    n_resp_ctrl2 = n_resp_ctrl2,
    use_orr = FALSE,
    use_pfs = TRUE,
    het_degree_p2 = het_degree_p2,
    het_degree_p3 = het_degree_p3,
    ratio = ratio,
    m_0 = m_0,
    m_1 = m_1,
    nu_0 = nu_0,
    nu_1 = nu_1,
    lm_sd = lm_sd,
    niter = niter,
    nchains = nchains,
    ncores = ncores,
    seed = seed
  )
  
  NoPFS_ORR <- run_stan(
    target_hr = target_hr,
    J = J,
    nevents3 = nevents3,
    hr_bound = hr_bound, 
    omega_mean = omega_mean,
    omega_var = omega_var,
    est_obs_pfs = est_obs_pfs,
    low_obs_pfs = low_obs_pfs,
    upp_obs_pfs = upp_obs_pfs,
    obs_pfs_conf_level = obs_pfs_conf_level,
    thres = thres,
    n_trt2 = n_trt2, 
    n_ctrl2 = n_ctrl2,
    n_resp_trt2 = n_resp_trt2, 
    n_resp_ctrl2 = n_resp_ctrl2,
    use_orr = TRUE,
    use_pfs = FALSE,
    het_degree_p2 = het_degree_p2,
    het_degree_p3 = het_degree_p3,
    ratio = ratio,
    m_0 = m_0,
    m_1 = m_1,
    nu_0 = nu_0,
    nu_1 = nu_1,
    lm_sd = lm_sd,
    niter = niter,
    nchains = nchains,
    ncores = ncores,
    seed = seed
    )
  
  PFS_ORR <- run_stan(
    target_hr = target_hr,
    J = J,
    nevents3 = nevents3,
    hr_bound = hr_bound, 
    omega_mean = omega_mean,
    omega_var = omega_var,
    est_obs_pfs = est_obs_pfs,
    low_obs_pfs = low_obs_pfs,
    upp_obs_pfs = upp_obs_pfs,
    obs_pfs_conf_level = obs_pfs_conf_level,
    thres = thres,
    n_trt2 = n_trt2, 
    n_ctrl2 = n_ctrl2,
    n_resp_trt2 = n_resp_trt2, 
    n_resp_ctrl2 = n_resp_ctrl2,
    use_orr = TRUE,
    use_pfs = TRUE,
    het_degree_p2 = het_degree_p2,
    het_degree_p3 = het_degree_p3,
    ratio = ratio,
    m_0 = m_0,
    m_1 = m_1,
    nu_0 = nu_0,
    nu_1 = nu_1,
    lm_sd = lm_sd,
    niter = niter,
    nchains = nchains,
    ncores = ncores,
    seed = seed
    )
  
  expect_equal(NoPFS_NoORR$stan_file, "phase23_interim_none.stan")
  expect_equal(PFS_NoORR$stan_file, "phase23_interim_pfs.stan")
  expect_equal(NoPFS_ORR$stan_file, "phase23_interim_orr.stan")
  expect_equal(PFS_ORR$stan_file, "phase23_interim_both.stan")
  
  expect_equal(NoPFS_NoORR$stan_list$delta_P, PFS_NoORR$stan_list$delta_P)
  expect_equal(NoPFS_NoORR$stan_list$sigma_P1, PFS_NoORR$stan_list$sigma_P1)
  expect_equal(NoPFS_NoORR$stan_list$sigma_P2, PFS_NoORR$stan_list$sigma_P2)
  expect_equal(NoPFS_NoORR$stan_list$tau_sd2, PFS_NoORR$stan_list$tau_sd2)
  expect_equal(NoPFS_NoORR$stan_list$tau_sd3, PFS_NoORR$stan_list$tau_sd3)
  expect_equal(NoPFS_NoORR$stan_list$Sigma, PFS_NoORR$stan_list$Sigma)
  
  expect_equal(PFS_NoORR$stan_list$theta_hat, PFS_ORR$stan_list$theta_hat)
  expect_equal(PFS_NoORR$stan_list$theta_hat_sd, PFS_ORR$stan_list$theta_hat_sd)
  
  expect_equal(NoPFS_ORR$stan_list$orr_hat, PFS_ORR$stan_list$orr_hat)
  expect_equal(NoPFS_ORR$stan_list$orr_hat_sd, PFS_ORR$stan_list$orr_hat_sd)
  expect_equal(NoPFS_ORR$stan_list$wls_sd, PFS_ORR$stan_list$wls_sd)
  
  # check stan_list items
  expect_true(all(c("omega_alpha","omega_beta","delta_P","sigma_P1","sigma_P2","tau_sd2","tau_sd3","J","Sigma")
                  %in% names(NoPFS_NoORR$stan_list)))
  expect_true(all(c("omega_alpha","omega_beta","delta_P","sigma_P1","sigma_P2","tau_sd2","tau_sd3","J","Sigma",
                    "theta_hat","theta_hat_sd") %in% names(PFS_NoORR$stan_list)))
  expect_true(all(c("omega_alpha","omega_beta","delta_P","sigma_P1","sigma_P2","tau_sd2","tau_sd3","J","Sigma",
                    "orr_hat","orr_hat_sd","m_0","m_1","nu_0","nu_1","wls_sd") 
                  %in% names(NoPFS_ORR$stan_list)))
  expect_true(all(c("omega_alpha","omega_beta","delta_P","sigma_P1","sigma_P2","tau_sd2","tau_sd3","J","Sigma",
                    "theta_hat","theta_hat_sd", "orr_hat","orr_hat_sd","m_0","m_1","nu_0",
                    "nu_1","wls_sd") %in% names(PFS_ORR$stan_list)))
})
