# PoS Bayesian Framework for Pivotal Oncology Trials

## Introduction

Here we describe the Bayesian framework that is used to estimate a phase
3 efficacy probability of success (PoS) based on work by Hampson et al.
(2022). The framework consists of study and population level models that
are described in the following sections.

Let $P$ be a progression-free survival (PFS), and we assume that the log
hazard ratio (HR) of PFS for a phase III study is $\theta_{P3}$. The
subscript 3 denotes the phase of the study (i.e., phase III). In
addition, we assume that data on either the same endpoint $P$ or a
different endpoint $D$ is observed in an earlier phase I/II or phase II
study which preceded a pivotal trial ($\theta_{P2}$ or $\theta_{D2}$
respectively).

## General study level model

The study level model for an observed logHR of PFS in the earlier study
(phase I/II, phase II), ${\widehat{\theta}}_{P2}$, is assumed to have
the following form:

$$\begin{array}{r}
{{\widehat{\theta}}_{P2} \sim Normal\left( \theta_{P2},\mathcal{I}_{P2}^{- 1} \right),}
\end{array}$$

where $\theta_{P2}$ represents a mean treatment effect on $P$ in the
earlier study and $\mathcal{I}_{P2}$ is the Fisher information for
$\theta_{P2}$. Using Bayesian framework, the prior for $\theta_{P2}$ is:
$$\theta_{P2} \sim Normal\left( \mu_{P},\tau_{P2}^{2} \right),$$ where
$\mu_{P}$ is a population level parameter for the treatment effect on
$P$. $\tau_{P2}$ characterizes the degree of heterogeneity in the
treatment effect on $P$ across different earlier studies, which is
assumed to follow a half-Normal distribution:
$\tau_{P2} \sim HN\left( z_{2}^{2} \right)$.

Similar to the above, a phase III study level model for treatment effect
on endpoint $P$, $\theta_{P3}$ has the following distribution:

$$\begin{array}{r}
{\theta_{P3} \sim Normal\left( \mu_{P},\tau_{P3}^{2} \right)}
\end{array}$$

The population level parameter $\mu_{P}$ is shared across the phases of
the clinical development. $\tau_{P3}$ is assumed to follow a half-Normal
distribution: $\tau_{P3} \sim HN\left( z_{3}^{2} \right)$. The choice of
$\tau_{P2},\ \tau_{P3}$ will follow Supplementary Materials E in Hampson
et al. (2022).

## Population level model

The population level treatment effect, $\mu_{P}$, is assumed to come
from a mixture prior:

$$\begin{array}{r}
{\mu_{P} \sim \omega Normal\left( \delta_{P},\sigma_{P1}^{2} \right) + (1 - \omega)Normal\left( 0,\sigma_{P2}^{2} \right),}
\end{array}$$

with the following components:

- $w$ is a probability that $\mu_{P}$ comes from the enthusiastic prior
  component. The value of $w$ is determined by the industry benchmark.

- $Normal\left( \delta_{P},\sigma_{P1}^{2} \right)$ is the enthusiastic
  component, i.e., a distribution which is centered at the target
  treatment effect $\delta_{P}$ (i.e., alternative hypothesis).
  $\sigma_{P1}^{2}$ is set as a solution to:
  $P\left( \mu_{P} \geq 0|\omega = 1 \right) = \gamma$, which is
  consistent with the interpretation of the enthusiastic (“alternative”)
  component,
  $\left. \Leftrightarrow\sigma_{P1} = \frac{\delta_{P}}{\Phi^{- 1}(\gamma)} \right.$.

- $Normal\left( 0,\sigma_{P2}^{2} \right)$ is the skeptical component,
  i.e., a distribution which is centered at the null hypothesis.
  $\sigma_{P2}^{2}$ is set as a solution to:
  $P\left( \mu_{P} \leq \delta_{P}|\omega = 0 \right) = \gamma$, which
  is consistent with the interpretation of the skeptical (“null”)
  component,
  $\left. \Leftrightarrow\sigma_{P2} = \frac{\delta_{P}}{\Phi^{- 1}(\gamma)} \right.$.

When $P$ denotes the logHR of PFS, $\gamma$ is the probability that the
population level treatment effect is equal to or worse than the null
(i.e., logHR is $\geq 0$) when the benchmarking data indicate an
optimistic expectation of the treatment effect; or the probability that
the population level treatment effect is equal to or better than the
target effect in phase III (i.e., logHR is $\leq \delta_{P}$) when the
benchmarking data indicate we should have pessimistic expectation of the
treatment effect. $\gamma$ should be set to a small number so that the
probability of either lack treatment effect under the enthusiastic prior
or substaintial treatment effect under the pessimistic prior is small.

## Phase III efficacy PoS prediction

After fitting the models that are outlined above, we can generate a
phase III efficacy PoS prediction based on the distribution of
$\theta_{P3}$.

Let $J$ denotes the number of analyses considered in a group sequential
design for a future phase III study. For instance, if $J = 2$, this
means that a study has one interim analysis (IA) and one final analysis
(FA). The distribution of the observed log HR for endpoint $P$ at the
$j$-th analysis, ${\widehat{\theta}}_{P3j},j = 1,...,J$ is as follows:

$$\begin{array}{r}
{{\widehat{\mathbf{θ}}}_{P3} \sim Normal\left( \theta_{P3}\mathbf{1}_{J},\mathbf{\Sigma}_{J \times J} \right),}
\end{array}$$

