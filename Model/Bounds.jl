function Bounds(DF,TXTL)

  FB = DF["default_flux_bounds_array"]
  FB[2,1] = 0.01
  FB[31,1] = 0.01
  FB[44,1] = 0.01
  FB[48,1] = 0.01
  FB[50,1] = 0.01
  FB[195,2] = DF["Oxygen"]; #[]-> O2
  FB[207,2] = DF["GlcUptake"]; #[]-> GLC
  FB[211,2] = 0; #[]-> PYR
  i = 214
  for i = 214:217
    FB[i,2]= 0; #succ, Mal, fum, etoh, mglx
  end
  i = 112
  for i = 112:131
    FB[2*i,2] = DF["AAUptake"]; #AA UPTAKE
    FB[(2*i+1),2] = DF["AASecretion"]; #AA ->[]
  end
  FB[264,2] = 0; #ATP ->[]
  FB[265,2] = 0; #[]-> ADP
  AASyn = TXTL["AA_synthesis_rxn"]
  AADeg = TXTL["AA_degradation_rxn"]
  for i = AASyn[1]:AASyn[end]
    FB[i,2] = DF["AASyn"];
  end
  for i = AADeg[1]:AADeg[end]
    FB[i,2] = 100;
  end

  #Set up Kcat-Derived Bounds
  FB[2,2] = 568.548;
  FB[3,2] = 568.548;
  FB[4,2] = 67.32;
  FB[5,2] = 1.53;
  FB[6,2] = 5.0184;
  FB[7,2] = 5.0184;
  FB[8,2] = 446.76;
  FB[9,2] = 446.76;
  FB[10,2] = 42.84;
  FB[11,2] = 42.84;
  FB[14,2] = 324.36;
  FB[15,2] = 324.36;
  FB[16,2] = 47.736;
  FB[17,2] = 47.736;
  FB[18,2] = 138.312;
  FB[19,2] = .41004;
  FB[20,2] = 330.48;
  FB[21,2] = 23.1948;
  FB[22,2] = .29376;
  FB[23,2] = 37.944;
  FB[24,2] = 37.944;
  FB[26,2] = 13.5252;
  FB[27,2] = 532.44;
  FB[28,2] = 532.44;
  FB[31,2] = 7.956;
  FB[32,2] = 7.956;
  FB[33,2] = 12.852;
  FB[34,2] = 12.852;
  FB[35,2] = 42.228;
  FB[36,2] = 42.228;
  FB[40,2] = 3.2436;
  FB[41,2] = 3.2436;
  FB[42,2] = 65.1168;
  FB[43,2] = 65.1168;
  FB[44,2] = 309.672;
  FB[45,2] = 11.9952;
  FB[47,2] = 153;
  FB[48,2] = 703.8;
  FB[49,2] = 703.8;
  FB[50,2] = 195.84;
  FB[51,2] = 195.84;

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
