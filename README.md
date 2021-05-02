# 📈 Plotting scripts

[![ForTheBadge built-with-science](http://ForTheBadge.com/images/badges/built-with-science.svg)](https://GitHub.com/Ezequiel92/) 

[![ForTheBadge made-with-julia](https://forthebadge.com/images/badges/made-with-julia.svg)](https://julialang.org)

[![GitHub](https://img.shields.io/github/license/Ezequiel92/plotting_scripts?style=flat-square)](https://github.com/Ezequiel92/plotting_scripts/blob/main/LICENSE) [![Maintenance](https://img.shields.io/maintenance/yes/2021?style=flat-square)](mailto:lozano.ez@gmail.com)

Scripts for plotting the data of GADGET3 simulations. 

All make use of the module [GADGETPlotting.jl](https://github.com/Ezequiel92/GADGETPlotting). 

## 📁 Directory structure

The figures, GIFs, and videos generated will be saved in `../plots/XXX/` (the folder will be created if it doesn't exist) where XXX is the number of the script. The snapshots are expected to be located in `../../sim_data/isolated/run_00/`, `../../sim_data/cosmological/run_A_01/`, etc. So, the expected file structure is:

    .
    ├── sim_data
    │    ├── isolated
	│    │    ├── run_00
	│    │    ├── run_A_01
	│    │	  └── ...
	│    ├── cosmological
	│    │    ├── run_00
	│    │    ├── run_A_01
	│    │	  └── ...
    │    └── ...
    ├── plots 
    │    ├── 001
    │    │    ├── ...
    │    │    └── ...
    │    ├── 002
    │    │    ├── ...
    │    │    └── ...
    │    └── ...
    └── code
         ├── GADGETPlotting 
         │    ├── src 
         │    │    ├── GADGETPlotting.jl   
         │    │    └── ...  
         │    └── ...
         └── plotting_scripts
              ├── plots_001.jl
              ├── plots_002.jl
              └── ...
         

## 📜 Documentation

A comment at the beginning of each script explains which figures are produced.

## 📣 Contact

[![image](https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:lozano.ez@gmail.com)

[![image](https://img.shields.io/badge/Microsoft_Outlook-0078D4?style=for-the-badge&logo=microsoft-outlook&logoColor=white)](mailto:lozano.ez@outlook.com)

## ⚠️ Warning

- These scripts are written for data generated by GADGET3 (which is not a publicly available code) and require snapshot files that are too heavy for a GitHub repository.
- These scripts are written for personal use and may break at any moment. So, no guarantees are given.
