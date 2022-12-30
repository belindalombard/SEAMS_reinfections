R = Rscript $^ $@

data/ts_data_for_analysis.RDS: code/prep_ts_data.R data/ts_data.csv config_general.json

all_data: data/ts_data_for_analysis.RDS

### UTILITIES


utils/plotting_fxns.RData: code/plotting_fxns.R
	${R}

utils/wave_defs.RDS: code/wave_defs.R data/ts_data_for_analysis.RDS config_general.json
	${R}

utils/fit_functions.RData: code/fit_functions.R
	${R}
	
utils/mcmc_functions.RData: code/mcmc_general.R data/ts_data_for_analysis.RDS utils/fit_functions.RData config_general.json
	${R}
	
all_utils:  utils/plotting_fxns.RData utils/wave_defs.RDS utils/fit_functions.RData utils/mcmc_functions.RData

# Plot
output/ts_plot.RDS output/ts_plot.png: code/ts_plot_third.R data/ts_data_for_analysis.RDS \
utils/wave_defs.RDS utils/plotting_fxns.RData
	${R}

### APPROACH 1
output/posterior_90_null_third.RData: code/run_mcmc.R data/ts_data_for_analysis.RDS utils/mcmc_functions.RData utils/fit_functions.RData config_general.json
	${R}

output/sim_90_null_third.RDS: code/sim_null.R placeholder output/posterior_90_null_third.RData \
data/ts_data_for_analysis.RDS utils/fit_functions.RData config_general.json
	${R}


# Figure 4
output/sim_plot_90_null_third.png: code/sim_plot_third.R output/sim_90_null_third.RDS \
data/ts_data_for_analysis.RDS config_general.json utils/plotting_fxns.RData
	${R}

# Figure S4
output/convergence_plot_third.png: code/convergence_plot.R \
output/posterior_90_null_third.RData placeholder config_general.json
	${R}
	
method_1: output/posterior_90_null_third.RData output/sim_90_null_third.RDS output/sim_plot_90_null_third.png output/convergence_plot_third.png

all: all_data all_utils method_1
