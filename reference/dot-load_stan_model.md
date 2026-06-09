# Load a pre-compiled Stan model for the current platform

Load a pre-compiled Stan model for the current platform

## Usage

``` r
.load_stan_model(stan_file)
```

## Arguments

- stan_file:

  Filename of the Stan model (e.g. `"phase23_interim_none.stan"`).

## Value

A `stanmodel` object if a matching pre-compiled `.rds` exists, otherwise
`NULL`.
