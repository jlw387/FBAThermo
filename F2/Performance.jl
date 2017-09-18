#F2
#================================= Energy Efficiency ====================================#
#ATP produced
ATP =  flux_array[12,:] + flux_array[18,:] + flux_array[45,:] + flux_array[55,:] + flux_array[68,:] + flux_array[102,:] + flux_array[109,:]

#Energy Efficiency (Translation rate * Translation cost + Transcription rate * Transcription cost)/(ATP Produced)
Efficiency = (flux_array[194,:]*2488+flux_array[168,:]*4112)./(ATP)*100

#================================= Productivity (uM/h) ====================================#
# Productivity (microM/h)
Productivity = flux_array[194,:]*1e3

#=========================================================================================#
if length(Efficiency) > 1
  println("Efficiency (%) ="," ", mean(Efficiency)," ","+/-"," ",std(Efficiency))
  println("Productivity (uM/h) ="," ", mean(Productivity)," ","+/-"," ",std(Productivity))
else
  println("Efficiency (%) ="," ", mean(Efficiency))
  println("Productivity (uM/h) ="," ", mean(Productivity))
end
