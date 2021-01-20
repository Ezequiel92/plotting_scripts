# Plotting scripts

Scripts to produce analysis in the form of figures for certain GADGET3 simulations. 

- All make use of [GADGETPlotting.jl](https://github.com/Ezequiel92/GADGETPlotting).
- The figures, GIF and videos generated will be saved saved in ..\results\analysis_XXX\ (he folder will be created if it doesn't exist) where XXX is the number of the script. 
- The snapshots are expected to be located in ../../sim_data/run_00/, ../../sim_data/run_A_01/, etc. So, the expected file structure is:


    .
    ├── sim_data
    │    ├── run_00/
    │    ├── run_A_01/
    │    └── ...
    └── code
         ├── GADGETPlotting 
         │    ├──GADGETPlotting.jl
         │    └── ...
         ├── plotting_scripts
         │    ├── analysis_001.jl
         │    ├── analysis_002.jl
         │    └── ...
         └── results 
              ├── analysis_001
              │    └── ...
              ├── analysis_002
              │    └── ...
              │    └── ...
              └── ...

## Documentation

A comment at the beginning of each script explains its objective.

## Warning

These scripts are written for data generated by GADGET3, which is not a publicly available code, and require snapshot files which are to heavy for a GITHUB repository. The intension of the repo is to be a backup for the scripts, and to facilitate reproducibility.
