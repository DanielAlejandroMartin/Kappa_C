# Kappa_C
Codes for the article "Finite-size correlation behavior near a critical point: a simple metric for monitoring the state of a neural network" by Eyisto J. Aguilar Trejo et al.

Simulations programmed mainly by Daniel A. Martin and Eyisto J. Aguilar Trejo, using gfortran and bash. Mouse brain activity download also requiered the use of modified jupyter-notebook algorithms.

Each computation requires several SIMPLE  codes.
We have left some already computed results to speed up user experience.

SIMULATIONS FOLDER/DIRECTORY
****************************

The first script to run is SCRIPT_Figs_1_to_4. It sould be run from a terminal (in GNU/linux, mac or on.a terminal emulator).
It runs all scripts and programs in order, to generate Figs 1 to 4. 
In generates the simulations in the folder "1-SIMULATION".  then it goes to this other folders:
"2A-ANALYSIS_CCF/", "2B-ANALYSIS_AVA/",  and "2C-ANALYSIS_AC1/", and computes CCF, avalanche analysis and AC(1) respectivelty.
Finaly, it goes to 3-Figures and generates the figures.

Scripts for Figure 5left and Figure 5 right are similar, the only changes are in the simulations (variable T for Fig. 5 left, Record all time steps for Fig. 5 right).

DATA ANALYSYS FOLDER/DIRECTORY
******************************
