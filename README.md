# Kappa_C
Codes for the article "Finite-size correlation behavior near a critical point: a simple metric for monitoring the state of a neural network" by Eyisto J. Aguilar Trejo et al.

Simulations programmed mainly in gfortran and bash. Mouse brain activity download also requiered the use of modified jupyter-notebook algorithms and speciffic packages.

Each computation requires several simple  codes.
We have left some already computed results to ease code check.

SIMULATIONS FOLDER/DIRECTORY
****************************

The first script to run is SCRIPT_Figs_1_to_4. It sould be run from a terminal (in GNU/linux, mac or on.a terminal emulator).
It runs all scripts and programs in order, to generate Figs 1 to 4. 
In generates the simulations in the folder "1-SIMULATION".  then it goes to this other folders:
"2A-ANALYSIS_CCF/", "2B-ANALYSIS_AVA/",  and "2C-ANALYSIS_AC1/", and computes CCF, avalanche analysis and AC(1) respectivelty.
Finaly, it goes to 3-Figures and generates the figures.

Scripts for Figure 5 left and Figure 5 right are similar, the only changes are in the simulations (variable T for Fig. 5 left, Record all time steps for Fig. 5 right).

DATA_ANALYSIS FOLDER/DIRECTORY
******************************

First, we should download files from Allen database. To do so, you should run "jupyter-notebook DownloadFiles.ipynb" on 1-AllenDownload folder.
Before that, allensdk tools have to be installed. To work properly, the allensdk has to run on python 3.8 or less (it does not work on python 3.9).
You may generate a conda enviroenment to run an older version. 

After running, you will download Spike data (Sp.txt), neuron positions (coords.txt), and stimulus info (Static.txt and Nscenes.txt). They are saved in the folder "Files" (you should create it).

Then go to "Analysis" folder, and run the following scripts: "ScriptRunFig6" and "ScriptRunFig7". 
Go to "AnalysisResponses_Fig8" folder, and run: "ScriptRunFig8". 

Finally, go to "3-Figures" and run
gnuplot GnuFig6	
gnuplot GnuFig7
gnuplot GnuFig8
