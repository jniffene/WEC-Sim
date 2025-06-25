scale = 7.5; %15 for full scale, 7.5 for half scale and 5 for 1/3 scale
Ts=simu.dt;
%1/15 HIL scale
Ra=0.7;La=1.3e-3;tae=La/Ra;E_in=42;
In=8;
%Variable scale
% Ra=0.076;La=1.57e-3;tae=La/Ra;E_in=E_in*scale^1.75;
% In=In*scale^1.75;
sysac=tf([(E_in/In)/Ra],[tae 1]);
wci=100*2*pi; %Crossover frequency
j=sqrt(-1);
gwci=abs(evalfr(sysac,j*wci));
awci=angle(evalfr(sysac,j*wci))*180/pi;
phi_boosti=60;
Kboosti=tand(45+phi_boosti/2);
wzi=wci/Kboosti;
wpi=wci*Kboosti;
kci=wzi/gwci;
kii=kci;
kpi=kci/wzi;
syspi=kci*tf([1/wzi 1],[1 0])
syslpi=tf([1],[1/wpi 1])

