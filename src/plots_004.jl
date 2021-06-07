
#= 
  Script for plotting the data generated by GADGET3 simulations, using GADGETPlotting.jl.

  The snapshots and related data files are located in:
    ../../sim_data/results/isolated/run_00/
    ../../sim_data/results/isolated/run_old_model/
    ../../sim_data/results/isolated/run_A_01/
    ../../sim_data/results/isolated/run_A_02/
    ../../sim_data/results/isolated/run_C_01/
    ../../sim_data/results/isolated/run_E_01/
    ../../sim_data/results/isolated/run_F_01/
    ../../sim_data/results/isolated/run_G_01_tupac/

  The resulting figures, GIFs, and videos will be store in ../../plots/004/.
  
  Plots:
    - Temperature histogram, for every simulation.
    - T (temperature) vs. ρ (density), for every simulation.
    - Kennicutt-Schmidt law (Σ_SFR vs. Σ_ρ), for every simulation
    - Comparison of the CMDF (cumulative metallicity distribution function)
  
  NOTE: Some plots have the animation capability disable until the issue 
  [3199](https://github.com/JuliaPlots/Plots.jl/issues/3199) is resolved.
 =#

push!(LOAD_PATH, "../GADGETPlotting/src/")
using GADGETPlotting, Unitful, UnitfulAstro

"Path to the directory where the figures and animations will be saved."
const BASE_OUT_PATH = "../../plots/004"

"Path to the directory containing the simulations."
const BASE_SRC_PATH = "../../sim_data/results/isolated"

"""
Names of the directories containing the snapshot files 
and the base names of the files.
"""
const SNAPSHOTS = [
    "run_00" "snap"
    "run_old_model" "snap"
    "run_A_01" "snap"
    "run_A_02" "snap"
    "run_C_01" "snap"
    "run_E_01" "snap"
    "run_F_01" "snap"
    "run_G_01_tupac" "snap"
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
# Temperature histogram, for every simulation
############################################################################################

for (i, run) in enumerate(snap_paths)
    temperature_histogram_pipeline(
        base_names[i],
        joinpath(BASE_SRC_PATH, run),
        "temperature_histogram_animation",
        FPS,
        output_path = joinpath(BASE_OUT_PATH, "temperature_histogram", run),
        sim_cosmo = SIM_COSMO,
        step = 10,
    )
end

############################################################################################
# T (temperature) vs. ρ (density), for every simulation
############################################################################################

for (i, run) in enumerate(snap_paths)
    rho_temp_pipeline(
        base_names[i],
        joinpath(BASE_SRC_PATH, run),
        "rho_vs_temp_animation",
        FPS,
        output_path = joinpath(BASE_OUT_PATH, "rho_vs_temp", run),
        sim_cosmo = SIM_COSMO,
        step = 10,
    )
end

############################################################################################
# Kennicutt-Schmidt law (Σ_SFR vs. Σ_ρ), for every simulation
############################################################################################

for (i, run) in enumerate(snap_paths)
    kennicutt_schmidt_pipeline(
        base_names[i],
        joinpath(BASE_SRC_PATH, run),
        output_path = joinpath(BASE_OUT_PATH, "Kennicutt_Schmidt", run),
        sim_cosmo = SIM_COSMO,
        step = 10,
        temp_filter = 2e4Unitful.K,
        age_filter = 200UnitfulAstro.Myr,
        max_r = BOX_SIZE,
        bins = ustrip(Int64, unit(BOX_SIZE), BOX_SIZE),
        time_unit = UnitfulAstro.Myr,
    )
end

############################################################################################
# Comparison of the CMDF (cumulative metallicity distribution function)
############################################################################################

# All simulations
cmdf_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, snap_paths),
    "CMDF_animation",
    FPS,
    labels,
    output_path = joinpath(BASE_OUT_PATH, "CMDF/all_sims"),
    sim_cosmo = SIM_COSMO,
    step = 10,
)

# All but the `run_00` and `run_F_01` simulations
cmdf_pipeline(
    base_names[[2, 3, 4, 5, 6, 8]],
    joinpath.(BASE_SRC_PATH, snap_paths[[2, 3, 4, 5, 6, 8]]),
    "CMDF_animation",
    FPS,
    labels[:, [2, 3, 4, 5, 6, 8]],
    output_path = joinpath(BASE_OUT_PATH, "CMDF/new_sims"),
    sim_cosmo = SIM_COSMO,
    step = 10,
)

# All simulations, x axis normalized
cmdf_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, snap_paths),
    "CMDF_animation",
    FPS,
    labels,
    output_path = joinpath(BASE_OUT_PATH, "CMDF_normalized/all_sims"),
    sim_cosmo = SIM_COSMO,
    step = 10,
    x_norm = true,
)

# All but the `run_00` and `run_F_01` simulations, x axis normalized
cmdf_pipeline(
    base_names[[2, 3, 4, 5, 6, 8]],
    joinpath.(BASE_SRC_PATH, snap_paths[[2, 3, 4, 5, 6, 8]]),
    "CMDF_animation",
    FPS,
    labels[:, [2, 3, 4, 5, 6, 8]],
    output_path = joinpath(BASE_OUT_PATH, "CMDF_normalized/new_sims"),
    sim_cosmo = SIM_COSMO,
    step = 10,
    x_norm = true,
)

println("Work done!")