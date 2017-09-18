include("Include.jl")
include("Bounds.jl")
include("TXTLDictionary.jl")

# load the data dictionary -
data_dictionary = DataDictionary(0,0,0)
TXTL_dictionary = TXTLDictionary(0,0,0)
number_of_fluxes = length(data_dictionary["default_flux_bounds_array"][:,1])
number_of_species = length(data_dictionary["species_bounds_array"][:,1])

#Set objective reaction
data_dictionary["objective_coefficient_array"][194] = -1;

#=============================Cases=========================================#
#Define case number
# 1 = Amino Acid Uptake & Synthesis
# 2 = Amino Acid Uptake w/o Synthesis
# 3 = Amino Acid Synthesis w/o Uptake
Case = 1
if Case == 1
  data_dictionary["AASyn"] = 100;
  data_dictionary["AAUptake"] = 30
  data_dictionary["AASecretion"] = 0;
end
if Case == 2
  data_dictionary["AASyn"] = 0;
  data_dictionary["AAUptake"] = 30
  data_dictionary["AASecretion"] = 0;
end
if Case == 3
  data_dictionary["AASyn"] = 100;
  data_dictionary["AAUptake"] = 0
  data_dictionary["AASecretion"] = 100;
end

#Set Promoter
#1 = T7 Promoter model
#2 = P70a Promoter model
Promoter_model = 1
#===========================================================================#

#Set Plasmid Dose (nM)
plasmid_concentration = 5;
volume = TXTL_dictionary["volume"]
gene_copy_number = (volume/1e9)*(6.02e23)*plasmid_concentration;
TXTL_dictionary["gene_copies"] = gene_copy_number

#Set Glucose and Oxygen (mM/h)
data_dictionary["GlcUptake"] = 30
data_dictionary["Oxygen"] = 100;

runs = 100
index = 1
flux_ensemble = zeros(number_of_fluxes,runs)
uptake_ensemble = zeros(number_of_species,runs)
while index <= runs
  TXTL_dictionary["RNAP_concentration_nM"] = 60 + (80-60)*rand(1)[1];
  TXTL_dictionary["RNAP_elongation_rate"] = 20 + (30-20)*rand(1)[1];
  TXTL_dictionary["RIBOSOME_concentration"] = 0.0012 + (0.0018-0.0012)*rand(1)[1];
  TXTL_dictionary["RIBOSOME_elongation_rate"] = 1.5 + (3-1.5)*rand(1)[1];
  # solve the lp problem -
  data_dictionary = Bounds(data_dictionary,TXTL_dictionary);
  (objective_value, flux_array, dual_array, uptake_array, exit_flag) = FluxDriver(data_dictionary)
  if exit_flag == 5
    flux_ensemble[:,index] = flux_array
    uptake_ensemble[:,index] = uptake_array
    index = index+1;
  end
end

flux_array = flux_ensemble
include("Performance.jl")
