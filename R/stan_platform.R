#' @importFrom rstan sampling stan_model
NULL

# ---------------------------------------------------------------------------
# Internal helpers for platform-aware Stan model caching
#
# Two-tier cache lookup (checked in order):
#
#  1. Package bundle  -- inst/stan/precompiled/<platform_key>/
#     Committed to version control.  Covers platforms that the maintainer has
#     pre-compiled for.  Read-only after installation.
#
#  2. User cache      -- tools::R_user_dir("oncoPoS", "cache")/<platform_key>/
#     Always writable (Linux system installs, read-only HPC mounts, etc.).
#     Populated automatically on first use for any platform not in the bundle.
#     Survives package upgrades until the platform key changes.
#
# The platform key encodes OS, CPU architecture, R version, rstan version, and
# StanHeaders version -- the full set of factors that determine compiled model
# compatibility.
# ---------------------------------------------------------------------------

#' Build a platform-specific cache key for Stan models
#'
#' Combines OS name, CPU architecture, R version, rstan version, and
#' StanHeaders version into a single string.  Two sessions that produce the
#' same key can share compiled \code{.rds} files without recompilation.
#'
#' @return A character scalar, e.g.
#'   \code{"Windows_x86-64_4.5.1_2.21.9_2.26.28"}.
#' @keywords internal
.stan_platform_key <- function() {
  info <- Sys.info()
  paste(
    info[["sysname"]],
    info[["machine"]],
    paste(R.version$major, R.version$minor, sep = "."),
    as.character(utils::packageVersion("rstan")),
    as.character(utils::packageVersion("StanHeaders")),
    sep = "_"
  )
}

#' Locate the bundled precompiled directory for the current platform
#'
#' Searches \code{inst/stan/precompiled/<key>} inside the installed package.
#'
#' @param platform_key Character scalar from \code{.stan_platform_key()}.
#' @return Absolute path to the directory, or \code{""} if it does not exist.
#' @keywords internal
.stan_precompiled_dir <- function(platform_key) {
  system.file("stan", "precompiled", platform_key, package = "oncoPoS")
}

#' Locate the user-writable cache directory for the current platform
#'
#' Uses \code{tools::R_user_dir("oncoPoS", "cache")} so it is always writable
#' regardless of where the package is installed (system library, HPC, etc.).
#'
#' @param platform_key Character scalar from \code{.stan_platform_key()}.
#' @return Absolute path to the directory (created if necessary).
#' @keywords internal
.stan_user_cache_dir <- function(platform_key) {
  base <- tools::R_user_dir("oncoPoS", "cache")
  file.path(base, platform_key)
}

#' Load a pre-compiled Stan model for the current platform
#'
#' Checks the bundled \code{inst/stan/precompiled/} directory first, then
#' falls back to the user-writable cache (\code{tools::R_user_dir()}).
#'
#' @param stan_file Filename of the Stan model (e.g.
#'   \code{"phase23_interim_none.stan"}).
#' @return A \code{stanmodel} object if a matching pre-compiled \code{.rds}
#'   exists in either cache tier, otherwise \code{NULL}.
#' @keywords internal
.load_stan_model <- function(stan_file) {
  key      <- .stan_platform_key()
  rds_name <- sub("\\.stan$", ".rds", stan_file)

  # Tier 1: bundled precompiled (committed to version control)
  bundle_dir <- .stan_precompiled_dir(key)
  if (nzchar(bundle_dir)) {
    rds_path <- file.path(bundle_dir, rds_name)
    if (file.exists(rds_path)) {
      mod <- tryCatch(readRDS(rds_path), error = function(e) NULL)
      if (!is.null(mod)) return(mod)
    }
  }

  # Tier 2: user cache (always writable)
  cache_dir <- .stan_user_cache_dir(key)
  rds_path  <- file.path(cache_dir, rds_name)
  if (file.exists(rds_path)) {
    tryCatch(readRDS(rds_path), error = function(e) NULL)
  } else {
    NULL
  }
}

#' Save a compiled Stan model to the user-writable cache
#'
#' Writes the \code{stanmodel} to \code{tools::R_user_dir("oncoPoS", "cache")}
#' so it persists across sessions on any platform, including read-only system
#' library installations.  Creates a \code{manifest.dcf} on the first call.
#' Silently no-ops if the cache directory cannot be created or written.
#'
#' @param stan_model A \code{stanmodel} object (e.g. \code{fit@@stanmodel}).
#' @param stan_file  Filename of the Stan source (e.g.
#'   \code{"phase23_interim_none.stan"}).
#' @keywords internal
.save_stan_model <- function(stan_model, stan_file) {
  key     <- .stan_platform_key()
  out_dir <- .stan_user_cache_dir(key)
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

  rds_path <- file.path(out_dir, sub("\\.stan$", ".rds", stan_file))
  tryCatch(
    saveRDS(stan_model, rds_path),
    error = function(e) invisible(NULL)
  )

  # Write manifest once per platform directory
  manifest_path <- file.path(out_dir, "manifest.dcf")
  if (!file.exists(manifest_path)) {
    tryCatch({
      info <- Sys.info()
      write.dcf(
        data.frame(
          sysname             = info[["sysname"]],
          machine             = info[["machine"]],
          r_version           = paste(R.version$major, R.version$minor, sep = "."),
          rstan_version       = as.character(utils::packageVersion("rstan")),
          stanheaders_version = as.character(utils::packageVersion("StanHeaders")),
          compiled_at         = format(Sys.time(), "%Y-%m-%dT%H:%M:%S"),
          stringsAsFactors    = FALSE
        ),
        manifest_path
      )
    }, error = function(e) invisible(NULL))
  }

  invisible(out_dir)
}

