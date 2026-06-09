# Function Validation Plan

## Summary of testing plan

> Validation details are located in the `tests/testthat/` folder.

| file | test |
|:---|:---|
| test-independent-testing-gen_pos.R | check results of gen_pos |
| test-independent-testing-gen_sigma.R | check the expected output when ratio = 1, 2 |
| test-independent-testing-gen_sigma.R | check the dimensions of the cov_matrix are correct based on length of n_events |
| test-independent-testing-get_beta_params.R | check the output equals to expected values given different mean and var |
| test-independent-testing-get_beta_params.R | check the output list contains alpha and beta |
| test-independent-testing-get_beta_params.R | check alpha and beta are both positive for valid inputs |
| test-independent-testing-get_beta_params.R | check the relationship between alpha and beta reflects the mean |
| test-independent-testing-get_beta_params.R | check that alpha / (alpha + beta) recovers the original mean |
| test-independent-testing-get_denominator.R | check the output equals to expected values given different degrees of heterogeneity |
| test-independent-testing-resp2oddsratio_estimate_ctrl.R | resp2oddsratio_estimate_ctrl() produces a smaller mean odds ratio when the observed RR in trt is higher |
| test-independent-testing-resp2oddsratio_estimate_ctrl.R | check the prior computation of mu and sigma on logit scale |
| test-independent-testing-resp2oddsratio_estimate_ctrl.R | check the output structure of resp2oddsratio_estimate_ctrl |
| test-independent-testing-resp2oddsratio.R | compare the results of resp2oddsratio() to the expected values |
| test-independent-testing-run_stan.R | Test the stan_list and stan_file when different combinations of endpoints are used |
