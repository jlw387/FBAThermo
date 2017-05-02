## Sequence Specific Flux Balance Analysis (ssFBA) for Cell-Free Protein Synthesis
ssFBA is a sequence specific constraint based model for static stoichiometric models (SSM) written in the [Julia](http://julialang.org) programming language.
SSM models were created with JuNQC-Generator (https://github.com/varnerlab/JuNQC-Generator).
The code uses the GLPK solver to solve the metabolic flux balance analysis program.

### Installation and Requirements
You can download this repository as a zip file, or clone or pull it by using the command (from the command-line):

	$ git pull https://github.com/varnerlab/Sequence-Specific-FBA-CFPS-Publication-Code.git

or

	$ git clone https://github.com/varnerlab/Sequence-Specific-FBA-CFPS-Publication-Code.git

Julia must be installed on your machine along with [GLPK](https://github.com/JuliaOpt/GLPK.jl) linear programming solver. Julia can be downloaded/installed on any platform. To install the GLPK program issue the command:

  	julia> Pkg.add("GLPK")

in the Julia REPL.

### Running the model
To run the model, first copy the files from the protein folder you wish to simulate and paste them into the ``Model`` folder. Set the directory to the ``Model`` folder and issue the command ``include("Solve.jl")`` in the Julia REPL.

The ``Solve.jl`` script has several user inputs available:

Variable | User Input | Description
--- | --- | ---
Case | 1 = Amino Acid Uptake & Synthesis, 2 = Amino Acid Uptake w/o Synthesis, 3 = Amino Acid Synthesis w/o Uptake | Set the case to simulate
Promoter_model	| 1 = T7 promoter model, 2 = P70a promoter model | Set the promoter model
plasmid_concentration	| default = 5, plasmid concentration is in nM | Set plasmid concentration of the protein of interest to be expressed

The script gives several outputs:

Output | Description
--- | ---
objective__value | The objective value of the reaction set to be optimized. The default is set to optimize the export of the protein of interest
flux_array | The flux distribution throughout the network. The reaction index can be looked up in Debug.txt
dual_array | Shadow cost
uptake_array | Species array
exit_flag | Status of glpk solver. Solution undefined = 1, solution is feasible = 2, problem has no feasible solution = 4, solution is optimal = 5
(objective_value, flux_array, dual_array, uptake_array, exit_flag)


#### What each file does

file | description
--- | ---
DataDictionary.jl | Encodes the species and reaction bounds arrays and the objective array. Data is stored in a [Julia dictionary](http://docs.julialang.org/en/stable/stdlib/collections/?highlight=dict#Base.Dict) type and can be accessed through the appropriate key.
Debug.txt | List of reactions and species used to generate the model code.
FluxDriver.jl | Julia interface with the [GLPK](https://github.com/JuliaOpt/GLPK.jl) solver. Users should `NEVER, UNDER ANY CIRCUMSTANCES, EVER` edit this file.
Include.jl | Encodes all the include statements for the project. Should be included at the top of top-level driver scripts.
Network.dat | Stoichiometric array for the model.
Solve.jl | Default top-level driver implementation.
Bounds.jl | Updates the species and reaction bounds and sets the transcription and translation rates.
TXTLDictionary.jl | Encodes the cell-free protein synthesis parameters. Data is stored in a [Julia dictionary](http://docs.julialang.org/en/stable/stdlib/collections/?highlight=dict#Base.Dict) type and can be accessed through the appropriate key.
Performance.jl | Evaluates the carbon yield, energy efficiency, and productivity of a protein of interest.
