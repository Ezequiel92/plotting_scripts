#= 
  Script for plotting the sfr.txt of six single galaxy simulations, perform by GADGET3.
  The functions in GADGETPlotting.jl are used.

  The snapshots and related files are located in:
  ../../sim_data/run_00/
  ../../sim_data/run_A_01/
  ../../sim_data/run_C_01/
  ../../sim_data/run_D_01/
  ../../sim_data/run_E_01/
  ../../sim_data/run_old_model/

  The figures will be store in ../../results/analysis_002/, in one folder 
  per simulation. 
  
  Plots:
  - Different columns are compare between simulations, depending on them being the same physical 
    quantity and its values being at similar orders. =#

include("../GADGETPlotting/GADGETPlotting.jl")

"Base sim for the directories where the figures and animations will be saved."
const BASE_OUT_PATH = "../../results/analysis_002/"  

"Directory containing the simulations."           
const SIM_PATH = "../../sim_data/"

"Full list of directories containing the snapshot files."   
const FULL_SNAP_PATH = ["run_00/", "run_A_01/", "run_C_01/", "run_D_01/", "run_E_01/", "run_old_model/"]   

"List of directories containing the snapshot files of the old models."   
const OLD_SNAP_PATH = ["run_00/", "run_old_model/"]  

"List of directories containing the snapshot files of the new models."   
const NEW_SNAP_PATH = ["run_A_01/", "run_C_01/", "run_D_01/", "run_E_01/"] 

"Base name of the snapshot files."
const SNAP_NAME = ["snap", "snap", "snap", "snap", "snap", "snap"]  

"Value of ComovingIntegrationOn: 0 -> Newtonian simulation, 1 -> Cosmological simulation."               
const SIM_COSMO = 0  

mkpath.(BASE_OUT_PATH .* FULL_SNAP_PATH)

########################################################################################
# Column 2 (prob. mass) vs Column 5 (actual mass), for every model.
########################################################################################

for (i, sim) in enumerate(FULL_SNAP_PATH)
    sfrTxtPlot( SIM_PATH * sim, 
                SNAP_NAME[i], 
                1, [2, 5], 
                title=sim[1:end - 1], 
                bins=50, 
                scale=[:identity, :log10], 
                sim_cosmo=SIM_COSMO)
    savefig(BASE_OUT_PATH * sim * "mass_2vs5.png")
end

########################################################################################
# Column 4 (prob. SFR) vs Column 6 (actual SFR), for every model.
########################################################################################

for (i, sim) in enumerate(FULL_SNAP_PATH)
    sfrTxtPlot( SIM_PATH * sim, 
                SNAP_NAME[i], 
                1, [4, 6], 
                title=sim[1:end - 1], 
                bins=50, 
                scale=[:identity, :log10], 
                sim_cosmo=SIM_COSMO)
    savefig(BASE_OUT_PATH * sim * "sfr_4vs6.png")
end

########################################################################################
# Column 3 (SFR per particle) vs Column 4 (prob. SFR), for the old models.
########################################################################################

for (i, sim) in enumerate(OLD_SNAP_PATH)
    sfrTxtPlot( SIM_PATH * sim, 
                SNAP_NAME[i], 
                1, [3, 4], 
                title=sim[1:end - 1], 
                bins=50, 
                scale=[:identity, :log10], 
                sim_cosmo=SIM_COSMO)
    savefig(BASE_OUT_PATH * sim * "sfr_3vs4.png")
end

########################################################################################
# Column 3 (SFR per particle) vs Column 4 (prob. SFR) vs Column 6 (actual SFR), 
# for the old models.
########################################################################################

for (i, sim) in enumerate(OLD_SNAP_PATH)
    sfrTxtPlot( SIM_PATH * sim, 
                SNAP_NAME[i], 
                1, [3, 4, 6], 
                title=sim[1:end - 1], 
                bins=50, 
                scale=[:identity, :log10], 
                sim_cosmo=SIM_COSMO)
    savefig(BASE_OUT_PATH * sim * "sfr_3vs4vs6.png")
end

########################################################################################
# Column 3 (SFR per particle) for the new models.
########################################################################################

for (i, sim) in enumerate(NEW_SNAP_PATH)
    sfrTxtPlot( SIM_PATH * sim, 
                SNAP_NAME[i], 
                1, [3,], 
                title=sim[1:end - 1], 
                bins=50, 
                scale=[:identity, :log10], 
                min_filter=[-Inf,1e-15], sim_cosmo=SIM_COSMO)
    savefig(BASE_OUT_PATH * sim * "sfr_3.png")
end
