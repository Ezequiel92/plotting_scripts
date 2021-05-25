#= 
  Script for plotting the data generated by several single galaxy
  GADGET3 simulations; using the module GADGETPlotting.jl.

  The snapshots and related data files are located in:
  ../../sim_data/results/isolated/run_00/
  ../../sim_data/results/isolated/run_old_model/
  ../../sim_data/results/isolated/run_A_01/
  ../../sim_data/results/isolated/run_C_01/
  ../../sim_data/results/isolated/run_E_01/
  ../../sim_data/results/isolated/run_F_01/
  ../../sim_data/results/isolated/run_G_01_tupac/
  ../../sim_data/results/isolated/run_A_02/

  The figures, GIFs, and videos will be store in ../../plots/001/, 
  in directories named to describe the contents within.
  
  Plots:
  - Star density field projected into the XY plane, for each simulation.
  - Comparison between simulations of SFR vs time.
  - Comparison between simulations of the density profile of stars.
  - Comparison between simulations of the density profile of gas.
  - Comparison between simulations of the metallicity profile of the stars.
  - Comparison between simulations of the metallicity profile of the gas.
  
  NOTE: profile plots have the animation capability disable until the issue 
  [3199](https://github.com/JuliaPlots/Plots.jl/issues/3199) is resolved.
 =#

push!(LOAD_PATH, "../GADGETPlotting/src/")
using GADGETPlotting, Unitful, UnitfulAstro

"Path to the directory where the figures and animations will be saved."
const BASE_OUT_PATH = "../../plots/001"

"Path to the directory containing the simulations."
const BASE_SRC_PATH = "../../sim_data/results/isolated"

"""
The names of the directories containing the snapshot files, 
the base names of the files and the box factors.
"""
const SNAPSHOTS = [
    "run_00" "snap" 0.35
    "run_old_model" "snap" 0.2
    "run_A_01" "snap" 0.2
    "run_C_01" "snap" 0.2
    "run_E_01" "snap" 0.2
    "run_F_01" "snap" 0.2
    "run_G_01_tupac" "snap" 0.2
    "run_A_02" "snap" 0.2
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

snap_paths = String.(SNAPSHOTS[:, 1])
base_names = String.(SNAPSHOTS[:, 2])
box_factor = Float64.(SNAPSHOTS[:, 3])
labels = String.(reshape(SNAPSHOTS[:, 1], 1, :))

############################################################################################
# Star density field projected into the XY plane, for each simulation.
############################################################################################

for (i, run) in enumerate(snap_paths)
    star_map_pipeline(
        base_names[i],
        joinpath(BASE_SRC_PATH, run),
        "density_animation",
        FPS,
        output_path = joinpath(BASE_OUT_PATH, "star_density_field", run),
        sim_cosmo = SIM_COSMO,
        plane = "XY",
        box_size = BOX_SIZE,
        box_factor = box_factor[i],
    )
end

############################################################################################
# Comparison between simulations of SFR vs time.
############################################################################################

# All models.
compare_simulations_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, snap_paths),
    labels,
    "all_models",
    "clock_time",
    "sfr",
    output_path = joinpath(BASE_OUT_PATH, "compare_sfr"),
    sim_cosmo = SIM_COSMO,
    scale = (:identity, :log10),
    smooth_data = true,
    bins = 60,
)

# All but the run_00 and run_F_01 models.
compare_simulations_pipeline(
    base_names[[2, 3, 4, 5, 7, 8]],
    joinpath.(BASE_SRC_PATH, snap_paths[[2, 3, 4, 5, 7, 8]]),
    labels[:, [2, 3, 4, 5, 7, 8]],
    "new_models",
    "clock_time",
    "sfr",
    output_path = joinpath(BASE_OUT_PATH, "compare_sfr"),
    sim_cosmo = SIM_COSMO,
    scale = (:identity, :log10),
    smooth_data = true,
    bins = 60,
)

