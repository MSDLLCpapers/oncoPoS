data {
  //real<lower=0, upper=1> p_resp_trt;       // observed treatment response rate
  int<lower=0> n_resp_trt;               // responders in treatment arm
  int<lower=0> n_trt;               // total in treatment arm
  real mu_logit_ctrl;                       // mean of logit(p_resp_soc)
  real<lower=0> sigma_logit_ctrl;           // SD of logit(p_resp_soc)
}

parameters {
  real<lower=0, upper=1> p_resp_trt;      // treatment response probability
  real logit_p_resp_soc;                  // latent logit(p_resp_soc)
}

transformed parameters {
  real<lower=0, upper=1> p_resp_soc = inv_logit(logit_p_resp_soc);
  real log_odds_orr_trt = log(p_resp_trt / (1 - p_resp_trt));
  real log_odds_orr_soc = log(p_resp_soc / (1 - p_resp_soc));
  real log_or = log_odds_orr_soc - log_odds_orr_trt;
}

model {
  logit_p_resp_soc ~ normal(mu_logit_ctrl, sigma_logit_ctrl);  // prior on control arm ORR
  n_resp_trt ~ binomial(n_trt, p_resp_trt); // Binomial likelihood for treatment arm
}
