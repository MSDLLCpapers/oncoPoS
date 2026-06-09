# PoS Bayesian Framework for Pivotal Oncology Trials

## Introduction

Here we describe the Bayesian framework that is used to estimate a phase
3 efficacy probability of success (PoS) based on work by Hampson et al.
(2022). The framework consists of study and population level models that
are described in the following sections.

Let $`P`$ be a progression-free survival (PFS), and we assume that the
log hazard ratio (HR) of PFS for a phase III study is $`\theta_{P3}`$.
The subscript 3 denotes the phase of the study (i.e., phase III). In
addition, we assume that data on either the same endpoint $`P`$ or a
different endpoint $`D`$ is observed in an earlier phase I/II or phase
II study which preceded a pivotal trial ($`\theta_{P2}`$ or
$`\theta_{D2}`$ respectively).

## General study level model

The study level model for an observed logHR of PFS in the earlier study
(phase I/II, phase II), $`\hat{\theta}_{P2}`$, is assumed to have the
following form:

``` math
\begin{align}
\hat{\theta}_{P2} \sim Normal(\theta_{P2}, \mathcal{I}^{-1}_{P2}) \label{eq:ph2_est},
\end{align}
```

where $`\theta_{P2}`$ represents a mean treatment effect on $`P`$ in the
earlier study and $`\mathcal{I}_{P2}`$ is the Fisher information for
$`\theta_{P2}`$. Using Bayesian framework, the prior for $`\theta_{P2}`$
is:
``` math
\theta_{P2} \sim Normal (\mu_P, \tau_{P2}^2),
```
where $`\mu_P`$ is a population level parameter for the treatment effect
on $`P`$. $`\tau_{P2}`$ characterizes the degree of heterogeneity in the
treatment effect on $`P`$ across different earlier studies, which is
assumed to follow a half-Normal distribution:
$`\tau_{P2} \sim HN(z^2_2)`$.

Similar to the above, a phase III study level model for treatment effect
on endpoint $`P`$, $`\theta_{P3}`$ has the following distribution:

``` math
\begin{align}
\theta_{P3} \sim Normal (\mu_P, \tau_{P3}^2)\label{eq:p3}
\end{align}
```

The population level parameter $`\mu_P`$ is shared across the phases of
the clinical development. $`\tau_{P3}`$ is assumed to follow a
half-Normal distribution: $`\tau_{P3} \sim HN(z^2_3)`$. The choice of
$`\tau_{P2},\ \tau_{P3}`$ will follow Supplementary Materials E in
Hampson et al. (2022).

## Population level model

The population level treatment effect, $`\mu_P`$, is assumed to come
from a mixture prior with a random mixing weight:

``` math
\begin{align}
\mu_{P} & \sim \omega Normal (\delta_{P}, \sigma_{P1}^2) + (1-\omega) Normal(0, \sigma_{P2}^2),\\
\omega &\sim \text{Beta}(\alpha, \beta),
\end{align}
```

with the following components:

- $`\omega`$ is the probability that $`\mu_P`$ comes from the
  enthusiastic prior component. $`\omega`$ is treated as a random
  variable to incorporate uncertainty and variability in the benchmark
  probability of success (PoS). The Beta prior allows integration of
  historical information (e.g., industry Phase III success rates or
  machine-learning-based predictions) while permitting data-driven
  updating.

- $`Normal(\delta_P, \sigma^2_{P1})`$ is the enthusiastic component,
  i.e., a distribution which is centered at the target treatment effect
  $`\delta_P`$ (i.e., alternative hypothesis). $`\sigma^2_{P1}`$ is set
  as a solution to: $`P(\mu_P \ge 0 | \omega = 1)=\gamma`$, which is
  consistent with the interpretation of the enthusiastic (“alternative”)
  component,
  $`\Leftrightarrow \sigma_{P1} = \frac{\delta_P}{\Phi^{-1}(\gamma)}`$.

- $`Normal(0, \sigma^2_{P2})`$ is the skeptical component, i.e., a
  distribution which is centered at the null hypothesis.
  $`\sigma^2_{P2}`$ is set as a solution to:
  $`P(\mu_P \le \delta_P | \omega = 0)=\gamma`$, which is consistent
  with the interpretation of the skeptical (“null”) component,
  $`\Leftrightarrow \sigma_{P2} = \frac{\delta_P}{\Phi^{-1}(\gamma)}`$.

