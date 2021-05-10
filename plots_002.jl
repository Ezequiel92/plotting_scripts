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
  
  The figures will be store in ../../plots/002/, in one folder 
  per simulation. 
  
  Plots:
  - Column 2 (mass probability) vs Column 5 (actual mass), for every model.
  - Column 4 (SFR probability) vs Column 6 (actual SFR), for every model.
  - Column 3 (SFR per particle) vs Column 4 (SFR probability), for the old models.
  - Column 3 (SFR per particle) vs Column 4 (SFR probability) vs Column 6 (actual SFR), 
    for the old models.
  - Column 3 (SFR per particle), for the A, C, E, F and G models.
 =#

push!(LOAD_PATH, "../GADGETPlotting/src/")
using GADGETPlotting

"Path to the directory where the figures and animations will be saved."
const BASE_OUT_PATH = "../../plots/002"

"Path to the directory containing the simulations."
const BASE_SRC_PATH = "../../sim_data/results/isolated"

"""
The names of the directories containing the snapshot files 
and the base names of the files.
"""
const SNAPSHOTS = [
    "run_00" "snap_000"
    "run_old_model" "snap_000"
    "run_A_01" "snap_000"
    "run_C_01" "snap_000"
    "run_E_01" "snap_000"
    "run_F_01" "snap_000"
    "run_G_01_tupac" "snap_000"
    "run_A_02" "snap_000"
]

"""
Value of ComovingIntegrationOn: 
0 -> Newtonian simulation,
1 -> Cosmological simulation.
"""
const SIM_COSMO = 0

snap_paths = labels = SNAPSHOTS[:, 1]
snaps = SNAPSHOTS[:, 2]

############################################################################################
# Column 2 (mass probability) vs Column 5 (actual mass), for every model.
############################################################################################

sfr_txt_pipeline(
    snaps,
    joinpath.(BASE_SRC_PATH, snap_paths),
    1,
    [2, 5],
    output_path = joinpath(BASE_OUT_PATH, "mass_2_vs_5"),
    sim_cosmo = SIM_COSMO,
    title = labels,
    names = labels,
    bins = 50,
    scale = (:identity, :log10),
)

############################################################################################
# Column 4 (SFR probability) vs Column 6 (actual SFR), for every model.
############################################################################################

sfr_txt_pipeline(
    snaps,
    joinpath.(BASE_SRC_PATH, snap_paths),
    1,
    [4, 6],
    output_path = joinpath(BASE_OUT_PATH, "sfr_4_vs_6"),
    sim_cosmo = SIM_COSMO,
    title = labels,
    names = labels,
    bins = 50,
    scale = (:identity, :log10),
)

############################################################################################
# Column 3 (SFR per particle) vs Column 4 (SFR probability), for the old models.
############################################################################################

sfr_txt_pipeline(
    snaps[[1, 2]],
    joinpath.(BASE_SRC_PATH, snap_paths[[1, 2]]),
    1,
    [3, 4],
    output_path = joinpath(BASE_OUT_PATH, "sfr_3_vs_4"),
    sim_cosmo = SIM_COSMO,
    title = labels[[1, 2]],
    names = labels[[1, 2]],
    bins = 50,
    scale = (:identity, :log10),
)

############################################################################################
# Column 3 (SFR per particle) vs Column 4 (SFR probability) vs Column 6 (actual SFR), 
# for the old models.
############################################################################################

sfr_txt_pipeline(
    snaps[[1, 2]],
    joinpath.(BASE_SRC_PATH, snap_paths[[1, 2]]),
    1,
    [3, 4, 6],
    output_path = joinpath(BASE_OUT_PATH, "sfr_3_vs_4_vs_6"),
    sim_cosmo = SIM_COSMO,
    title = labels[[1, 2]],
    names = labels[[1, 2]],
    bins = 50,
    scale = (:identity, :log10),
)

############################################################################################
# Column 3 (SFR per particle), for the A, C, E, F, and G models.
############################################################################################

sfr_txt_pipeline(
    snaps[3:end],
    joinpath.(BASE_SRC_PATH, snap_paths[3:end]),
    1,
    [3],
    output_path = joinpath(BASE_OUT_PATH, "sfr_3_vs_t"),
    sim_cosmo = SIM_COSMO,
    title = labels[3:end],
    names = labels[3:end],
    bins = 50,
    scale = (:identity, :log10),
    min_filter = (-Inf, 1e-15),
)

println("Work done!")