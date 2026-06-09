# Locate the precompiled directory for the current platform

Searches `stan/precompiled/<key>` inside the installed or source package
(works for both
[`devtools::load_all()`](https://devtools.r-lib.org/reference/load_all.html)
and installed contexts because
[`system.file()`](https://rdrr.io/r/base/system.file.html) is overridden
by pkgload in both cases).

## Usage

``` r
.stan_precompiled_dir(platform_key)
```

## Arguments

- platform_key:

  Character scalar from
  [`.stan_platform_key()`](msdllcpapers.github.io/oncoPoS/reference/dot-stan_platform_key.md).

## Value

Absolute path to the directory, or `""` if it does not exist.