When $`P`$ denotes the logHR of PFS, $`\gamma`$ is the probability that
the population level treatment effect is equal to or worse than the null
(i.e., logHR is $`\ge 0`$) when the benchmarking data indicate an
optimistic expectation of the treatment effect; or the probability that
the population level treatment effect is equal to or better than the
target effect in phase III (i.e., logHR is $`\le \delta_P`$) when the
benchmarking data indicate we should have pessimistic expectation of the
treatment effect. $`\gamma`$ should be set to a small number so that the
probability of either lack treatment effect under the enthusiastic prior
or substaintial treatment effect under the pessimistic prior is small.

## Phase III efficacy PoS prediction

After fitting the models that are outlined above, we can generate a
phase III efficacy PoS prediction based on the distribution of
$`\theta_{P3}`$.

Let $`J`$ denotes the number of analyses considered in a group
sequential design for a future phase III study. For instance, if
$`J = 2`$, this means that a study has one interim analysis (IA) and one
final analysis (FA). The distribution of the observed log HR for
endpoint $`P`$ at the $`j`$-th analysis,
$`\hat{\theta}_{P3j}, j = 1, ..., J`$ is as follows:

``` math
\begin{align}
\hat{\boldsymbol{\theta}}_{P3} \sim Normal ({\theta}_{P3}\mathbf{1}_{J}, \mathbf{\Sigma}_{J \times J})\label{eq:thetahat_samp},
\end{align}
```

where $`\theta_{P3}`$ is the underlying true log hazard ratio for all
$`J`$ analyses. $`\mathbf{\Sigma}`$ is the covariance matrix that
encodes the Fisher’s information for $`\hat{\theta}_{P3j}`$:

``` math
\begin{align}
\mathbf{\Sigma}_{ij} = \frac{\sigma_{unit}^2}{n_j}, ~~ \text{for all } i \leq j\label{eq:sigma},
\end{align}
```

with $`n_j`$ being the target number of events at the $`j`$-th analysis
and $`\sigma_{unit}^2 = \frac{1}{p_0(1-p_0)}`$ where $`p_0`$ is the
planned proportion of patients in the control group.

The predicted treatment effect $`\hat{\boldsymbol{\theta}}_{P3}^{(l)}`$
is generated $`L`$ times ($`l = 1, \dots, L`$) based on the Bayesian
hierarchical model and the success at the $`j`$-th analysis is
determined by a Frequentest efficacy boundary, $`z_{P3j}`$. Thus, the
probability of stopping a phase III trial for efficacy at the first IA
is estimated as:
``` math
\hat{PoS}_{31} = \frac{1}{L} \sum_{l=1}^L I(\hat{\theta}_{P31}^{(l)} < z_{P31}),
```
and the probability of stopping a phase III trial for efficacy at the
$`j^{th}`$ analysis is estimated as:

``` math
\hat{PoS}_{3j} = \frac{1}{L} \sum_{l=1}^L I(\hat{\theta}_{P3j}^{(l)} < z_{P3j}, \hat{\theta}_{P3i}^{(l)} \geq z_{P3i}, i = 1, \dots, j-1).
```
Finally, the overall PoS is:
$`\hat{PoS}_{3} = \sum_{j=1}^J \hat{PoS}_{3j}`$.

## Study level model when phase III primary endpoint is not available from earlier study(ies)

When an early study didn’t have a reliable PFS estimate, and only ORR is
available from a randomized controlled phase II study, it can be used
for PoS estimation instead. Let $`\theta_{ORR,2}`$ represents a log odds
ratio (OR) of the treatment effect on ORR, the observed treatment
effect, $`\hat{\theta}_{ORR, 2}`$, has the following distribution:
``` math
\begin{align}
\hat{\theta}_{ORR, 2} \sim Normal(\theta_{ORR, 2}, \mathcal{I}_{ORR, 2}^{-1}),
\end{align}
```
where $`\mathcal{I}_{ORR, 2}`$ is the Fisher information associated with
$`\hat{\theta}_{ORR, 2}`$. Further, let $`\theta_{PFS, 2}`$ be the
treatment effect for PFS in Phase II. Motivated by the results in
Blumenthal et al. (2015), we assume the following linear model between
the PFS and ORR treatment effects:
``` math
\begin{align}
  \theta_{ORR,2} \sim N(\beta_0 + \beta_1 \theta_{PFS,2}, \frac{\sigma_{WLS}^2}{N_{patients}}), \label{eq:ph23_pfs_orr_rel}
\end{align}
```
where $`N_{patients}`$ is the number of patients in a given trial and
the regression parameters are assigned the following priors:
``` math
\begin{align*}
\beta_0 \sim {Normal}(m_0, \nu_0) \\
\beta_1 \sim {Normal}(m_1, \nu_1). 
\end{align*}
```
The values of $`m_0, m_1`$, $`\nu_0, \nu_1`$ and $`\sigma_{WLS}^2`$ are
determined from historical data, which is provided in the meta-analysis
in Blumenthal et al. (2015). Specifically, $`(m_0, m_1)`$ are point
estimates for the intercept and slope from a weighted liner simple (WLS)
linear regression model of log(HR PFS) on log(OR ORR), while
$`(\nu_0, \nu_1)`$ are their respective SEs, $`\sigma_{WLS}^2`$ is
estimated based on WLS regression residual variance.