where $\theta_{P3}$ is the underlying true log hazard ratio for all $J$
analyses. $\mathbf{\Sigma}$ is the covariance matrix that encodes the
Fisher’s information for ${\widehat{\theta}}_{P3j}$:

$$\begin{array}{r}
{\mathbf{\Sigma}_{ij} = \frac{\sigma_{unit}^{2}}{n_{j}},\ \ {\text{for all}\mspace{6mu}}i \leq j,}
\end{array}$$

with $n_{j}$ being the target number of events at the $j$-th analysis
and $\sigma_{unit}^{2} = \frac{1}{p_{0}\left( 1 - p_{0} \right)}$ where
$p_{0}$ is the planned proportion of patients in the control group.

The predicted treatment effect ${\widehat{\mathbf{θ}}}_{P3}^{(l)}$ is
generated $L$ times ($l = 1,\ldots,L$) based on the Bayesian
hierarchical model and the success at the $j$-th analysis is determined
by a Frequentest efficacy boundary, $z_{P3j}$. Thus, the probability of
stopping a phase III trial for efficacy at the first IA is estimated as:
$${\widehat{PoS}}_{31} = \frac{1}{L}\sum\limits_{l = 1}^{L}I\left( {\widehat{\theta}}_{P31}^{(l)} < z_{P31} \right),$$
and the probability of stopping a phase III trial for efficacy at the
$j^{th}$ analysis is estimated as:

$${\widehat{PoS}}_{3j} = \frac{1}{L}\sum\limits_{l = 1}^{L}I\left( {\widehat{\theta}}_{P3j}^{(l)} < z_{P3j},{\widehat{\theta}}_{P3i}^{(l)} \geq z_{P3i},i = 1,\ldots,j - 1 \right).$$
Finally, the overall PoS is:
${\widehat{PoS}}_{3} = \sum_{j = 1}^{J}{\widehat{PoS}}_{3j}$.

## Study level model when phase III primary endpoint is not available from earlier study(ies)

When an early study didn’t have a reliable PFS estimate, and only ORR is
available from a randomized controlled phase II study, it can be used
for PoS estimation instead. Let $\theta_{ORR,2}$ represents a log odds
ratio (OR) of the treatment effect on ORR, the observed treatment
effect, ${\widehat{\theta}}_{ORR,2}$, has the following distribution:
$$\begin{array}{r}
{{\widehat{\theta}}_{ORR,2} \sim Normal\left( \theta_{ORR,2},\mathcal{I}_{ORR,2}^{- 1} \right),}
\end{array}$$ where $\mathcal{I}_{ORR,2}$ is the Fisher information
associated with ${\widehat{\theta}}_{ORR,2}$. Further, let
$\theta_{PFS,2}$ be the treatment effect for PFS in Phase II. Motivated
by the results in Blumenthal et al. (2015), we assume the following
linear model between the PFS and ORR treatment effects:
$$\begin{array}{r}
{\theta_{ORR,2} \sim N\left( \beta_{0} + \beta_{1}\theta_{PFS,2},\frac{\sigma_{WLS}^{2}}{N_{patients}} \right),}
\end{array}$$ where $N_{patients}$ is the number of patients in a given
trial and the regression parameters are assigned the following priors:
$$\begin{array}{r}
{\beta_{0} \sim {Normal}\left( m_{0},\nu_{0} \right)} \\
{\beta_{1} \sim {Normal}\left( m_{1},\nu_{1} \right).}
\end{array}$$ The values of $m_{0},m_{1}$, $\nu_{0},\nu_{1}$ and
$\sigma_{WLS}^{2}$ are determined from historical data, which is
provided in the meta-analysis in Blumenthal et al. (2015). Specifically,
$\left( m_{0},m_{1} \right)$ are point estimates for the intercept and
slope from a weighted liner simple (WLS) linear regression model of
log(HR PFS) on log(OR ORR), while $\left( \nu_{0},\nu_{1} \right)$ are
their respective SEs, $\sigma_{WLS}^{2}$ is estimated based on WLS
regression residual variance.

Based on the approximated correlation between $\theta_{ORR,2}$ and
$\theta_{PFS,2}$, a distribution for $\theta_{PFS,2}$ can be obtained
and, therefore, a predicated efficacy PoS can be estimated as using
models that are outlined above.

Blumenthal, Gideon M, Stella W Karuri, Hui Zhang, Lijun Zhang, Sean
Khozin, Dickran Kazandjian, Shenghui Tang, Rajeshwari Sridhara, Patricia
Keegan, and Richard Pazdur. 2015. “Overall Response Rate,
Progression-Free Survival, and Overall Survival with Targeted and
Standard Therapies in Advanced Non–Small-Cell Lung Cancer: US Food and
Drug Administration Trial-Level and Patient-Level Analyses.” *Journal of
Clinical Oncology* 33 (9): 1008.

Hampson, Lisa V, Björn Bornkamp, Björn Holzhauer, Joseph Kahn, Markus R
Lange, Wen-Lin Luo, Giovanni Della Cioppa, Kelvin Stott, and Steffen
Ballerstedt. 2022. “Improving the Assessment of the Probability of
Success in Late Stage Drug Development.” *Pharmaceutical Statistics* 21
(2): 439–59.
