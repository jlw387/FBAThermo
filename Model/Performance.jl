#deGFP
#================================= Energy Efficiency ====================================#
#ATP produced
ATP =  flux_array[12,:] + flux_array[18,:] + flux_array[45,:] + flux_array[55,:] + flux_array[68,:] + flux_array[102,:] + flux_array[109,:]

#Energy Efficiency (Translation rate * Translation cost + Transcription rate * Transcription cost)/(ATP Produced)
Efficiency = (flux_array[194,:]*900+flux_array[168,:]*1356)./(ATP)*100

#================================= Productivity (uM/h) ====================================#
# Productivity (microM/h)
Productivity = flux_array[194,:]*1e3

println("Reaction: PGI\t Expected: "*string(127.4/67.9)*"\t Actual: "*string(flux_array[2]/flux_array[3]))
println("Reaction: PFK\t Expected: "*string(66.0/3.1)*"\t Actual: "*string(flux_array[4]/flux_array[5]))
println("Reaction: FBA\t Expected: "*string(117.5/54.6)*"\t Actual: "*string(flux_array[6]/flux_array[7]))
println("Reaction: TPI\t Expected: "*string(236.7/174.4)*"\t Actual: "*string(flux_array[8]/flux_array[9]))
println("Reaction: RPE\t Expected: "*string(124.7/120.9)*"\t Actual: "*string(flux_array[27]/flux_array[28]))
println("Reaction: RPI\t Expected: "*string(5030.9/5038.7)*"\t Actual: "*string(flux_array[29]/flux_array[30]))
println("Reaction: TAL\t Expected: "*string(3.3/0.4)*"\t Actual: "*string(flux_array[31]/flux_array[33]))
println("Reaction: TKT1\t Expected: "*string(19.9/17.1)*"\t Actual: "*string(flux_array[33]/flux_array[34]))
println("Reaction: TKT2\t Expected: "*string(2.0/1.1)*"\t Actual: "*string(flux_array[35]/flux_array[36]))
println("Reaction: AKGDH\t Expected: "*string(19.5/1.8)*"\t Actual: "*string(flux_array[44]/flux_array[45]))
println("Reaction: FUM\t Expected: "*string(5615.6/5597.4)*"\t Actual: "*string(flux_array[48]/flux_array[49]))
println("Reaction: MDH\t Expected: "*string(105.2/86.3)*"\t Actual: "*string(flux_array[50]/flux_array[51]))

#=========================================================================================#
if length(Efficiency) > 1
  println("Efficiency (%) ="," ", mean(Efficiency)," ","+/-"," ",std(Efficiency))
  println("Productivity (uM/h) ="," ", mean(Productivity)," ","+/-"," ",std(Productivity))
else
  println("Efficiency (%) ="," ", mean(Efficiency))
  println("Productivity (uM/h) ="," ", mean(Productivity))
end