Based on the approximated correlation between $`\theta_{ORR, 2}`$ and
$`\theta_{PFS, 2}`$, a distribution for $`\theta_{PFS, 2}`$ can be
obtained and, therefore, a predicated efficacy PoS can be estimated as
using models that are outlined above.

### Indication-specific surrogate-primary endpoint relationships (e.g., ORR $`\rightarrow`$ PFS)

When early endpoint objective response rate (ORR) is used to predict
phase III progression-free survival (PFS), the strength and direction of
the association may vary substantially across cancer types. To account
for this heterogeneity, we group cancer indications into five
categories, each associated with a distinct set of ORR–PFS regression
parameters derived from prior Bayesian hierarchical modeling.

Trial indexed by: $`j = 1, \dots, J`$. Indication indexed by:
$`k = z_j \in \{1, \dots, K\}`$.

$`\theta^P_j`$: treatment effect on endpoint $`P`$ at trial $`j`$.
$`\sigma^P_j`$: standard error of treatment effect on endpoint $`P`$ at
trial $`j`$.

#### Level 1: Observed trial-level model

Each trial reports an observed log-odds ratio for ORR,
$`\hat\theta^{\text{ORR}}_j`$, and an observed log-hazard ratio for PFS,
$`\hat\theta^{\text{PFS}}_j`$, modeled as:

``` math
\hat\theta^{\text{ORR}}_j \sim \mathcal{N}\!\left(\theta^{\text{ORR}}_j,\ \left(\sigma^{\text{ORR}}_j\right)^2\right)
```

``` math
\hat\theta^{\text{PFS}}_j \sim \mathcal{N}\!\left(\theta^{\text{PFS}}_j,\ \left(\sigma^{\text{PFS}}_j\right)^2\right)
```

Conditional on the (latent) true PFS effect, the true ORR effect follows
an indication-specific regression:

``` math
\theta^{\text{ORR}}_j \;\sim\; \mathcal{N}\!\left(\alpha_{z_j} + \beta_{z_j}\,\theta^{\text{PFS}}_j,\;
\frac{\sigma_{\text{WLS}}^{2}}{N_{\text{patients},j}}\right)
```

#### Level 2: Indication-specific regression parameters

Information is shared across indications via hierarchical modeling. Each
pair $`(\alpha_k, \beta_k)`$ is learned adaptively across indications:

``` math
\alpha_k \sim \mathcal{N}(a_0,\ s_0^2), \qquad
\beta_k \sim \mathcal{N}(b_0,\ s_1^2), \qquad
k = 1, \dots, 5
```

#### Level 3: Population-level hyperpriors

``` math
a_0 \sim \mathcal{N}(0,\ 5^2), \quad
b_0 \sim \mathcal{N}(2,\ 5^2), \quad
s_0 \sim \mathcal{N}(0,\ 5^2), \quad
s_1 \sim \mathcal{N}(0,\ 5^2), \quad
\sigma_{\text{WLS}} \sim \mathcal{N}(0,\ 5^2)
```

#### Indication Groups

**Group 1: Hematologic malignancies**

Includes classical Hodgkin lymphoma (cHL), diffuse large B-cell lymphoma
(DLBCL), follicular lymphoma (FL), multiple myeloma (MM), non-Hodgkin
lymphoma (NHL), and peripheral T-cell lymphoma (PTCL).

**Group 2: Gynecologic cancers**

Includes cervical, endometrial, and ovarian cancers.

**Group 3: Thoracic malignancies**

Includes non-small cell lung cancer (NSCLC), small cell lung cancer
(SCLC), and mesothelioma.

**Group 4: Urologic and gastrointestinal solid tumors**

Includes bladder cancer, gastric cancer, and renal cell carcinoma (RCC).

**Group 5: Breast cancer**

Includes breast cancer.

> If no indication is specified, the average ORR–PFS relationship across
> all indication groups will be used.

### Prior ORR data

