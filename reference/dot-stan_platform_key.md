# Build a platform-specific cache key for Stan models

Combines OS name, CPU architecture, R version, rstan version, and
StanHeaders version into a single string. Two sessions that produce the
same key can share compiled `.rds` files without recompilation.

## Usage

``` r
.stan_platform_key()
```

## Value

A character scalar, e.g. `"Windows_x86-64_4.5.1_2.21.9_2.26.28"`.
