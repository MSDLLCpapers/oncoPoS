# ---------------------------------------------------------------------------
# Stan sampling mock — analogous to VCR cassettes in API testing.
#
# Fixtures are pre-generated stanfit objects (200 iter each) stored in
# tests/testthat/fixtures/.  They contain real MCMC draws so all downstream
# consumers (rstan::extract, tidybayes::spread_draws, bayesplot) work without
# change.
#
# Routing: the mock inspects the `data` list passed to rstan::sampling /
# rstan::stan to determine which cassette to load:
#
#   n_resp_trt key present  → estimate_ctrl model (keyed by n_resp_trt value)
#   theta_hat + orr_hat     → phase23_interim_both
#   theta_hat only          → phase23_interim_pfs
#   orr_hat only            → phase23_interim_orr
#   (none of the above)     → phase23_interim_none
#
# Usage inside a test_that() block:
#
#   local_mocked_bindings(
#     sampling = mock_rstan_sampling,
#     stan     = mock_rstan_stan,
#     .package = "rstan"
#   )
# ---------------------------------------------------------------------------

.stan_fixture_path <- function(name) {
  testthat::test_path("fixtures", paste0("stanfit_", name, ".rds"))
}

.load_stan_fixture <- function(name) {
  readRDS(.stan_fixture_path(name))
}

.route_stan_fixture <- function(data) {
  if ("n_resp_trt" %in% names(data)) {
    if (data$n_resp_trt >= 60L)  return(.load_stan_fixture("estimate_ctrl_high"))
    if (data$n_resp_trt >= 40L)  return(.load_stan_fixture("estimate_ctrl_low"))
    return(.load_stan_fixture("estimate_ctrl_struct"))
  }
  if ("theta_hat" %in% names(data) && "orr_hat" %in% names(data))
    return(.load_stan_fixture("both"))
  if ("theta_hat" %in% names(data))
    return(.load_stan_fixture("pfs"))
  if ("orr_hat" %in% names(data))
    return(.load_stan_fixture("orr"))
  .load_stan_fixture("none")
}

# Drop-in replacement for rstan::sampling (used when precompiled model exists)
mock_rstan_sampling <- function(object, data, iter, chains, cores, seed, ...) {
  .route_stan_fixture(data)
}

# Drop-in replacement for rstan::stan (used as fallback when no precompiled model)
mock_rstan_stan <- function(file, data, iter, chains, cores, seed, ...) {
  .route_stan_fixture(data)
}
