#= 
  Script for plotting the data generated by several single galaxy
  GADGET3 simulations; using the module GADGETPlotting.jl.

  The snapshots and related files are located in:
  ../../sim_data/results/isolated/run_00/
  ../../sim_data/results/isolated/run_old_model/
  ../../sim_data/results/isolated/run_A_01/
  ../../sim_data/results/isolated/run_C_01/
  ../../sim_data/results/isolated/run_E_01/
  ../../sim_data/results/isolated/run_F_01/
  ../../sim_data/results/isolated/run_G_01_tupac/
  ../../sim_data/results/isolated/run_A_02/

  The figures, GIFs, and videos will be store in ../../plots/003/, 
  in directories named to describe the contents within.
  
  Plots:
  - Comparison between simulations of the accumulated mass profile for the stars.
  - Comparison between simulations of the accumulated mass profile for the gas.
  
  NOTE: profile plots have the animation capability disable until the issue 
  [3199](https://github.com/JuliaPlots/Plots.jl/issues/3199) is resolved.
 =#

push!(LOAD_PATH, "../GADGETPlotting/src/")
using GADGETPlotting, Unitful, UnitfulAstro

"Path to the directory where the figures and animations will be saved."
const BASE_OUT_PATH = "../../plots/003"

"Path to the directory containing the simulations."
const BASE_SRC_PATH = "../../sim_data/results/isolated"

"""
The names of the directories containing the snapshot files 
and the base names of the files.
"""
const SNAPSHOTS = [
    "run_00" "snap"
    "run_old_model" "snap"
    "run_A_01" "snap"
    "run_C_01" "snap"
    "run_E_01" "snap"
    "run_F_01" "snap"
    "run_G_01_tupac" "snap"
    "run_A_02" "snap"
]

"""
Side dimension of the simulated region, with units, 
for the case of vacuum boundary conditions.
"""
const BOX_SIZE = 200UnitfulAstro.kpc

"""
Value of ComovingIntegrationOn: 
0 -> Newtonian simulation,
1 -> Cosmological simulation.
"""
const SIM_COSMO = 0

"Frame rate for the animations."
const FPS = 20

snap_paths = SNAPSHOTS[:, 1]
base_names = SNAPSHOTS[:, 2]
labels = reshape(SNAPSHOTS[:, 1], 1, :)

############################################################################################
# Comparison between simulations of the accumulated mass profile for the stars.
############################################################################################

# All models.
mass_profile_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, snap_paths),
    "animation",
    FPS,
    "stars",
    labels,
    output_path = joinpath(BASE_OUT_PATH, "mass_profile_all_models/stars"),
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 80,
    factor = 10,
    box_factor = 0.15,
    box_size = BOX_SIZE,
)

# All but the run_00 model.
mass_profile_pipeline(
    base_names[2:end],
    joinpath.(BASE_SRC_PATH, snap_paths[2:end]),
    "animation",
    FPS,
    "stars",
    labels[:, 2:end],
    output_path = joinpath(BASE_OUT_PATH, "mass_profile_new_models/stars"),
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 80,
    factor = 9,
    box_factor = 0.1,
    box_size = BOX_SIZE,
)

############################################################################################
# Comparison between simulations of the accumulated mass profile for the gas.
############################################################################################

# All models.
mass_profile_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, snap_paths),
    "animation",
    FPS,
    "gas",
    labels,
    output_path = joinpath(BASE_OUT_PATH, "mass_profile_all_models/gas"),
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 60,
    factor = 10,
    box_factor = 0.3,
    box_size = BOX_SIZE,
)

# All but the run_00 model.
mass_profile_pipeline(
    base_names[2:end],
    joinpath.(BASE_SRC_PATH, snap_paths[2:end]),
    "animation",
    FPS,
    "gas",
    labels[:, 2:end],
    output_path = joinpath(BASE_OUT_PATH, "mass_profile_new_models/gas"),
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 60,
    factor = 10,
    box_factor = 0.15,
    box_size = BOX_SIZE,
)

println("Work done!")