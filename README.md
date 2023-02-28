# SEAMS Reinfections Project

## Overview


## Input
The input for this project is a CSV file containing the number of reported infections of SARS-CoV-2

### Structure of input
The CSV file, called ts_data.csv should be placed in a data directory in the repository before running the code. 
The CSV file should have at minimum the columns: date, cnt (primary observed infections), and reinf (observed reinfections). If you want to run it for third infections, you're CSV file should also contain a column 'third' with observed third infections. 

**Note: If you don't have a data file and you want to use this project for other purposes, the Makefile will create randomised simulated data for you which can be used** 

## Output
The output of the project is some png files and RDS files which is stored in an **output** directory. The file that is used for simulations in the end is a file named sim_plot. 


## Running the code

### Using the Makefile: 
If you want to run everything (simulations, plots, etc. ), you can run `make all`.

`make ...`
  - `all`: Run everything
  - `run`: Run MCMC, simulations & create plots
  - `all_data`: Prep the data from the data/ts_data.csv file
  - `all_utils`: Create the necessary RData utils files
  - `generate_data`: Generate simulate data 

Arguments for the make file: 
  - (optional) infections=`number of infections`: You can specify whether you want to do the simulations for 2nd, 3rd, etc. infections.
  (currently supports only 2nd and 3rd infections, but can easily be adapted)
  Example: `make all infections=3` will do the simulations for 3rd infections. 
  
  Note: If this optional argument is NOT provided, it will take it as 2. 
  
### Running it Manually
1. Install the packages
2. Prep the data  
  - **Optional: run generate_data.R if you want to have simulated data instead of data**
  - ensure that your data is in data/ts_data.csv
  - the data provided is a sample set of data containing 1st, 2nd and 3rd infections.
3. Run `code/prep_ts_data.R` which will create a file `data/ts_data_for_analysis.RDS`. 
4. Create the utils by running the following files
  `wave_defs.R`
  `plotting_fxns.R`
  `mcmc_general.R`
  `fit_functions.R`
5. Run the MCMC fitting by running the file `run_mcmc.R`. This will create an output file in output.
6. Run the simulations by running `sim_null.R`. This will create an output file in output. 
7. Create the plots with the following files:  
	- `convergence_plot.R`
	- `sim_plot.R`
  
