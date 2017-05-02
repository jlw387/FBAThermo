#================================= Yield =======================================#
OVNum = 2004; #CASP9 Carbon Number
CarbonNumIn = [6;1;3;6;4;4;3;5;5;2;6;6;6;6;5;9;5;3;4;11;9;5;];
CarbonNumOut = [OVNum;1;3;2;3;4;4;4;2;3;3;8;5;4;2;3;6;4;4;3;5;5;2;6;6;6;6;5;9;5;3;4;11;9;5;];

CarbonIn = Float64[]
CarbonOut = Float64[]
push!(CarbonIn,flux_array[207])#GLC
push!(CarbonIn,flux_array[208])#HCO3
append!(CarbonIn,flux_array[224:2:262]) #AA

push!(CarbonOut,flux_array[194]) # Protein
push!(CarbonOut,flux_array[196]) #CO2
push!(CarbonOut,flux_array[210]) #PYR
append!(CarbonOut,flux_array[212:1:223]) #Metabolite Byproducts
append!(CarbonOut,flux_array[225:2:263]) #AA

C_In = CarbonIn.*CarbonNumIn
C_Out = CarbonOut.*CarbonNumOut

Yield=C_Out[1]/sum(C_In[:,1])*100

#================================= Energy Efficiency ====================================#
#ATP produced per glucose
ATP_GLC =  (flux_array[12] + flux_array[18] + flux_array[45] + flux_array[55] + flux_array[68])/flux_array[1]

#Energy Efficiency (Translation rate * Translation cost + Transcription rate * Transcription cost)/(ATP Produced)
Efficiency = (flux_array[194]*1664+flux_array[168]*2502)/(flux_array[1]*ATP_GLC)*100

#================================= Productivity (uM/h) ====================================#
# Productivity (microM/h)
Productivity = flux_array[194]*1e3

#=========================================================================================#
println("CarbonYield (%) ="," ", Yield)
println("Efficiency (%)="," ", Efficiency)
println("Productivity (uM/h) ="," ", Productivity)
