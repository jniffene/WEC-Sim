format bank
a=cumsum(simout4.data*5e-4);a(end)
mech_en=a;
tt=find(abs(simout4.time-1000)<5e-4);
P_Ave=(mech_en(end)-mech_en(end-tt(1)))/simout4.time(tt(1));
Average_Mechanical_Power=P_Ave%*15^3.5

elec_pw=-simout.data.*simout1.data;
elec_en=cumsum(elec_pw*5e-4);elec_en(end)
PE_Ave=(elec_en(end)-elec_en(end-tt(1)))/simout4.time(tt(1));
Average_Elec_Power=PE_Ave%*15^3.5

% Emax=find(mech_en==max(mech_en));
% Emin=find(mech_en==min(mech_en));
% tmax=simout4.time(Emax)
% tmin=simout4.time(Emin)
% Pave_irr=(mech_en(Emax)-mech_en(Emin))/(tmax-tmin);
% disp(['Power average for irregular wave: ', num2str(Pave_irr)]);