# ---------------------------------------------------------------------------
# Exported developer utility
# ---------------------------------------------------------------------------

#' @title Compile all Stan models and cache them for the current platform
#'
#' @description
#' Run this function once from the package root directory when setting up a
#' new computing environment, or after modifying Stan source files.
#'
#' Each \code{.stan} model in \code{stan_src_dir} is compiled with
#' \code{\link[rstan]{stan_model}} and saved to
#' \code{<stan_src_dir>/precompiled/<platform_key>/}.  A human-readable
#' \code{manifest.dcf} records the build environment for traceability.
#'
#' \strong{Committing the \code{precompiled/} tree to version control} lets
#' collaborators on identical platforms (same OS, CPU arch, R version, rstan
#' version, and StanHeaders version) skip recompilation entirely -- analogous to
#' how \pkg{renv} stores per-platform package binaries in
#' \code{renv/library/<R-version>/<platform>/}.
#'
#' @section Platform key:
#' The subdirectory name is constructed by \code{.stan_platform_key()} and
#' has the form \cr
#' \code{<sysname>_<machine>_<R-version>_<rstan-version>_<StanHeaders-version>}
#' \cr e.g. \code{Windows_x86-64_4.5.1_2.21.9_2.26.28}.
#'
#' @section Traceability:
#' Each platform directory contains a \code{manifest.dcf} file with fields:
#' \describe{
#'   \item{sysname}{Operating system (from \code{Sys.info()}).}
#'   \item{machine}{CPU architecture.}
#'   \item{r_version}{R major.minor version.}
#'   \item{rstan_version}{rstan package version.}
#'   \item{stanheaders_version}{StanHeaders package version.}
#'   \item{compiled_at}{ISO-8601 timestamp of compilation.}
#'   \item{stan_files}{Comma-separated list of compiled model filenames.}
#' }
#'
#' @param stan_src_dir Character. Path to the \code{inst/stan/} directory.
#'   Defaults to \code{"inst/stan"}, which is correct when running from the
#'   package root.
#' @param verbose Logical; if \code{TRUE} (default), print progress messages.
#'
#' @return Invisibly, the path to the platform-specific precompiled directory.
#'
#' @examples
#' \dontrun{
#' # Run once from the package root to cache Stan models for this machine
#' compile_stan_models()
#'
#' # Or point at an arbitrary Stan source directory
#' compile_stan_models(stan_src_dir = "path/to/stan")
#' }
#'
#' @export
compile_stan_models <- function(stan_src_dir = file.path("inst", "stan"),
                                verbose = TRUE) {
  key     <- .stan_platform_key()
  out_dir <- file.path(stan_src_dir, "precompiled", key)
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

  stan_files <- list.files(stan_src_dir, pattern = "\\.stan$", full.names = TRUE)
  if (length(stan_files) == 0L) {
    stop("No .stan files found in: ", stan_src_dir)
  }

  if (verbose) message("Platform key: ", key)

  for (stan_path in stan_files) {
    stan_name <- basename(stan_path)
    if (verbose) message("Compiling ", stan_name, " ...")
    mod      <- rstan::stan_model(file = stan_path, verbose = FALSE)
    rds_name <- sub("\\.stan$", ".rds", stan_name)
    saveRDS(mod, file.path(out_dir, rds_name))
    if (verbose) message("  -> saved ", rds_name)
  }

  info <- Sys.info()
  write.dcf(
    data.frame(
      sysname             = info[["sysname"]],
      machine             = info[["machine"]],
      r_version           = paste(R.version$major, R.version$minor, sep = "."),
      rstan_version       = as.character(utils::packageVersion("rstan")),
      stanheaders_version = as.character(utils::packageVersion("StanHeaders")),
      compiled_at         = format(Sys.time(), "%Y-%m-%dT%H:%M:%S"),
      stan_files          = paste(basename(stan_files), collapse = ", "),
      stringsAsFactors    = FALSE
    ),
    file.path(out_dir, "manifest.dcf")
  )

  if (verbose) {
    message("All models compiled.")
    message("Manifest written to: ", file.path(out_dir, "manifest.dcf"))
  }

  invisible(out_dir)
}
