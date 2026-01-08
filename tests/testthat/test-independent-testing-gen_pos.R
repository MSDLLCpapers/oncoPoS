test_that("check results of gen_pos", {
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
  
  re_NoPFS_NoORR = gen_pos(
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
    seed = seed,
    plots_out = TRUE
  )
  
  re_PFS_NoORR = gen_pos(
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
    seed = seed,
    plots_out = TRUE
  )
  
  re_NoPFS_ORR = gen_pos(
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
    seed = seed,
    plots_out = TRUE
  )
  
  re_PFS_ORR = gen_pos(
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
    seed = seed,
    plots_out = TRUE
  )
  
  
  expect_true(all(re_NoPFS_NoORR$pos_est$pos > 0))
  expect_true(!is.null(re_NoPFS_NoORR$trace))
  expect_true(!is.null(re_NoPFS_NoORR$auto))
  
  expect_true(all(re_PFS_NoORR$pos_est$pos > 0))
  expect_true(!is.null(re_PFS_NoORR$trace))
  expect_true(!is.null(re_PFS_NoORR$auto))
  
  expect_true(all(re_NoPFS_ORR$pos_est$pos > 0))
  expect_true(!is.null(re_NoPFS_ORR$trace))
  expect_true(!is.null(re_NoPFS_ORR$auto))
  
  expect_true(all(re_PFS_ORR$pos_est$pos > 0))
  expect_true(!is.null(re_PFS_ORR$trace))
  expect_true(!is.null(re_PFS_ORR$auto))
})
