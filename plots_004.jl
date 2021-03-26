#= 
  Script for plotting the data generated by several single galaxy
  GADGET3 simulations; using the module GADGETPlotting.jl.

  The snapshots and related files are located in:
  ../../sim_data/isolated/run_00/
  ../../sim_data/isolated/run_old_model/
  ../../sim_data/isolated/run_A_01/
  ../../sim_data/isolated/run_C_01/
  ../../sim_data/isolated/run_E_01/
  ../../sim_data/isolated/run_F_01/
  ../../sim_data/isolated/run_G_01/

  The figures, GIFs and videos will be store in ../../plots/004/, 
  in directories named to describe the contents within.
  
  Plots:
  - Normalized logarithm of the temperature histogram, for every simulation.
  - T vs. ρ, for every simulation.
  - Kennicutt-Schmidt law (Σ_SFR vs. Σ_ρ), for every simulation.
  - Comparison between simulations of the CMDF.
 =#

push!(LOAD_PATH, "../GADGETPlotting/src/")
using GADGETPlotting, Unitful, UnitfulAstro, Plots

"Path to the directory where the figures and animations will be saved."
const BASE_OUT_PATH = "../../plots/004"

"Path to the directory containing the simulations."
const BASE_SRC_PATH = "../../sim_data/isolated"

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
    "run_G_01" "snap"
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
labels = reshape(SNAPSHOTS[:, 1], 1, :)
base_names = SNAPSHOTS[:, 2]

############################################################################################
# Normalized logarithm of the temperature histogram, for every simulation.
############################################################################################

for (i, run) in enumerate(snap_paths)
    temperatureHistogramPipeline(
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
# T vs. ρ, for every simulation.
############################################################################################

for (i, run) in enumerate(snap_paths)
    rhoTempPipeline(
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
# Kennicutt-Schmidt law (Σ_SFR vs. Σ_ρ), for every simulation.
############################################################################################

for (i, run) in enumerate(snap_paths)
    KennicuttSchmidtPipeline(
        base_names[i],
        joinpath(BASE_SRC_PATH, run),
        output_path = joinpath(BASE_OUT_PATH, "Kennicutt_Schmidt", run),
        sim_cosmo = SIM_COSMO,
        step = 10,
        temp_filter = 2e4Unitful.K,
        age_filter = 200UnitfulAstro.Myr,
        box_size = BOX_SIZE,
        bins = 80,
        time_unit = UnitfulAstro.Myr,
    )
end

############################################################################################
# Comparison between simulations of the CMDF (cumulative metallicity distribution function).
############################################################################################

# All models.
CMDFPipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, snap_paths),
    "CMDF_animation",
    FPS,
    labels,
    output_path = joinpath(BASE_OUT_PATH, "CMDF/all_models"),
    sim_cosmo = SIM_COSMO,
    step = 10,
)

# All but run_00 and run_F_01.
CMDFPipeline(
    base_names[[2, 3, 4, 5, 7]],
    joinpath.(BASE_SRC_PATH, snap_paths[[2, 3, 4, 5, 7]]),
    "CMDF_animation",
    FPS,
    labels[:, [2, 3, 4, 5, 7]],
    output_path = joinpath(BASE_OUT_PATH, "CMDF/new_models"),
    sim_cosmo = SIM_COSMO,
    step = 10,
)

# All models, x axis normalized.
CMDFPipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, snap_paths),
    "CMDF_animation",
    FPS,
    labels,
    output_path = joinpath(BASE_OUT_PATH, "CMDF_normalized/all_models"),
    sim_cosmo = SIM_COSMO,
    step = 10,
    x_norm = true,
)

# All but run_00 and run_F_01, x axis normalized.
CMDFPipeline(
    base_names[[2, 3, 4, 5, 7]],
    joinpath.(BASE_SRC_PATH, snap_paths[[2, 3, 4, 5, 7]]),
    "CMDF_animation",
    FPS,
    labels[:, [2, 3, 4, 5, 7]],
    output_path = joinpath(BASE_OUT_PATH, "CMDF_normalized/new_models"),
    sim_cosmo = SIM_COSMO,
    step = 10,
    x_norm = true,
)

println("Work done!")
