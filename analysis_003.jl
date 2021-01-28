#= 
  Script for plotting the data generated by six single galaxy simulations 
  perform by GADGET3. The functions of GADGETPlotting.jl are used.

  The snapshots and related files are located in:
  ../../sim_data/run_00/
  ../../sim_data/run_A_01/
  ../../sim_data/run_C_01/
  ../../sim_data/run_D_01/
  ../../sim_data/run_E_01/
  ../../sim_data/run_old_model/

  The figures, GIF and videos will be store in ../../results/analysis_003/, in a folder 
  structure named to describe the contents within.
  
  Plots:
  - Accumulated mass profiles of gas and stars, compared between simulations,
    for each snapshot.
  
  NOTE: profile plots have the animation capability disable until issue 
  [3199](https://github.com/JuliaPlots/Plots.jl/issues/3199) is resolved =#

include("../GADGETPlotting/GADGETPlotting.jl")

"Base path for the directories where the figures and animations will be saved."
const BASE_OUT_PATH = "../../results/analysis_003/"  

"Directory containing the simulations."           
const SIM_PATH = "../../sim_data/"

"Directory containing the snapshot files."   
const SNAP_PATH = ["run_00/", "run_A_01/", "run_C_01/", "run_D_01/", "run_E_01/", "run_old_model/"]   

"Labels for the different simulations."  
const LABELS = ["run_00" "run_A_01" "run_C_01" "run_D_01" "run_E_01" "run_old_model"]   

"Base name of the snapshot files."
const SNAP_NAME = ["snap", "snap", "snap", "snap", "snap", "snap"]  

"Side dimension of the simulated region, with units, for the case of vacuum boundary conditions."
const BOX_SIZE = 200 * UnitfulAstro.kpc 

"Value of ComovingIntegrationOn: 0 -> Newtonian simulation, 1 -> Cosmological simulation."               
const SIM_COSMO = 0 

"Frame rate for the animations."                   
const FPS = 20                        

########################################################################################
# Accumulated mass profile of stars, comparing simulations.
########################################################################################
pgfplotsx()

# All models.
massProfilePipeline(SNAP_NAME, 
                    SIM_PATH .* SNAP_PATH, 
                    BASE_OUT_PATH * "all_models/", 
                    "animation", 
                    FPS,
                    "stars",
                    LABELS,
                    scale=:log10,
                    step=10,
                    bins=80,
                    factor=10,
                    region_factor=0.15,
                    sim_cosmo=SIM_COSMO,
                    region_size=BOX_SIZE)

# All but the run_00 model.
massProfilePipeline(SNAP_NAME[2:end], 
                    SIM_PATH .* SNAP_PATH[2:end], 
                    BASE_OUT_PATH * "new_models/", 
                    "animation", 
                    FPS,
                    "stars",
                    LABELS[:,2:end],
                    scale=:log10,
                    step=10,
                    bins=80,
                    factor=9,
                    region_factor=0.1,
                    sim_cosmo=SIM_COSMO,
                    region_size=BOX_SIZE)

########################################################################################
# Accumulated mass profile of the gas, comparing simulations.
########################################################################################

# All models.
massProfilePipeline(SNAP_NAME, 
                    SIM_PATH .* SNAP_PATH, 
                    BASE_OUT_PATH * "all_models/", 
                    "animation", 
                    FPS,
                    "gas",
                    LABELS,
                    scale=:log10,
                    step=10,
                    bins=60,
                    factor=10,
                    region_factor=0.3,
                    sim_cosmo=SIM_COSMO,
                    region_size=BOX_SIZE)

# All but the run_00 model.
massProfilePipeline(SNAP_NAME[2:end], 
                    SIM_PATH .* SNAP_PATH[2:end], 
                    BASE_OUT_PATH * "new_models/", 
                    "animation", 
                    FPS,
                    "gas",
                    LABELS[:,2:end],
                    scale=:log10,
                    step=10,
                    bins=60,
                    factor=10,
                    region_factor=0.15,
                    sim_cosmo=SIM_COSMO,
                    region_size=BOX_SIZE)
