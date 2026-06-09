# Run this script once from the package root to regenerate Stan fixtures.
# Only needed after modifying Stan models or on a new machine/rstan version.
# Commit the generated .rds files to version control alongside the precompiled
# platform cache so CI environments can run tests without Stan installed.
#
# Usage (from package root):
#   Rscript tests/testthat/fixtures/generate_fixtures.R

devtools::load_all(quiet = TRUE)

fixture_dir <- file.path("tests", "testthat", "fixtures")
dir.create(fixture_dir, showWarnings = FALSE, recursive = TRUE)

rstan::rstan_options(auto_write = TRUE)

cat("Generating Stan sampling fixtures (niter = 200)...\n")

# ---------------------------------------------------------------------------
# phase23 model fixtures — use the same inputs as the unit tests
# ---------------------------------------------------------------------------
common_args <- list(
  target_hr          = 0.7,
  J                  = 2,
  nevents3           = c(370, 468),
  hr_bound           = c(0.779, 0.8204),
  omega_mean         = 0.7,
  omega_var          = 0.03,
  est_obs_pfs        = 0.53,
  low_obs_pfs        = 0.31,
  upp_obs_pfs        = 0.91,
  obs_pfs_conf_level = 0.95,
  thres              = 0.01,
  n_trt2             = 60,
  n_ctrl2            = 63,
  n_resp_trt2        = 33,
  n_resp_ctrl2       = 18,
  het_degree_p2      = "small",
  het_degree_p3      = "very small",
  ratio              = 1,
  m_0                = 0.05,
  m_1                = 0.4,
  nu_0               = 0.05,
  nu_1               = 0.2,
  lm_sd              = 5,
  niter              = 200,
  nchains            = 1,
  ncores             = 1,
  seed               = 123
)

for (cfg in list(
  list(name = "none", use_pfs = FALSE, use_orr = FALSE),
  list(name = "pfs",  use_pfs = TRUE,  use_orr = FALSE),
  list(name = "orr",  use_pfs = FALSE, use_orr = TRUE),
  list(name = "both", use_pfs = TRUE,  use_orr = TRUE)
)) {
  cat("  phase23_interim_", cfg$name, "...\n", sep = "")
  suppressWarnings({
    fit <- do.call(run_stan, c(common_args,
                               list(use_pfs = cfg$use_pfs,
                                    use_orr = cfg$use_orr)))$fit_rstan
  })
  saveRDS(fit, file.path(fixture_dir, paste0("stanfit_", cfg$name, ".rds")))
}

# ---------------------------------------------------------------------------
# estimate_ctrl fixtures — two scenarios for the directional test
# ---------------------------------------------------------------------------
mod <- oncoPoS:::.load_stan_model("estimate_ctrl.stan")

logit_low  <- log(0.05 / 0.95)
logit_upp  <- log(0.30 / 0.70)
mu_ctrl    <- (logit_low + logit_upp) / 2
sigma_ctrl <- (logit_upp - logit_low) / (2 * qnorm(1 - (1 - 0.8) / 2))

for (cfg in list(
  list(name = "estimate_ctrl_high", n_resp_trt = 80L),
  list(name = "estimate_ctrl_low",  n_resp_trt = 40L),
  list(name = "estimate_ctrl_struct", n_resp_trt = 33L)
)) {
  cat("  estimate_ctrl (n_resp_trt =", cfg$n_resp_trt, ")...\n")
  stan_data <- list(
    n_resp_trt       = cfg$n_resp_trt,
    n_trt            = 100L,
    mu_logit_ctrl    = mu_ctrl,
    sigma_logit_ctrl = sigma_ctrl
  )
  suppressWarnings({
    fit <- rstan::sampling(mod, data = stan_data,
                           iter = 200, chains = 1, seed = 123, refresh = 0)
  })
  saveRDS(fit, file.path(fixture_dir, paste0("stanfit_", cfg$name, ".rds")))
}

cat("Done. Fixtures written to:", fixture_dir, "\n")
cat("Platform:", paste(
  Sys.info()[["sysname"]], Sys.info()[["machine"]],
  paste(R.version$major, R.version$minor, sep = "."),
  as.character(utils::packageVersion("rstan")),
  sep = "_"
), "\n")
