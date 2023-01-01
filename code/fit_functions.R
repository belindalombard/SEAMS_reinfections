# Citation: Pulliam, JRC, C van Schalkwyk, N Govender, A von Gottberg, C 
# Cohen, MJ Groome, J Dushoff, K Mlisana, and H Moultrie. (2022) Increased
# risk of SARS-CoV-2 reinfection associated with emergence of Omicron in
# South Africa. _Science_ <https://www.science.org/doi/10.1126/science.abn4947>
# 
# Repository: <https://github.com/jrcpulliam/reinfection



.debug <- '.'
.args <- if (interactive()) sprintf(c(
  file.path('utils', 'fit_functions.RData') # output
), .debug[1]) else commandArgs(trailingOnly = TRUE)

target <- tail(.args, 1)

#Dataframe "data" given with columns cases (the reported number of cases that enters the suceptible "pool"),
# date, and observed (the observed number of reinfections coming from the susceptible pool)

#In the data passed to this function, the susceptible pool will come from cases,
# and the expected infections & observed columns represents the number of cases expected
# and the number of cases `reported`

expected <- function(parms = disease_params(), data, delta=cutoff ) with(parms, {
  hz <- lambda * data[date <= omicron_date]$ma_tot
  hz <- c(hz, lambda2 * data[date > omicron_date]$ma_tot)
      
  out <- data.frame(date=data$date, expected_infections = rep(0, nrow(data)))

  for (day in 1:(nrow(data)-delta)){
    tmp <- data$cases[day] * (1-exp(-cumsum(hz[(day+delta):nrow(data)])))
    out$expected_infections[(day+delta):nrow(data)] <- out$expected_infections[(day+delta):nrow(data)]+tmp
  }
  return (out)
})

split_path <- function(path) {
  if (dirname(path) %in% c(".", path)) return(basename(path))
  return(c(basename(path), split_path(dirname(path))))
}

nllikelihood <- function(parms = disease_params(), data) with(parms, {
  tmp <- expected(parms, data)
  log_p <- dnbinom(data$observed, size=1/kappa, mu=c(0,diff(tmp$expected_infections)), log=TRUE)
  -sum(log_p)
  return(-sum(log_p))
})

save(expected, nllikelihood, split_path, file = target)
