#= 
  Script for plotting the data generated by a GADGET3 simulation; using GADGETPlotting.jl.

  The snapshots and related data files are located in:
  ../../sim_data/results/isolated/M000_32
  ../../sim_data/results/isolated/M000_128
  ../../sim_data/results/isolated/M016_32
  ../../sim_data/results/isolated/run_G_01_64
  ../../sim_data/results/isolated/M016_128

  The resulting figures, GIFs, and videos will be store in ../../plots/009/.
  
  Plots:
  - Comparison of SFR vs. time.
  - Comparison of star mass vs time.
  - Comparison of column 2, 3, 4, 5 y 6 vs column 1 (time):
    - Column 2: mass probability.
    - Column 3: SFR per particle.
    - Column 4: SFR probability
    - Column 5: actual mass.
    - Column 6: actual SFR.
  
  NOTE: profile plots have the animation capability disable until the issue 
  [3199](https://github.com/JuliaPlots/Plots.jl/issues/3199) is resolved.
 =#

push!(LOAD_PATH, "../GADGETPlotting/src/")
using GADGETPlotting, Unitful, UnitfulAstro

"Path to the directory where the figures and animations will be saved."
const BASE_OUT_PATH = "../../plots/009"

"Path to the directory containing the simulations."
const BASE_SRC_PATH = "../../sim_data/results/isolated"

"""
The names of the directories containing the snapshot files 
and the base names of the files.
"""
const SNAPSHOTS = [
    "M000_32" "snap"
    "M000_128" "snap"
    "M016_32" "snap" 
    "run_G_01_64" "snap"
    "M016_128" "snap" 
]

"""
Value of ComovingIntegrationOn: 
0 -> Newtonian simulation,
1 -> Cosmological simulation.
"""
const SIM_COSMO = 0

title = names = [
    "mass_probability_vs_t",
    "SFR_per_particle_vs_t",
    "SFR_probability_vs_t",
    "actual_mass_vs_t",
    "actual_SFR_vs_t",
]

sim_paths = SNAPSHOTS[:, 1]
base_names = SNAPSHOTS[:, 2]
labels = reshape(SNAPSHOTS[:, 1], 1, :)

############################################################################################
# Comparison between simulations of SFR vs time.
############################################################################################

compare_simulations_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, sim_paths),
    labels,
    "all_models",
    "clock_time",
    "sfr",
    output_path = joinpath(BASE_OUT_PATH, "compare_sfr"),
    sim_cosmo = SIM_COSMO,
    scale = (:identity, :log10),
    smooth_data = false,
    text_quantity = "sfr",
    file_name = "sfr",
)

############################################################################################
# Comparison between simulations of star mass vs time.
############################################################################################

compare_simulations_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, sim_paths),
    labels,
    "all_models",
    "clock_time",
    "star_mass",
    output_path = joinpath(BASE_OUT_PATH, "compare_star_mass"),
    sim_cosmo = SIM_COSMO,
    scale = (:identity, :log10),
    smooth_data = false,
    text_quantity = "star_mass",
    file_name = "star_mass",
)

############################################################################################
# Comparison between models of column 2, 3, 4, 5 y 6 vs column 1.
############################################################################################

sfr_txt_pipeline(
    base_names .* "_000",
    joinpath.(BASE_SRC_PATH, sim_paths),
    1,
    [2, 3, 4, 5, 6];
    output_path = joinpath(BASE_OUT_PATH, "sfr_txt"),
    sim_cosmo = SIM_COSMO,
    comparison_type = 1,
    titles,
    names,
    labels,
    bins = 20,
    scale = (:identity, :log10),
    time_unit = UnitfulAstro.Gyr,
)

println("Work done!")
