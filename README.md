<div align="center">
    <h1>📈 Plotting scripts</h1>
</div>

<p align="center">
    <a href="https://GitHub.com/Ezequiel92/"><img src="http://forthebadge.com/images/badges/built-with-science.svg"></a>
    <a href="https://julialang.org"><img src="https://forthebadge.com/images/badges/made-with-julia.svg"></a>
</p>

<p align="center">
    <a href="https://github.com/Ezequiel92/plotting_scripts/blob/main/LICENSE"><img src="https://img.shields.io/github/license/Ezequiel92/plotting_scripts?style=flat&logo=GNU&labelColor=2B2D2F"></a>
    <a href="mailto:elozano@df.uba.ar"><img src="https://img.shields.io/maintenance/yes/2021?style=flat&labelColor=2B2D2F"></a>
</p>

Script for plotting the data generated by GADGET3 simulations, using [GADGETPlotting.jl](https://github.com/Ezequiel92/GADGETPlotting). 

## 📁 Directory structure

All paths here and within the scripts are relative to the project directory (the directory containing the `.toml` files).

The figures, GIFs, and videos generated will be saved in `../plots/XXX/` (the folder will be created if it doesn't exist) where XXX is the number of the script. The snapshots are expected to be located in `../../sim_data/isolated/run_00/`, `../../sim_data/cosmological/run_A_01/`, etc. So, the expected file structure is:

    .
    ├── sim_data
    │    ├── isolated
    │    │    ├── run_00
    │    │    ├── run_A_01
    │    │    └── ...
    │    ├── cosmological
    │    │    ├── run_00
    │    │    ├── run_A_01
    │    │    └── ...
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
              ├── src 
              │    ├── plots_001.jl
              │    ├── plots_002.jl
              │    └── ...
              └── ...
         

## 📘 Documentation

A comment at the beginning of each script explains which figures will be generated.

## ⚠️ Warning

- These scripts are written for data from GADGET3, which is not a publicly available code.
- As data source, they use snapshot files that are too heavy for GitHub, so they are not in this repository.
- These scripts are written for personal use and may break at any moment. So, use them at your own risk.
