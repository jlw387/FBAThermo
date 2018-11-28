function Bounds(DF,TXTL)

  FB = DF["default_flux_bounds_array"]

  FB[195,2] = DF["Oxygen"]; #[]-> O2
  FB[207,2] = DF["GlcUptake"]; #[]-> GLC
  FB[211,2] = 0; #[]-> PYR
  println("Check1")
  i = 214
  for i = 214:217
    FB[i,2]= 0; #succ, Mal, fum, etoh, mglx
  end
  println("Check2")
  i = 112
  for i = 112:131
    FB[2*i,2] = DF["AAUptake"]; #AA UPTAKE
    FB[(2*i+1),2] = DF["AASecretion"]; #AA ->[]
  end
  println("Check3")
  FB[264,2] = 0; #ATP ->[]
  FB[265,2] = 0; #[]-> ADP
  AASyn = TXTL["AA_synthesis_rxn"]
  AADeg = TXTL["AA_degradation_rxn"]
  println("Check4")
  for i = AASyn[1]:AASyn[end]
    FB[i,2] = DF["AASyn"];
  end
  println("Check5")
  for i = AADeg[1]:AADeg[end]
    FB[i,2] = 0;
  end
  println("Check6")
#==============================================TXTL=====================================================#
  RNAP_concentration_nM = TXTL["RNAP_concentration_nM"];
  RNAP_elongation_rate = TXTL["RNAP_elongation_rate"];
  RIBOSOME_concentration = TXTL["RIBOSOME_concentration"];
  RIBOSOME_elongation_rate = TXTL["RIBOSOME_elongation_rate"];
  kd = TXTL["mRNA_degradation_rate"];
  mRNA_length = TXTL["mRNA_length"];
  protein_length = TXTL["protein_length"];
  gene_copies = TXTL["gene_copies"];
  volume = TXTL["volume"];
  polysome_amplification = TXTL["polysome_gain"];
  plasmid_saturation_coefficient = TXTL["plasmid_saturation_coefficient"];
  mRNA_saturation_coefficient = TXTL["mRNA_saturation_coefficient"];
  Promoter = TXTL["Promoter"]
  inducer = TXTL["inducer"]
#====================================Transcription===================================================#
  #Compute the promoter strength P -
  n = Promoter[1]
  KD = Promoter[2]
  K1 = Promoter[3]
  K2 = Promoter[4]
  K1_T7 = Promoter[5]
  f = inducer^n/(KD^n+inducer^n)
  if Promoter_model == 1
    P = (K1_T7)/(1+K1_T7)
  elseif Promoter_model == 2
    P = (K1+K2*f)/(1+K1+K2*f);
  end
  gene_concentration = gene_copies*(1e9/6.02e23)*(1/volume);
  saturation_term = (gene_concentration)/(plasmid_saturation_coefficient+gene_concentration);
  RNAP_concentration = RNAP_concentration_nM/1e6; #nM to mM
  TX = (RNAP_elongation_rate*(1/mRNA_length)*(RNAP_concentration)*(saturation_term)*3600)*P;

#====================================Translation===================================================#
  mRNA_steady_state = (TX/kd);
  translation_rate_constant = polysome_amplification*(3*RIBOSOME_elongation_rate)*(1/mRNA_length)*3600;
  TL = translation_rate_constant*RIBOSOME_concentration*mRNA_steady_state/(mRNA_saturation_coefficient+mRNA_steady_state);
#===================================================================================================#
  FB[167,1] = TX #transcriptional initiation
  FB[167,2] = TX #transcriptional initiation
  FB[169,1] = TX #transcriptional initiation
  FB[169,2] = TX #mRNA_degradation
  FB[170,2] = TL #translations initiation

  DF["default_flux_bounds_array"] = FB
  return DF
end
