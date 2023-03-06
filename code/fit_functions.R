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

utils <- './utils/'
dir.create(utils)

#Dataframe "data" given with columns cases (the reported number of cases that enters the suceptible "pool"),
# date, and observed (the observed number of reinfections coming from the susceptible pool)

#In the data passed to this function, the susceptible pool will come from cases,
# and the expected infections & observed columns represents the number of cases expected
# and the number of cases `reported`
expected <- function(parms = disease_params(), data, delta=cutoff ) with(parms, {
  hz <- lambda * data[date <= omicron_date]$ma_tot
  hz <- c(hz, lambda2 * data[date > omicron_date]$ma_tot)
  
  return ( lapply(1:(nrow(data)-cutoff)
                  , expected_vec
                  , data = data
                  , delta = cutoff
                  , hz = hz)
  )
})


expected_vec <- function(day, data, delta=cutoff, hz)  {
  return(c(rep(0,day-1), data$cases[day] * (1-exp(-cumsum(hz[(day+delta):nrow(data)]))) ))
}


nllikelihood <- function(parms = disease_params(), data) with(parms, {
  tmp <- expected(parms, data)
  tmp <- Reduce("+", tmp)
  tmp <- c(rep(0,90),tmp)
  log_p <- dnbinom(data$observed, size=1/kappa, mu=c(0,diff(tmp)), log=TRUE)
  -sum(log_p)
  return(-sum(log_p))
})


split_path <- function(path) {
  if (dirname(path) %in% c(".", path)) return(basename(path))
  return(c(basename(path), split_path(dirname(path))))
}



save(expected, nllikelihood, expected_vec, split_path, file = target)
