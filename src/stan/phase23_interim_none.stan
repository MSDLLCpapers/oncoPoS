data {
  // data
  // hyperparameters:
  real tau_sd2;
  real tau_sd3; // half normal prior variance 
  real omega; // mixture weight
  real delta_P; // mean for pessimistic scenario
  real sigma_P1; // stdev for optimistic scenario
  real sigma_P2; // stdev for pessimistic scenario
  int<lower = 1> J; // number of interim analyses
  matrix[J, J] Sigma; // covariance matrix for the observational level model in phase III
  // hyperparameters for the simple linear regression coefficients
  // determined from previous meta analyses
}

transformed data {
  matrix[J, J] L; // Cholesky decomposition for the covariance matrix
  L = cholesky_decompose(Sigma); // Lower triangle matrix after Chol. decomposition
  
}

parameters {
  real mu_P;
  real<lower=0> tau_P2;
  real<lower=0> tau_P3; // study-level treatment variance at phase 3
  // phase III parameters 
  real theta_P2_raw;              // real phase 3 tmt effects
  real theta_P3_raw;              // real phase 3 tmt effects

}

transformed parameters {
  real theta_P2;
  real theta_P3;              // real phase 3 tmt effects
  
  theta_P2 = mu_P + tau_P2*theta_P2_raw;
  theta_P3 = mu_P + tau_P3*theta_P3_raw;
}
  
model {
  // stan will try to find posterior of them here
  // linear relationship
  // population level
  target += log_mix(omega, normal_lpdf(mu_P|delta_P,sigma_P1), normal_lpdf(mu_P|0,sigma_P2));
  
  // study level
  tau_P2    ~ normal(0,    tau_sd2);
  tau_P3    ~ normal(0,    tau_sd3);
  theta_P2_raw  ~ std_normal();
  theta_P3_raw  ~ std_normal();
}

generated quantities {
  vector[J] theta_P3_hat;     // observed phase 3 tmt effects
  vector[J] vec_ones;
  
  vec_ones = rep_vector(1,J);
  theta_P3_hat = multi_normal_cholesky_rng(theta_P3*vec_ones, L);
}
