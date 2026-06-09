# Compile all Stan models and cache them for the current platform

Run this function once from the package root directory when setting up a
new computing environment, or after modifying Stan source files.

Each `.stan` model in `stan_src_dir` is compiled with
[`stan_model`](https://mc-stan.org/rstan/reference/stan_model.html) and
saved to `<stan_src_dir>/precompiled/<platform_key>/`. A human-readable
`manifest.dcf` records the build environment for traceability.

**Committing the `precompiled/` tree to version control** lets
collaborators on identical platforms (same OS, CPU arch, R version,
rstan version, and StanHeaders version) skip recompilation entirely –
analogous to how renv stores per-platform package binaries in
`renv/library/<R-version>/<platform>/`.

## Usage

``` r
compile_stan_models(stan_src_dir = file.path("inst", "stan"), verbose = TRUE)
```

## Arguments

- stan_src_dir:

  Character. Path to the `inst/stan/` directory. Defaults to
  `"inst/stan"`, which is correct when running from the package root.

- verbose:

  Logical; if `TRUE` (default), print progress messages.

## Value

Invisibly, the path to the platform-specific precompiled directory.

## Platform key

The subdirectory name is constructed by
[`.stan_platform_key()`](msdllcpapers.github.io/oncoPoS/reference/dot-stan_platform_key.md)
and has the form  
`<sysname>_<machine>_<R-version>_<rstan-version>_<StanHeaders-version>`  
e.g. `Windows_x86-64_4.5.1_2.21.9_2.26.28`.

## Traceability

Each platform directory contains a `manifest.dcf` file with fields:

- sysname:

  Operating system (from
  [`Sys.info()`](https://rdrr.io/r/base/Sys.info.html)).

- machine:

  CPU architecture.

- r_version:

  R major.minor version.

- rstan_version:

  rstan package version.

- stanheaders_version:

  StanHeaders package version.

- compiled_at:

  ISO-8601 timestamp of compilation.

- stan_files:

  Comma-separated list of compiled model filenames.

## Examples

``` r
if (FALSE) { # \dontrun{
# Run once from the package root to cache Stan models for this machine
compile_stan_models()

# Or point at an arbitrary Stan source directory
compile_stan_models(stan_src_dir = "path/to/stan")
} # }
```
