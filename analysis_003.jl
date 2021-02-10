#= 
  Script for plotting the data generated by 6 single galaxy simulations 
  (perform by GADGET3), using the functions of GADGETPlotting.jl.

  The snapshots and related files are located in:
  ../../sim_data/run_00/
  ../../sim_data/run_old_model/
  ../../sim_data/run_A_01/
  ../../sim_data/run_C_01/
  ../../sim_data/run_E_01/
  ../../sim_data/run_F_01/

  The figures, GIFs and videos will be store in ../../results/analysis_003/, in a directory 
  structure named to describe the contents within.
  
  Plots:
  - Accumulated mass profiles of gas and stars, compared between simulations.
  
  NOTE: profile plots have the animation capability disable until issue 
  [3199](https://github.com/JuliaPlots/Plots.jl/issues/3199) is resolved.
 =#

include("../GADGETPlotting/src/GADGETPlotting.jl")

"Base path for the directories where the figures and animations will be saved."
const BASE_OUT_PATH = "../../results/analysis_003/"

"Directory containing the simulations."
const BASE_SRC_PATH = "../../sim_data/"

"Directories containing the snapshot files, base names of the files and labels."
const SNAPSHOTS = [
    "run_00/" "snap" "run_00"
    "run_old_model/" "snap" "run_old_model"
    "run_A_01/" "snap" "run_A_01"
    "run_C_01/" "snap" "run_C_01"
    "run_E_01/" "snap" "run_E_01"
    "run_F_01/" "snap" "run_F_01"
]

"""
Side dimension of the simulated region, with units, 
for the case of vacuum boundary conditions.
"""
const BOX_SIZE = 200UnitfulAstro.kpc

"Value of ComovingIntegrationOn: 0 -> Newtonian simulation, 1 -> Cosmological simulation."
const SIM_COSMO = 0

"Frame rate for the animations."
const FPS = 20

snap_paths = SNAPSHOTS[:, 1]
base_names = SNAPSHOTS[:, 2]
labels = reshape(SNAPSHOTS[:, 3], 1, :)

pgfplotsx()

############################################################################################
# Accumulated mass profile of stars, comparing simulations.
############################################################################################

# All models.
massProfilePipeline(
    base_names,
    BASE_SRC_PATH .* snap_paths,
    "animation",
    FPS,
    "stars",
    labels,
    output_path = BASE_OUT_PATH * "mass_profile/all_models/stars/",
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 80,
    factor = 10,
    box_factor = 0.15,
    box_size = BOX_SIZE,
)

# All but the run_00 model.
massProfilePipeline(
    base_names[2:end],
    BASE_SRC_PATH .* snap_paths[2:end],
    "animation",
    FPS,
    "stars",
    labels[:, 2:end],
    output_path = BASE_OUT_PATH * "mass_profile/new_models/stars/",
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 80,
    factor = 9,
    box_factor = 0.1,
    box_size = BOX_SIZE,
)

############################################################################################
# Accumulated mass profile of the gas, comparing simulations.
############################################################################################

# All models.
massProfilePipeline(
    base_names,
    BASE_SRC_PATH .* snap_paths,
    "animation",
    FPS,
    "gas",
    labels,
    output_path = BASE_OUT_PATH * "mass_profile/all_models/gas/",
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 60,
    factor = 10,
    box_factor = 0.3,
    box_size = BOX_SIZE,
)

# All but the run_00 model.
massProfilePipeline(
    base_names[2:end],
    BASE_SRC_PATH .* snap_paths[2:end],
    "animation",
    FPS,
    "gas",
    labels[:, 2:end],
    output_path = BASE_OUT_PATH * "mass_profile/new_models/gas/",
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 60,
    factor = 10,
    box_factor = 0.15,
    box_size = BOX_SIZE,
)

println("Work done!")