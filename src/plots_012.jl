#= 
  Script for plotting the data generated by GADGET3 simulations, using GADGETPlotting.jl.

  The snapshots and related data files are located in:
    ../../sim_data/results/isolated/M000_32
    ../../sim_data/results/isolated/M016_32_HSML000
    ../../sim_data/results/isolated/M016_32_HSML025
    ../../sim_data/results/isolated/M016_32_HSML050
    ../../sim_data/results/isolated/M016_32_CPD0318
    ../../sim_data/results/isolated/M016_32_HSML001

  The resulting figures, GIFs, and videos will be store in ../../plots/012/.
  
  Plots:
    - Comparison of SFR vs. time.
    - Comparison of star mass vs. time.
    - Comparison of column 2, 3, 4, 5 y 6 vs. column 1 (time):
      - Column 2: mass probability.
      - Column 3: SFR per particle.
      - Column 4: SFR probability
      - Column 5: actual mass.
      - Column 6: actual SFR.
    - Comparison of CPU usage (`cs_sfr` process only).
 =#

push!(LOAD_PATH, "../GADGETPlotting/src/")
using GADGETPlotting, Unitful, UnitfulAstro

"Path to the directory where the figures and animations will be saved."
const BASE_OUT_PATH = "../../plots/012"

"Path to the directory containing the simulations."
const BASE_SRC_PATH = "../../sim_data/results/isolated"

"""
Names of the directories containing the snapshot files 
and the base names of the files.
"""
const SNAPSHOTS = [
    "M000_32" "snap" "M000_32 - 0.75" 0.35          # `MinGasHsmlFractional` = 0.75
    "M016_32_HSML000" "snap" "M016_32 - 0.0" 0.2    # `MinGasHsmlFractional` = 0.0
    "M016_32_HSML025" "snap" "M016_32 - 0.25" 0.2   # `MinGasHsmlFractional` = 0.25
    "M016_32_HSML050" "snap" "M016_32 - 0.5" 0.2    # `MinGasHsmlFractional` = 0.5
    "M016_32_CPD0318" "snap" "M016_32 - 0.75" 0.2   # `MinGasHsmlFractional` = 0.75
    "M016_32_HSML001" "snap" "M016_32 - 1.0" 0.2    # `MinGasHsmlFractional` = 1.0
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
const FPS = 24

titles =
    names = [
        "mass_probability_vs_t",
        "SFR_per_particle_vs_t",
        "SFR_probability_vs_t",
        "actual_mass_vs_t",
        "actual_SFR_vs_t",
    ]

sim_paths = String.(SNAPSHOTS[:, 1])
base_names = String.(SNAPSHOTS[:, 2])
labels = String.(reshape(SNAPSHOTS[:, 3], 1, :))
box_factors = Float64.(SNAPSHOTS[:, 4])

############################################################################################
# Comparison of SFR vs. time
############################################################################################

compare_simulations_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, sim_paths),
    labels,
    "all_sims",
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
# Comparison of star mass vs. time
############################################################################################

compare_simulations_pipeline(
    base_names,
    joinpath.(BASE_SRC_PATH, sim_paths),
    labels,
    "all_sims",
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
# Comparison of column 2, 3, 4, 5 y 6 vs. column 1 (time)
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

############################################################################################
# Comparison of CPU usage (`cs_sfr` process only)
############################################################################################

cpu_txt_pipeline(
    joinpath.(BASE_SRC_PATH, sim_paths[2:end]),
    "cs_sfr",
    labels[:, 2:end],
    step = 100,
    output_path = joinpath(BASE_OUT_PATH, "cpu_txt"),
)

############################################################################################
# Star density field projected into the x-y plane, for each simulation
############################################################################################

for (base_name, sim, box_factor) in zip(base_names, sim_paths, box_factors)
    star_map_pipeline(
        base_name,
        joinpath(BASE_SRC_PATH, sim),
        "density_animation",
        FPS,
        output_path = joinpath(BASE_OUT_PATH, "star_density_field", sim),
        sim_cosmo = SIM_COSMO,
        plane = "XY",
        box_size = BOX_SIZE,
        box_factor = box_factor,
    )
end

############################################################################################
# Kennicutt-Schmidt law (Σ_SFR vs. Σ_ρ), for every simulation
############################################################################################

for (base_name, sim) in zip(base_names, sim_paths)
    kennicutt_schmidt_pipeline(
        base_name,
        joinpath(BASE_SRC_PATH, sim),
        output_path = joinpath(BASE_OUT_PATH, "Kennicutt_Schmidt", sim),
        sim_cosmo = SIM_COSMO,
        step = 10,
        temp_filter = Inf * Unitful.K,
        age_filter = 200UnitfulAstro.Myr,
        max_r = BOX_SIZE,
        bins = ustrip(Int64, unit(BOX_SIZE), BOX_SIZE) * 3,
        time_unit = UnitfulAstro.Myr,
    )
end

println("Work done!")
