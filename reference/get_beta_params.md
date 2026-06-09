# Generate Beta Distribution Parameters for Omega

Computes the shape parameters of a Beta distribution based on the
specified mean and variance. This is used to parameterize a Beta prior
distribution for the benchmark probability for study success, `omega` in
Bayesian modeling of phase III trial success.

## Usage

``` r
get_beta_params(mean, var)
```

## Arguments

- mean:

  Numeric value between 0 and 1, specifying the prior mean of the Beta
  distribution. This may be estimated from a Benchmark probability model
  such as random forest.

- var:

  Numeric value, specifying the prior variance of the Beta distribution.
  This may reflect uncertainty in the model-based prediction.

## Value

A named list with elements:

- `alpha`:

  First shape parameter of the Beta distribution.

- `beta`:

  Second shape parameter of the Beta distribution.

## Details

The Beta distribution is parameterized by two positive shape parameters,
\\\alpha\\ and \\\beta\\, which can be derived from a given mean \\\mu\\
and variance \\\sigma^2\\ using: \$\$ \alpha = \mu \left( \frac{\mu(1 -
\mu)}{\sigma^2} - 1 \right), \quad \beta = (1 - \mu) \left(
\frac{\mu(1 - \mu)}{\sigma^2} - 1 \right) \$\$ These parameters allow
for a flexible specification of prior distributions, and are
particularly useful when the prior belief is derived from a predictive
model in an earlier step (e.g., machine learning model estimating
historical success probabilities).

## Specification

The contents of this section are shown in the PDF user manual only.

## Examples

``` r
# Example using prior mean and variance estimated from a Benchmark 
# probability model
get_beta_params(mean = 0.52, var = 0.02)
#> $alpha
#> [1] 5.9696
#> 
#> $beta
#> [1] 5.5104
#> 
```
