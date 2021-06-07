#= 
  Script for plotting the data generated by GADGET3 simulations, using GADGETPlotting.jl.

  The snapshots and related data files are located in:
    ../../sim_data/results/isolated/run_G_01_tupac/
    ../../sim_data/results/isolated/run_G_01_tirant/

  The resulting figures, GIFs, and videos will be store in ../../plots/006/.

  The objective is to check if the simulation of model 16 (model G) gives the same results 
  for both clusters, Tirant and Tupac.
  
  Plots:
    - Comparison of SFR vs. time.
    - Density profile of stars, for each simulation.
    - Density profile of gas, for each simulation.
    - Metallicity profile of the stars, for each simulation.
    - Metallicity profile of the gas, for each simulation.
  
  NOTE: Some plots have the animation capability disable until the issue 
  [3199](https://github.com/JuliaPlots/Plots.jl/issues/3199) is resolved.
 =#

push!(LOAD_PATH, "../GADGETPlotting/src/")
using GADGETPlotting, Unitful, UnitfulAstro

"Path to the directory where the figures and animations will be saved."
const BASE_OUT_PATH = "../../plots/006"

"Path to the directory containing the simulations."
const BASE_SRC_PATH = "../../sim_data/results/isolated"

"""
Names of the directories containing the snapshot files 
and the base names of the files.
"""
const SNAPSHOTS = [
    "run_G_01_tupac" "snap"
    "run_G_01_tirant" "snap"
]

"""
Side dimension of the simulated region, with units, 
for the case of vacuum boundary conditions.
"""
const BOX_SIZE = 200UnitfulAstro.kpc

"""
Value of ComovingIntegrationOn: 
0 -> Newtonian simulation.
1 -> Cosmological simulation.
"""
const SIM_COSMO = 0

"Frame rate for the animations."
const FPS = 20

snap_paths = SNAPSHOTS[:, 1]
base_names = SNAPSHOTS[:, 2]
labels = reshape(SNAPSHOTS[:, 1], 1, :)

############################################################################################
# Comparison of SFR vs. time
############################################################################################

compare_simulations_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, snap_paths),
    labels,
    "all_sims",
    "clock_time",
    "sfr",
    output_path = joinpath(BASE_OUT_PATH, "compare_sfr"),
    sim_cosmo = SIM_COSMO,
    scale = (:identity, :log10),
    smooth_data = true,
    bins = 60,
)

############################################################################################
# Density profile of stars, for each simulation
############################################################################################

density_profile_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, snap_paths),
    "animation",
    FPS,
    "stars",
    labels,
    output_path = joinpath(BASE_OUT_PATH, "density_profile/stars"),
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 60,
    factor = 4,
    box_factor = 0.2,
    box_size = BOX_SIZE,
)

############################################################################################
# Density profile of gas, for each simulation
############################################################################################

density_profile_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, snap_paths),
    "animation",
    FPS,
    "gas",
    labels,
    output_path = joinpath(BASE_OUT_PATH, "density_profile/gas"),
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 60,
    factor = 4,
    box_factor = 0.75,
    box_size = BOX_SIZE,
)

############################################################################################
# Metallicity profile of the stars, for each simulation
############################################################################################

metallicity_profile_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, snap_paths),
    "animation",
    FPS,
    "stars",
    labels,
    output_path = joinpath(BASE_OUT_PATH, "metallicity_profile/stars"),
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 80,
    box_factor = 1.0,
    box_size = BOX_SIZE,
)

############################################################################################
# Metallicity profile of the gas, for each simulation
############################################################################################

metallicity_profile_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, snap_paths),
    "animation",
    FPS,
    "gas",
    labels,
    output_path = joinpath(BASE_OUT_PATH, "metallicity_profile/gas"),
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 80,
    box_factor = 3.0,
    box_size = BOX_SIZE,
)

println("Work done!")