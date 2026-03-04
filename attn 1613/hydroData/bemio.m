% clc; clear all; close all;
clc
%% hydro data
hydro = struct();
hydro = readAQWA(hydro, 'raftL=40D=10.AH1', 'raftL=40D=10.LIS');
% hydro = Read1_AQWA(hydro, 'raftL=40D=10.AH1', 'raftL=40D=10.LIS');
hydro = radiationIRF(hydro,150,[],[],[],1.8);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,150,[],[],[],1.8);
writeBEMIOH5(hydro)

%% Plot hydro data
plotBEMIO(hydro)
