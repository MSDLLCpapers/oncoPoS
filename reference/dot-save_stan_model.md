# Save a compiled Stan model to the platform-specific cache

Writes the `stanmodel` to the appropriate `precompiled/<platform_key>/`
subdirectory and creates a `manifest.dcf` on the first call. Silently
no-ops if the target directory is not writable.

## Usage

``` r
.save_stan_model(stan_model, stan_file)
```

## Arguments

- stan_model:

  A `stanmodel` object (e.g. `fit@stanmodel`).

- stan_file:

  Filename of the Stan source (e.g. `"phase23_interim_none.stan"`).
