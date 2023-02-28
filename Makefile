# Citation: Pulliam, JRC, C van Schalkwyk, N Govender, A von Gottberg, C 
# Cohen, MJ Groome, J Dushoff, K Mlisana, and H Moultrie. (2022) Increased
# risk of SARS-CoV-2 reinfection associated with emergence of Omicron in
# South Africa. _Science_ <https://www.science.org/doi/10.1126/science.abn4947>
# 
# Repository: <https://github.com/jrcpulliam/reinfection

#If infections is empty, set it to second infections. 
ifeq ($(infections),)
	infections := 2
endif

all: install all_data all_utils run

R = Rscript $^ $@


#Install packages
install: code/install.R
	${R}


#Get infections argument to determine for which infections this is done 
$(eval $(infections):;@:)

data/ts_data_for_analysis.RDS: code/prep_ts_data.R data/ts_data.csv config_general.json $(infections)
	${R} 
	
all_data: data/ts_data_for_analysis.RDS

### UTILITIES

utils/plotting_fxns.RData: code/plotting_fxns.R
	${R}

utils/wave_defs.RDS: code/wave_defs.R data/ts_data_for_analysis.RDS config_general.json
	${R}

utils/fit_functions.RData: code/fit_functions.R
	${R}
	
utils/mcmc_functions.RData: code/mcmc_general.R
	${R}

# Make all utils & save it in the directory utils/
all_utils:  utils/plotting_fxns.RData utils/wave_defs.RDS utils/fit_functions.RData utils/mcmc_functions.RData


# Run MCMC
output/posterior_90_null.RData: code/run_mcmc.R data/ts_data_for_analysis.RDS utils/mcmc_functions.RData utils/fit_functions.RData config_general.json $(infections)
	${R}

# Run Simulations
output/sim_90_null.RDS: code/sim_null.R output/posterior_90_null.RData \
data/ts_data_for_analysis.RDS utils/fit_functions.RData config_general.json $(infections)
	${R}


# Generate plots
output/sim_plot_90_null.png: code/sim_plot.R output/sim_90_null.RDS \
data/ts_data_for_analysis.RDS config_general.json utils/plotting_fxns.RData $(infections)
	${R}

output/convergence_plot.png: code/convergence_plot.R \
output/posterior_90_null.RData utils/fit_functions.RData config_general.json $(infections)
	${R}


#Run cmnds 

run: output/posterior_90_null.RData output/sim_90_null.RDS output/sim_plot_90_null.png output/convergence_plot.png

