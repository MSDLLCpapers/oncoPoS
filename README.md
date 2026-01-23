# oncoPoS 

## Overview

`oncoPoS` performs Probability of Success (PoS) calculations for a phase 3
oncology study using a Bayesian Hierarchical model. The prior in this model is 
based on the data observed in an earlier study, design features for the phase 3 
study that is being assessed and the industry benchmark for success.
The benchmark PoS is specified via a Beta distribution using its 
**mean and variance**, which can be derived from historical success rates or 
predictive models (e.g., random forest). 
The framework supports both **single-arm and two-arm** early-phase designs and 
allows for **indication-specific ORR–PFS regression** when surrogate endpoints
are used.

## Indication-specific ORR-PFS regression
When early endpoint objective response rate (ORR) is used to predict phase 3 outcome 
progression-free survival (PFS), the relationship varies by cancer type. To account 
for this heterogeneity, `oncoPoS` groups cancer indications into five categories, 
each associated with a distinct set of ORR–PFS regression parameters derived from 
prior Bayesian hierarchical modeling.

**Indication Groups**

- **Group 1: Hematologic malignancies**  
  Includes classical Hodgkin lymphoma (CHL), diffuse large B-cell lymphoma (DLBCL),
  follicular lymphoma (FL), multiple myeloma (MM), non-Hodgkin lymphoma (NHL),
  and peripheral T-cell lymphoma (PTCL).

- **Group 2: Gynecologic cancers**  
  Includes cervical, endometrial, and ovarian cancers.

- **Group 3: Thoracic malignancies**  
  Includes non-small cell lung cancer (NSCLC), small cell lung cancer (SCLC),
  and mesothelioma.

- **Group 4: Urologic and gastrointestinal solid tumors**  
  Includes bladder cancer, gastric cancer, and renal cell carcinoma (RCC).

- **Group 5: Breast cancer**  
  Includes breast cancer.

If no indication is specified by the user, `oncoPoS` defaults to using the
average ORR–PFS relationship across all indication groups.


## Installation

You can install development version of `oncoPoS` from GitHub with:

```r
remotes::install_github("Merck/oncoPoS")
```

## Example

Below is a simple example which assumes the following information is available 
for the an oncology phase 3 trial PoS calculation:

- Disease area:
  - This trial is planned for breast cancer, which falls under Indication Group
    5 in the model’s ORR–PFS regression framework.

- Design features of a phase 3 trial:
  - Progression-free survival (PFS) is the primary endpoint with the target 
  hazard ratio (HR) of 0.7;
  - Two analyses using group sequential approach are planned;
  - The number of target events at each analysis is 370 and 468;
  - The approximate HR bound at each analysis is 0.7790 and 0.8204;
  - The randomization ratio is 2:1.

- The above phase 3 trial is planned following promising results in an earlier
phase 2 study, which reported PFS HR (95% CI) of 0.53 (0.31, 0.91).

- In addition to PFS, objective response rate (ORR) data is available from a 
  single-arm phase 2 trial, with 40 responders out of 100 patients and 
  historical control response rate assumed to lie between 0.05 and 0.20.

- The benchmark probability of success (`omega`) is modeled using a Beta prior 
  with mean 0.3 and variance 0.03, reflecting prior belief about the historical 
  success rate in similar studies.

All the above information is synthesized in `oncoPoS::gen_pos()` using 
Bayesian Hierarchical model to generate a PoS estimate:

```r
gen_pos(
   target_hr = 0.70,
   J = 2,
   nevents3 = c(370, 468),
   hr_bound = c(0.7790, 0.8204),
   thres = 0.01,
   ratio = 2,
   omega_mean = 0.3,
   omega_var = 0.03,
   est_obs_pfs = 0.53,
   low_obs_pfs = 0.31,
   upp_obs_pfs = 0.91,
   use_pfs = TRUE,
   indication = 5,
   n_trt2 = 100,
   n_resp_trt2 = 40,
   low_soc_rr = 0.05,
   upp_soc_rr = 0.2,
   use_orr = TRUE,
   single_arm = TRUE,
   seed = 222
 )

```


