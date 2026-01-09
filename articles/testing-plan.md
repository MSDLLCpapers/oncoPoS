# Function Validation Plan

## Summary of testing plan

> Validation details are located in the `tests/testthat/` folder.

| file                                       | test                                                                                |
|:-------------------------------------------|:------------------------------------------------------------------------------------|
| test-independent-testing-gen_pos.R         | check results of gen_pos                                                            |
| test-independent-testing-gen_sigma.R       | check the expected output when ratio = 1, 2                                         |
| test-independent-testing-gen_sigma.R       | check the dimensions of the cov_matrix are correct based on length of n_events      |
| test-independent-testing-get_denominator.R | check the output equals to expected values given different degrees of heterogeneity |
| test-independent-testing-resp2oddsratio.R  | compare the results of resp2oddsratio() to the expected values                      |
| test-independent-testing-run_stan.R        | Test the stan_list and stan_file when different combinations of endpoints are used  |