The method for computing the observed log-odds ratio
$`\hat\theta^{\text{ORR}}`$ and its standard error differs depending on
whether the earlier study was a two-arm or single-arm trial.

#### Two-arm setting

In the two-arm setting, $`\hat\theta^{\text{ORR}}`$ and its standard
error are estimated directly from the observed response counts in each
arm using frequentist estimation:

``` math
\hat\theta^{\text{ORR}} = \log\!\left(\frac{x_{\text{SOC}}}{n_{\text{SOC}} - x_{\text{SOC}}}\right) - \log\!\left(\frac{x_{\text{trt}}}{n_{\text{trt}} - x_{\text{trt}}}\right)
```

``` math
SE\!\left(\hat\theta^{\text{ORR}}\right) = \sqrt{\frac{1}{x_{\text{trt}}} + \frac{1}{n_{\text{trt}} - x_{\text{trt}}} + \frac{1}{x_{\text{SOC}}} + \frac{1}{n_{\text{SOC}} - x_{\text{SOC}}}}
```

where $`x_{\text{SOC}}`$, $`x_{\text{trt}}`$ are the number of
responders and $`n_{\text{SOC}}`$, $`n_{\text{trt}}`$ are the total
number of patients in the SOC and treatment groups, respectively.

#### Single-arm setting

When only single-arm data are available (i.e., no concurrent control
arm), the observed ORR treatment effect cannot be computed directly from
two-arm counts. Instead, following Weber et al. (2021), uncertainty in
the control ORR is incorporated by placing a distribution over the
Standard of Care (SOC) response rate, $`p_{\text{SOC}}`$, using
user-specified lower and upper bounds.

Let `low_soc_rr` and `upp_soc_rr` denote the lower and upper bounds for
the control ORR. The corresponding logit-scale bounds are:

``` math
\texttt{logit_low} = \log\!\left(\frac{\texttt{low_soc_rr}}{1 - \texttt{low_soc_rr}}\right), \qquad
\texttt{logit_upp} = \log\!\left(\frac{\texttt{upp_soc_rr}}{1 - \texttt{upp_soc_rr}}\right)
```

Rather than fixing $`p_{\text{SOC}}`$ to a point estimate, a normal
distribution is placed on the logit scale:

``` math
\text{logit}(p_{\text{SOC}}) \sim \mathcal{N}\!\left(\mu_{\text{SOC}},\, \sigma_{\text{SOC}}^2\right)
\;\Rightarrow\; p_{\text{SOC}} = \frac{e^x}{1 + e^x}, \quad x \sim \mathcal{N}\!\left(\mu_{\text{SOC}},\, \sigma_{\text{SOC}}^2\right)
```

where the mean and standard deviation are derived from the specified
bounds:

``` math
\mu_{\text{SOC}} = \frac{\texttt{logit_low} + \texttt{logit_upp}}{2}
```

``` math
\sigma_{\text{SOC}} = \frac{\texttt{logit_upp} - \texttt{logit_low}}{2\cdot\Phi^{-1}\!\left(1 - \dfrac{1 - \texttt{ci_rr}}{2}\right)}
```

$`\Phi^{-1}(\cdot)`$ denotes the quantile function of the standard
normal distribution. `ci_rr` is the user-specified confidence level for
the SOC response bounds (default = 80%). Lower values may be used for
more conservative assumptions or when the SOC data are uncertain. In the
single-arm setting, $`x_{\text{SOC}}`$ and $`n_{\text{SOC}}`$ entering
the expressions above are drawn from the distribution over
$`p_{\text{SOC}}`$ rather than observed directly.

Blumenthal, Gideon M, Stella W Karuri, Hui Zhang, et al. 2015. “Overall
Response Rate, Progression-Free Survival, and Overall Survival with
Targeted and Standard Therapies in Advanced Non–Small-Cell Lung Cancer:
US Food and Drug Administration Trial-Level and Patient-Level Analyses.”
*Journal of Clinical Oncology* 33 (9): 1008.

Hampson, Lisa V, Björn Bornkamp, Björn Holzhauer, et al. 2022.
“Improving the Assessment of the Probability of Success in Late Stage
Drug Development.” *Pharmaceutical Statistics* 21 (2): 439–59.

Weber, Sebastian, Yue Li, John W Seaman III, Tomoyuki Kakizume, and
Heinz Schmidli. 2021. “Applying Meta-Analytic-Predictive Priors with the
R Bayesian Evidence Synthesis Tools.” *Journal of Statistical Software*
100 (19): 1–39. <https://doi.org/10.18637/jss.v100.i19>.
