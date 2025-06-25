scale = 15;
kps =   2.416610534077343;
kis =    8.918629091342887e+02;
wps =  5.241606063936498e+02;
%1/15 Scale Machine
B=1.79e-4;J=5e-4;tae=J/B;kt=0.091;wb=1;Nn=4000;
%Full Scale Machine
%B=B*scale^3.5;J=J*scale^5;tae=J/B;kt=kt*scale^1.75;wb=1;Nn=4000;
sysid=tf([kt/wb],[J B]);
wcs=70*2*pi; %Crossover frequency
j=sqrt(-1);
gwcs=abs(evalfr(sysid,j*wcs));
awcs=angle(evalfr(sysid,j*wcs))*180/pi;
phi_boosts=10;
Kboosts=tand(45+phi_boosts/2);
wzs=wcs/Kboosts;
wps=wcs*Kboosts;
kcs=wzs/gwcs;
kis=kcs;
kps=kcs/wzs;
% syspis=kcs*tf([1/wzs 1],[1 0])
syslpc=tf([1],[1/wps 1]);
syslpd=c2d(syslpc,Ts);
[numd, dend]=tfdata(syslpd);
numd=numd{1};
dend=dend{1};
