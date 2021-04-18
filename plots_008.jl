#= 
  Script for plotting the data generated by several single galaxy
  GADGET3 simulations; using the module GADGETPlotting.jl.

  The snapshots and related files are located in:
  ../../sim_data/results/isolated/run_00/
  ../../sim_data/results/isolated/run_old_model/
  ../../sim_data/results/isolated/run_A_01/
  ../../sim_data/results/isolated/run_G_01_tupac/

  The figures will be store in ../../plots/008/.

  The images have three defining characteristics: simulation, time, and age filter.
  By default the function KennicuttSchmidtPipeline() will slice the images by 
  simulation -> age filter -> time. This is what ends up in the folder `all_Kennicutt_Schmidt`.
  Given that we are interested in the moment of maximum SFR, we slice the results 
  as simulation -> age filter, at a fixed time (a different one for each simulation).
  This is what ends up in the folder `Kennicutt_Schmidt_at_max_sfr`. 
  
  So the final directory structure is

    .
    ├── all_Kennicutt_Schmidt
    │    ├── sim_1
    │    │    ├── max_age_x
    │    │    │    └──images
    │    │    │        ├── snap_X.png
    │    │    │        ├── snap_Y.png
    │    │    │        └── ...
    │    │    └── ...
    │    ├── sim_2
    │    │    ├── max_age_x
    │    │    │    └──images
    │    │    │        ├── snap_X.png
    │    │    │        ├── snap_Y.png
    │    │    │        └── ...
    │    │    └── ...
    │    └── ...
    └── Kennicutt_Schmidt_at_max_sfr
         ├── sim_1
         │    ├── max_age_x.png
         │    ├── max_age_y.png
         │    └── ...
         ├── sim_2
         │    ├── max_age_x.png
         │    ├── max_age_y.png
         │    └── ...
         └── ...
    
  where sim_1, sim_2, etc. are the simulations, x, y, etc. are the age filters and
  X, Y, etc. are the snapshot numbers.
  
  Plots:
  - Kennicutt-Schmidt law (Σ_SFR vs. Σ_ρ), at approximately the time of maximum SFR, 
    for different age filters and simulations.
 =#

push!(LOAD_PATH, "../GADGETPlotting/src/")
using GADGETPlotting, Unitful, UnitfulAstro, Glob

"Path to the directory where the figures and animations will be saved."
const BASE_OUT_PATH = "../../plots/008"

"Path to the directory containing the simulations."
const BASE_SRC_PATH = "../../sim_data/results/isolated"

"""
The names of the directories containing the snapshot files, 
the base names of the files and the approximate time of maximum
SFR in units of 10Myr.
"""
const SNAPSHOTS = [
    "run_00" "snap" 60
    "run_old_model" "snap" 150
    "run_A_01" "snap" 150
    "run_G_01_tupac" "snap" 150
]

"""
Side dimension of the simulated region, with units, 
for the case of vacuum boundary conditions.
"""
const BOX_SIZE = 300UnitfulAstro.kpc

"""
Value of ComovingIntegrationOn: 
0 -> Newtonian simulation,
1 -> Cosmological simulation.
"""
const SIM_COSMO = 0

"""
Stellar age filters in Myr.
"""
const age_filters = [7, 10, 20, 60, 100, 200, 500]

simulations = String.(SNAPSHOTS[:, 1])
base_names = String.(SNAPSHOTS[:, 2])
max_sfr_times = Float64.(SNAPSHOTS[:, 3])

############################################################################################
# Kennicutt-Schmidt law (Σ_SFR vs. Σ_ρ), at approximately the time of maximum SFR, 
# for different age filters and simulations.
############################################################################################

for (simulation, base_name, max_sfr_time) in zip(simulations, base_names, max_sfr_times)

    # Path where the final images will be saved.
    final_out_path = mkpath(
        joinpath(
            BASE_OUT_PATH, 
            "Kennicutt_Schmidt_at_max_sfr", 
            simulation,
        ),
    )
    # Flag for finding the snapshot of maximum SFR. 
    found = false

    for age_filter in age_filters
        KennicuttSchmidtPipeline(
            base_name,
            joinpath(BASE_SRC_PATH, simulation),
            output_path = joinpath(
                BASE_OUT_PATH,
                "all_Kennicutt_Schmidt",
                simulation,
                "max_age_" * string(age_filter) * "Myr",
            ),
            sim_cosmo = SIM_COSMO,
            step = 5,
            temp_filter = Inf * Unitful.K,
            age_filter = age_filter * UnitfulAstro.Myr,
            max_r = BOX_SIZE,
            bins = ustrip(Int64, unit(BOX_SIZE), BOX_SIZE),
            time_unit = UnitfulAstro.yr,
        )

        if !found
            path = joinpath(
                BASE_OUT_PATH,
                "all_Kennicutt_Schmidt",
                simulation,
                "max_age_" * string(age_filter) * "Myr",
                "images",
            )

            # Get all the images for this `age_filter` and this `simulation`.
            files = glob("*.png", path)
        end

        # If it is the first time an output folder has images.
        if !found && !isempty(files)
            nums = map(x -> rsplit(x, ['.', '_']; limit = 3)[2], basename.(files))

            number = nums[max_sfr_time .- parse.(Int64, nums) .|> abs |> argmin]
            global target_filename = base_name * "_" * number * ".png"

            found = true
        end

        if found
            source = joinpath(
                BASE_OUT_PATH,
                "all_Kennicutt_Schmidt",
                simulation,
                "max_age_" * string(age_filter) * "Myr",
                "images",
                target_filename,
            )

            destination = joinpath(
                final_out_path, 
                "max_age_" * string(age_filter) * "Myr" * ".png",
            )

            # Copy images at the time of maximum SFR to the final output folder.
            cp(source, destination, force = true)
        end
    end
end

println("Work done!")