# Compare the run_A.
compare_simulations_pipeline(
    base_names[[3, 8]],
    joinpath.(BASE_SRC_PATH, snap_paths[[3, 8]]),
    labels[:, [3, 8]],
    "A_models",
    "clock_time",
    "sfr",
    output_path = joinpath(BASE_OUT_PATH, "compare_sfr"),
    sim_cosmo = SIM_COSMO,
    scale = (:identity, :log10),
    smooth_data = true,
    bins = 60,
)

############################################################################################
# Comparison between simulations of the density profile of stars.
############################################################################################

# All models.
density_profile_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, snap_paths),
    "animation",
    FPS,
    "stars",
    labels,
    output_path = joinpath(BASE_OUT_PATH, "density_profile/all_models/stars"),
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 60,
    factor = 4,
    box_factor = 0.2,
    box_size = BOX_SIZE,
)

# All but the run_00 model.
density_profile_pipeline(
    base_names[2:end],
    joinpath.(BASE_SRC_PATH, snap_paths[2:end]),
    "animation",
    FPS,
    "stars",
    labels[:, 2:end],
    output_path = joinpath(BASE_OUT_PATH, "density_profile/new_models/stars"),
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 60,
    factor = 4,
    box_factor = 0.12,
    box_size = BOX_SIZE,
)

############################################################################################
# Comparison between simulations of the density profile of gas.
############################################################################################

# All models.
density_profile_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, snap_paths),
    "animation",
    FPS,
    "gas",
    labels,
    output_path = joinpath(BASE_OUT_PATH, "density_profile/all_models/gas"),
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 60,
    factor = 4,
    box_factor = 0.75,
    box_size = BOX_SIZE,
)

# All but the run_00 model.
density_profile_pipeline(
    base_names[2:end],
    joinpath.(BASE_SRC_PATH, snap_paths[2:end]),
    "animation",
    FPS,
    "gas",
    labels[:, 2:end],
    output_path = joinpath(BASE_OUT_PATH, "density_profile/new_models/gas"),
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 60,
    factor = 4,
    box_factor = 0.3,
    box_size = BOX_SIZE,
)

############################################################################################
# Comparison between simulations of the metallicity profile of stars.
############################################################################################

# All models.
metallicity_profile_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, snap_paths),
    "animation",
    FPS,
    "stars",
    labels,
    output_path = joinpath(BASE_OUT_PATH, "metallicity_profile/all_models/stars"),
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 80,
    box_factor = 1.0,
    box_size = BOX_SIZE,
)

# All but the run_00 model.
metallicity_profile_pipeline(
    base_names[2:end],
    joinpath.(BASE_SRC_PATH, snap_paths[2:end]),
    "animation",
    FPS,
    "stars",
    labels[:, 2:end],
    output_path = joinpath(BASE_OUT_PATH, "metallicity_profile/new_models/stars"),
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 80,
    box_factor = 0.15,
    box_size = BOX_SIZE,
)

############################################################################################
# Comparison between simulations of the metallicity profile of the gas.
############################################################################################

# All models.
metallicity_profile_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, snap_paths),
    "animation",
    FPS,
    "gas",
    labels,
    output_path = joinpath(BASE_OUT_PATH, "metallicity_profile/all_models/gas"),
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 80,
    box_factor = 3.0,
    box_size = BOX_SIZE,
)

# All but the run_00 and run_old_model models.
metallicity_profile_pipeline(
    base_names[3:end],
    joinpath.(BASE_SRC_PATH, snap_paths[3:end]),
    "animation",
    FPS,
    "gas",
    labels[:, 3:end],
    output_path = joinpath(BASE_OUT_PATH, "metallicity_profile/new_models/gas"),
    sim_cosmo = SIM_COSMO,
    scale = :log10,
    step = 10,
    bins = 80,
    box_factor = 0.6,
    box_size = BOX_SIZE,
)

println("Work done!")