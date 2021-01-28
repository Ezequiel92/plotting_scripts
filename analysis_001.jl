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

  The figures, GIF and videos will be store in ../../results/analysis_001/, in a folder 
  structure named to describe the contents within.
  
  Plots:
  - A density map of the stars projected in the XY plane, for each snapshot of each simulation.
  - Density and metallicity profiles for gas and stars, compared between simulations,
    for each snapshot. 
  - SFR vs time compared between simulations in a single figure. 
  
  NOTE: profile plots have the animation capability disable until issue 
  [3199](https://github.com/JuliaPlots/Plots.jl/issues/3199) is resolved =#

include("../GADGETPlotting/GADGETPlotting.jl")

"Base path for the directories where the figures and animations will be saved."
const BASE_OUT_PATH = "../../results/analysis_001/"  

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
# Star density field projected to the X-Y plane, for each simulation.
########################################################################################

region_factor = [0.35, 0.2, 0.2, 0.2, 0.2, 0.2]

for (i, sim) in enumerate(SNAP_PATH)
    starMapPipeline(SNAP_NAME[i], 
                    SIM_PATH * sim, 
                    BASE_OUT_PATH * sim,
                    "density_anim", 
                    FPS,
                    plane="XY",
                    region_factor=region_factor[i],
                    sim_cosmo=SIM_COSMO,
                    region_size=BOX_SIZE)
end

########################################################################################
# Density profile of stars, comparing simulations.
########################################################################################
pgfplotsx()

# All models.
densityProfilePipeline( SNAP_NAME, 
                        SIM_PATH .* SNAP_PATH, 
                        BASE_OUT_PATH * "all_models/", 
                        "animation", 
                        FPS,
                        "stars",
                        LABELS,
                        scale=:log10,
                        step=10,
                        bins=60,
                        factor=4,
                        region_factor=0.2,
                        sim_cosmo=SIM_COSMO,
                        region_size=BOX_SIZE)

# All but the run_00 model.
densityProfilePipeline( SNAP_NAME[2:end], 
                        SIM_PATH .* SNAP_PATH[2:end], 
                        BASE_OUT_PATH * "new_models/", 
                        "animation", 
                        FPS,
                        "stars",
                        LABELS[:,2:end],
                        scale=:log10,
                        step=10,
                        bins=60,
                        factor=4,
                        region_factor=0.12,
                        sim_cosmo=SIM_COSMO,
                        region_size=BOX_SIZE)

########################################################################################
# Density profile of the gas, comparing simulations.
########################################################################################

# All models.
densityProfilePipeline( SNAP_NAME, 
                        SIM_PATH .* SNAP_PATH, 
                        BASE_OUT_PATH * "all_models/", 
                        "animation", 
                        FPS,
                        "gas",
                        LABELS,
                        scale=:log10,
                        step=10,
                        bins=60,
                        factor=4,
                        region_factor=0.75,
                        sim_cosmo=SIM_COSMO,
                        region_size=BOX_SIZE)

# All but the run_00 model.
densityProfilePipeline( SNAP_NAME[2:end], 
                        SIM_PATH .* SNAP_PATH[2:end], 
                        BASE_OUT_PATH * "new_models/", 
                        "animation", 
                        FPS,
                        "gas",
                        LABELS[:,2:end],
                        scale=:log10,
                        step=10,
                        bins=60,
                        factor=4,
                        region_factor=0.3,
                        sim_cosmo=SIM_COSMO,
                        region_size=BOX_SIZE)

########################################################################################
# Stars metallicity profile, comparing simulations.
########################################################################################

# All models.
metallicityProfilePipeline( SNAP_NAME, 
                            SIM_PATH .* SNAP_PATH, 
                            BASE_OUT_PATH * "all_models/", 
                            "animation", 
                            FPS,
                            "stars",
                            LABELS,
                            scale=:log10,
                            step=10,
                            bins=80,
                            region_factor=1.0,
                            sim_cosmo=SIM_COSMO,
                            region_size=BOX_SIZE)

# All but the run_00 model.
metallicityProfilePipeline( SNAP_NAME[2:end], 
                            SIM_PATH .* SNAP_PATH[2:end], 
                            BASE_OUT_PATH * "new_models/", 
                            "animation", 
                            FPS,
                            "stars",
                            LABELS[:,2:end],
                            scale=:log10,
                            step=10,
                            bins=80,
                            region_factor=0.15,
                            sim_cosmo=SIM_COSMO,
                            region_size=BOX_SIZE)

########################################################################################
# Gas metallicity profile, comparing simulations.
########################################################################################

# All models.
metallicityProfilePipeline( SNAP_NAME, 
                            SIM_PATH .* SNAP_PATH, 
                            BASE_OUT_PATH * "all_models/", 
                            "animation", 
                            FPS,
                            "gas",
                            LABELS,
                            scale=:log10,
                            step=10,
                            bins=80,
                            region_factor=3.0,
                            sim_cosmo=SIM_COSMO,
                            region_size=BOX_SIZE)

# All but the run_00 and run_old_model models.
metallicityProfilePipeline( SNAP_NAME[2:end-1], 
                            SIM_PATH .* SNAP_PATH[2:end-1], 
                            BASE_OUT_PATH * "new_models/", 
                            "animation", 
                            FPS,
                            "gas",
                            LABELS[:,2:end],
                            scale=:log10,
                            step=10,
                            bins=80,
                            region_factor=0.6,
                            sim_cosmo=SIM_COSMO,
                            region_size=BOX_SIZE)

########################################################################################
# Comparison between simulation of SFR vs time.
########################################################################################

compareSimulationsPipeline( SNAP_NAME, 
                            SIM_PATH .* SNAP_PATH,
                            BASE_OUT_PATH, 
                            LABELS, 
                            "compare",
                            "clock_time",
                            "sfr",
                            log_scale=true,
                            smooth_data=true,
                            folder="compare_sfr/")