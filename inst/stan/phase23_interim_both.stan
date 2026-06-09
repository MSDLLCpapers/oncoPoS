data {
  // data
  real orr_hat; // vector of treatment effects 
  real orr_hat_sd; // sampling error variance for theta_hat
  real theta_hat; // vector of treatment effects 
  real theta_hat_sd; // sampling error variance for theta_hat
  // hyperparameters:
  real tau_sd2; // half normal prior variance 
  real tau_sd3; // half normal prior variance 
  //real omega; // mixture weight
  real<lower=0> omega_alpha;
  real<lower=0> omega_beta;
  real delta_P; // mean for pessimistic scenario
  real sigma_P1; // stdev for optimistic scenario
  real sigma_P2; // stdev for pessimistic scenario
  int<lower = 1> J; // number of interim analyses
  matrix[J, J] Sigma; // covariance matrix for the observational level model in phase III
  // hyperparameters for the simple linear regression coefficients
  // determined from previous meta analyses
  real m_0;
  real nu_0;
  real m_1;
  real nu_1;
  real wls_sd; // residual variance for the association WLS model; 
}

transformed data {
  matrix[J, J] L; // Cholesky decomposition for the covariance matrix
  L = cholesky_decompose(Sigma); // Lower triangle matrix after Chol. decomposition
  
}

parameters {
  real beta_0_raw;
  real beta_1_raw;
  real orr_P_raw;
  real mu_P;
  real<lower=0> tau_P2;
  real<lower=0> tau_P3; // study-level treatment variance at phase 3
  // phase III parameters 
  real theta_P2_raw;              // real phase 3 tmt effects
  real theta_P3_raw;              // real phase 3 tmt effects

  real<lower=0, upper=1> omega;
}

transformed parameters {
  real theta_P2;
  real theta_P3;              // real phase 3 tmt effects
  real beta_0;
  real beta_1;
  real orr_P;
  
  //orr_P = mu_P + tau_P2 * orr_P_raw;
  theta_P2 = mu_P + tau_P2*theta_P2_raw;
  theta_P3 = mu_P + tau_P3*theta_P3_raw;

  beta_0 = m_0 + nu_0*beta_0_raw;
  beta_1 = m_1 + nu_1*beta_1_raw;
  
  //theta_P2 = beta_0 + beta_1*orr_P + wls_sd*theta_P2_raw; //orr_P as the independent variable
  orr_P = beta_0 + beta_1*theta_P2 + wls_sd*orr_P_raw;
}

model {
  // stan will try to find posterior of them here
  // linear relationship
  // population level
  //omega ~ beta(2, 2); // weakly informative prior
  omega ~ beta(omega_alpha, omega_beta); // informative prior from step 1
  target += log_mix(omega, normal_lpdf(mu_P|delta_P,sigma_P1), normal_lpdf(mu_P|0,sigma_P2));
  
  // regression parameter;
  beta_0_raw   ~ std_normal();
  beta_1_raw   ~ std_normal();
  
  // study level
  tau_P2    ~ normal(0,    tau_sd2);
  tau_P3    ~ normal(0,    tau_sd3);
  
  theta_P2_raw  ~ std_normal();
  theta_P3_raw  ~ std_normal();
  
  orr_P_raw    ~ std_normal();
  
  orr_hat  ~ normal(orr_P, orr_hat_sd);
  theta_hat  ~ normal(theta_P2, theta_hat_sd);
  
}

generated quantities {
  vector[J] theta_P3_hat;     // observed phase 3 tmt effects
  vector[J] vec_ones;
  
  vec_ones = rep_vector(1,J);
  theta_P3_hat = multi_normal_cholesky_rng(theta_P3*vec_ones, L);
}
