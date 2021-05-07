############################################################################################
# Template for the analysis of a single GADGET3 simulation. 
# Triple Xs (XXX) should be replaced accordingly.
############################################################################################

#= 
  Script for plotting the data generated by a GADGET3 simulation; using GADGETPlotting.jl.

  The snapshots and related data files are located in:
  ../../sim_data/results/XXX/XXX

  The resulting figures, GIFs, and videos will be store in ../../plots/XXX/.
  
  Plots:
  - Star density field projected into the XY plane.
  - Density profile of stars.
  - Density profile of gas.
  - Metallicity profile of the stars.
  - Metallicity profile of the gas.
  - Column 2 (mass probability) vs Column 5 (actual mass).
  - Column 4 (SFR probability) vs Column 6 (actual SFR).
  - Column 3 (SFR per particle).
  - Accumulated mass profile for the stars.
  - Accumulated mass profile for the gas.
  - Normalized logarithm of the temperature histogram.
  - T vs. ρ.
  - Kennicutt-Schmidt law (Σ_SFR vs. Σ_ρ).
  - CMDF (cumulative metallicity distribution function).
  - Star mass vs time.
  - SFR mass vs time.
  
  NOTE: profile plots have the animation capability disable until the issue 
  [3199](https://github.com/JuliaPlots/Plots.jl/issues/3199) is resolved.
 =#

 push!(LOAD_PATH, "../GADGETPlotting/src/")
 using GADGETPlotting, Unitful, UnitfulAstro
 
 "Path to the directory where the figures and animations will be saved."
 const BASE_OUT_PATH = "../../plots/XXX"
 
 "Path to the directory containing the simulations."
 const BASE_SRC_PATH = "../../sim_data/results/XXX"
 
 """
 Side dimension of the simulated region, with units, 
 for the case of vacuum boundary conditions.
 """
 const BOX_SIZE = XXX * UnitfulAstro.kpc
 
 """
 Value of ComovingIntegrationOn: 
 0 -> Newtonian simulation,
 1 -> Cosmological simulation.
 """
 const SIM_COSMO = XXX
 
 "Frame rate for the animations."
 const FPS = XXX
 
 "Name of the simulation."
 const SIM_NAME = "XXX"
 
 "Base name of the snapshot files."
 const BASE_NAME = "XXX"
 
 "Name of the first snapshot."
 const FIRST_SNAP = "XXX"
 
 "Zoom-in factor for the stars (with respect to BOX_SIZE)."
 const ZOOM_IN_FACTOR = XXX
 
 ############################################################################################
 # Star density field projected into the XY plane.
 ############################################################################################
 
 starMapPipeline(
     BASE_NAME,
     joinpath(BASE_SRC_PATH, SIM_NAME),
     "density_animation",
     FPS,
     output_path = joinpath(BASE_OUT_PATH, "star_density_field"),
     sim_cosmo = SIM_COSMO,
     plane = "XY",
     box_size = BOX_SIZE,
     box_factor = ZOOM_IN_FACTOR,
 )
 
 ############################################################################################
 # Density profile of stars.
 ############################################################################################
 
 densityProfilePipeline(
     BASE_NAME,
     joinpath(BASE_SRC_PATH, SIM_NAME),
     "animation",
     FPS,
     "stars",
     output_path = joinpath(BASE_OUT_PATH, "density_profile/stars"),
     sim_cosmo = SIM_COSMO,
     scale = :log10,
     step = 10,
     bins = 60,
     factor = 4,
     box_factor = ZOOM_IN_FACTOR,
     box_size = BOX_SIZE,
 )
 
 ############################################################################################
 # Density profile of gas.
 ############################################################################################
 
 densityProfilePipeline(
     BASE_NAME,
     joinpath(BASE_SRC_PATH, SIM_NAME),
     "animation",
     FPS,
     "gas",
     output_path = joinpath(BASE_OUT_PATH, "density_profile/gas"),
     sim_cosmo = SIM_COSMO,
     scale = :log10,
     step = 10,
     bins = 60,
     factor = 4,
     box_factor = ZOOM_IN_FACTOR * 2.0,
     box_size = BOX_SIZE,
 )
 
 ############################################################################################
 # Metallicity profile of stars.
 ############################################################################################
 
 metallicityProfilePipeline(
     BASE_NAME,
     joinpath(BASE_SRC_PATH, SIM_NAME),
     "animation",
     FPS,
     "stars",
     output_path = joinpath(BASE_OUT_PATH, "metallicity_profile/stars"),
     sim_cosmo = SIM_COSMO,
     scale = :log10,
     step = 10,
     bins = 80,
     box_factor = ZOOM_IN_FACTOR,
     box_size = BOX_SIZE,
 )
 
 ############################################################################################
 # Metallicity profile of the gas.
 ############################################################################################
 
 metallicityProfilePipeline(
     BASE_NAME,
     joinpath(BASE_SRC_PATH, SIM_NAME),
     "animation",
     FPS,
     "gas",
     output_path = joinpath(BASE_OUT_PATH, "metallicity_profile/gas"),
     sim_cosmo = SIM_COSMO,
     scale = :log10,
     step = 10,
     bins = 80,
     box_factor = ZOOM_IN_FACTOR * 2.0,
     box_size = BOX_SIZE,
 )
 
 ############################################################################################
 # Column 2 (mass probability) vs Column 5 (actual mass).
 ############################################################################################
 
 sfrTxtPipeline(
     [FIRST_SNAP],
     [joinpath(BASE_SRC_PATH, SIM_NAME)],
     1,
     [2, 5],
     output_path = joinpath(BASE_OUT_PATH, "sfr_txt"),
     sim_cosmo = SIM_COSMO,
     names = ["mass_2_vs_5"],
     bins = 50,
     scale = (:identity, :log10),
 )
 
 ############################################################################################
 # Column 4 (SFR probability) vs Column 6 (actual SFR).
 ############################################################################################
 
 sfrTxtPipeline(
     [FIRST_SNAP],
     [joinpath(BASE_SRC_PATH, SIM_NAME)],
     1,
     [4, 6],
     output_path = joinpath(BASE_OUT_PATH, "sfr_txt"),
     sim_cosmo = SIM_COSMO,
     names = ["sfr_4_vs_6"],
     bins = 50,
     scale = (:identity, :log10),
 )
 
 ############################################################################################
 # Accumulated mass profile for the stars.
 ############################################################################################
 
 massProfilePipeline(
     BASE_NAME,
     joinpath(BASE_SRC_PATH, SIM_NAME),
     "animation",
     FPS,
     "stars",
     output_path = joinpath(BASE_OUT_PATH, "mass_profile/stars"),
     sim_cosmo = SIM_COSMO,
     scale = :log10,
     step = 10,
     bins = 80,
     factor = 10,
     box_factor = ZOOM_IN_FACTOR * 0.5,
     box_size = BOX_SIZE,
 )
 
 ############################################################################################
 # Accumulated mass profile for the gas.
 ############################################################################################
 
 massProfilePipeline(
     BASE_NAME,
     joinpath(BASE_SRC_PATH, SIM_NAME),
     "animation",
     FPS,
     "gas",
     output_path = joinpath(BASE_OUT_PATH, "mass_profile/gas"),
     sim_cosmo = SIM_COSMO,
     scale = :log10,
     step = 10,
     bins = 60,
     factor = 10,
     box_factor = ZOOM_IN_FACTOR,
     box_size = BOX_SIZE,
 )
 
 ############################################################################################
 # Normalized logarithm of the temperature histogram.
 ############################################################################################
 
 temperatureHistogramPipeline(
     BASE_NAME,
     joinpath(BASE_SRC_PATH, SIM_NAME),
     "temperature_histogram_animation",
     FPS,
     output_path = joinpath(BASE_OUT_PATH, "temperature_histogram"),
     sim_cosmo = SIM_COSMO,
     step = 10,
 )
 
 ############################################################################################
 # T vs. ρ.
 ############################################################################################
 
 rhoTempPipeline(
     BASE_NAME,
     joinpath(BASE_SRC_PATH, SIM_NAME),
     "rho_vs_temp_animation",
     FPS,
     output_path = joinpath(BASE_OUT_PATH, "rho_vs_temp"),
     sim_cosmo = SIM_COSMO,
     step = 10,
 )
 
 ############################################################################################
 # Kennicutt-Schmidt law (Σ_SFR vs. Σ_ρ).
 ############################################################################################
 
 KennicuttSchmidtPipeline(
     BASE_NAME,
     joinpath(BASE_SRC_PATH, SIM_NAME),
     output_path = joinpath(BASE_OUT_PATH, "Kennicutt_Schmidt"),
     sim_cosmo = SIM_COSMO,
     step = 10,
     age_filter = 300UnitfulAstro.Myr,
     max_r = BOX_SIZE * ZOOM_IN_FACTOR,
     bins = 100,
     time_unit = UnitfulAstro.Myr,
 )
 
 ############################################################################################
 # CMDF (cumulative metallicity distribution function).
 ############################################################################################
 
 CMDFPipeline(
     BASE_NAME,
     joinpath(BASE_SRC_PATH, SIM_NAME),
     "CMDF_animation",
     FPS,
     output_path = joinpath(BASE_OUT_PATH, "CMDF"),
     sim_cosmo = SIM_COSMO,
     step = 10,
 )
 
 # X axis normalized.
 CMDFPipeline(
     BASE_NAME,
     joinpath(BASE_SRC_PATH, SIM_NAME),
     "CMDF_animation",
     FPS,
     output_path = joinpath(BASE_OUT_PATH, "CMDF_normalized"),
     sim_cosmo = SIM_COSMO,
     step = 10,
     x_norm = true,
 )
 
 ############################################################################################
 # Star mass vs time.
 ############################################################################################
 
 compareSimulationsPipeline(
     [BASE_NAME],
     [joinpath(BASE_SRC_PATH, SIM_NAME)],
     reshape([SIM_NAME], 1, 1),
     SIM_NAME,
     "clock_time",
     "star_mass",
     output_path = BASE_OUT_PATH,
     sim_cosmo = SIM_COSMO,
     scale = [:identity, :log10],
     smooth_data = true,
     bins = 60,
     text_quantity = "star_mass",
     file_name = "star_mass",
 )
 
 ############################################################################################
 # SFR vs time.
 ############################################################################################
 
 compareSimulationsPipeline(
     [BASE_NAME],
     [joinpath(BASE_SRC_PATH, SIM_NAME)],
     reshape([SIM_NAME], 1, 1),
     SIM_NAME,
     "clock_time",
     "sfr",
     output_path = BASE_OUT_PATH,
     sim_cosmo = SIM_COSMO,
     scale = [:identity, :log10],
     smooth_data = true,
     bins = 60,
     text_quantity = "sfr",
     file_name = "sfr",
 )
 
 println("Work done!")