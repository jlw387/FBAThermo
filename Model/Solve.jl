include("Include.jl")
include("Bounds.jl")
include("TXTLDictionary.jl")

# load the data dictionary -
data_dictionary = DataDictionary(0,0,0)
TXTL_dictionary = TXTLDictionary(0,0,0)

println("Dictionaries Set Up")

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

# solve the lp problem -
data_dictionary = Bounds(data_dictionary,TXTL_dictionary);
(objective_value, flux_array, dual_array, uptake_array, exit_flag) = FluxDriver(data_dictionary)
include("Performance.jl")
