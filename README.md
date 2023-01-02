Repository for SEAMS work containing Belinda's MSc work (for 3rd infections simulations)

# Prerequisite: 
Ensure that all packages are installed by running the file code/install.R

# Using the Makefile: 
If you want to run everything (simulations, plots, etc. ), you can run `make all`.

`make ...`
  - `all`: Run everything
  - `run`: Run MCMC, simulations & create plots
  - `all_data`: Prep the data from the data/ts_data.csv file
  - `all_utils`: Create the necessary RData utils files

Arguments for the make file: 
  - (optional) infections=`number of infections`: You can specify whether you want to do the simulations for 2nd, 3rd, etc. infections.
  (currently supports only 2nd and 3rd infections, but can easily be adapted)
  Example: `make all infections=3` will do the simulations for 3rd infections. 
  
  Note: If this optional argument is NOT provided, it will take it as 2. 
  
# Running it Manually
1. Prep the data  
  - ensure that your data is in data/ts_data.csv
  - the data provided is a sample set of data containing 1st, 2nd and 3rd infections.
  
  1a) Run `code/prep_ts_data.R` which will create a file `data/ts_data_for_analysis.RDS`. 
  
2. Create the utils by running the following files
  `wave_defs.R`
  `plotting_fxns.R`
  `mcmc_general.R`
  `fit_functions.R`
  
3. Run the MCMC fitting by running the file `run_mcmc.R`. This will create an output file in output.

4. Run the simulations by running `sim_null.R`. This will create an output file in output. 

5. Create the plots:
  
  5a) `convergence_plot.R`
  5b) `sim_plot.R`
  
