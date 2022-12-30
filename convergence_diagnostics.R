## LOAD DATA ## 
library('posterior')


.debug <- ''
.args <- if (interactive()) sprintf(c(
  file.path('utils', 'fxn_convergence_diagnostics.RData'), # input
  file.path('output', 'posterior_90_null_third.RData'), # input
  file.path('config_general.json'),
  file.path('output', 'convergence_diagnostics_results.RData')
), .debug[1]) else commandArgs(trailingOnly = TRUE)

load(.args[1]) #Load the fitting functions
load(.args[2]) #Load the data

configpth <- .args[3]
attach(jsonlite::read_json(configpth))

target <- tail(.args, 1)
## DATA ## 


array_dimension = c(mcmc$n_posterior/mcmc$n_chains, mcmc$n_chains)

if (convergence_method=="all") {
  kappa.data <- extract_variable_matrix(output$chains, variable="kappa")
  lambda.data <- extract_variable_matrix(output$chains, variable = "lambda")
  pscale.data <- extract_variable_matrix(output$chains, variable = "pscale")
}


if (convergence_method=="posterior") {
  smpls <- mcmc$n_posterior / mcmc$n_chains #number of samples to take from each chain

  lambda.data = array(lambda.post, dim=array_dimension)
  kappa.data = array(kappa.post, dim=array_dimension)
  pscale.data = array(pscale.post, dim=array_dimension)
}  

## RUN DIAGNOSTICS ## 

#1. For lambda
rhat_basic.lambda <- rhat_basic(lambda.data, split=FALSE)
rhat_new.lambda <- rhat(lambda.data)
ess_bulk.lambda <- ess_bulk(lambda.data)

lambda.results <- c(rhat_new.lambda, rhat_basic.lambda, ess_bulk.lambda)

#2. For kappa
rhat_basic.kappa <- rhat_basic(kappa.data, split=FALSE)
rhat_new.kappa <- rhat(kappa.data)
ess_bulk.kappa <- ess_bulk(kappa.data)

kappa.results <- c( rhat_new.kappa, rhat_basic.kappa, ess_bulk.kappa)

#3. For PScale
rhat_basic.pscale <- rhat_basic(pscale.data, split = FALSE)
rhat.pscale <- rhat(pscale.data)
ess_bulk.pscale <- ess_bulk((pscale.data))

pscale.results <- c( rhat_new.pscale, rhat_basic.pscale, ess_bulk.pscale)


## FINAL RESULTS DF ##

results.df <- data.frame(Lambda = lambda.results, Kappa = kappa.results, PScale = pscale.results)
rownames(results.df) <- c('RHat New', 'RHat', 'ESS Bulk')


### when posterior is too small , Rhat might be slightly less than 1: https://discourse.mc-stan.org/t/rhat-1-as-low-as-9-94e-01-why/9252

save(results.df, file = target)

stable.GR(kappa.data)
