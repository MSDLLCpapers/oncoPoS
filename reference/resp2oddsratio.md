# Estimate log odds ratio given response

Estimates log odds ratio for treatment vs control based on number of
responses and samples size in each arm

## Usage

``` r
resp2oddsratio(n_resp_trt, n_resp_ctrl, n_trt, n_ctrl)
```

## Arguments

- n_resp_trt:

  number of responses in treatment arm

- n_resp_ctrl:

  number of responses in control arm

- n_trt:

  sample size in treatment arm

- n_ctrl:

  sample size in control arm

## Value

log odds ratio point estimate and a corresponding standard error

## Specification

The contents of this section are shown in PDF user manual only.

## Examples

``` r
resp2oddsratio(n_resp_trt = 20, n_resp_ctrl = 10, n_trt = 40, n_ctrl = 45)
#> $est
#> [1] -1.252763
#> 
#> $se
#> [1] 0.4780914
#> 
```
