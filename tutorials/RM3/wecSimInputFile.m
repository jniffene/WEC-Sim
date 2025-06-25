Ls=15;                                  %Length scale
scale=1;
%Changes needed for new Ls:
%1. Save the new excitation force profiles for body1 and body2
%2. Adjust torque constant and other machine parameters in Simulink model
%3. Switch to new hydroData folder
%4. Tune PI parameters (smaller I gain for the current/torque controller for full scale)
%5. Modify I_cont_design.m and S_cont_design.m with new machines parameters
Tsc=Ls^0.5;                              %Time scale%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'RM3_hwil2c_PI_test_desalv6.slx';      % Specify Simulink Model File
simu.mode = 'accelerator';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer='on';                     % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 250/Tsc;                   	% Wave Ramp Time [s] 250s for irregular wave and 100s for regular wave
simu.endTime= 1500/Tsc;                       % Simulation End Time [s] 1500s for irregular wave and 400s for regular wave
simu.solver = 'ode45';                   % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 5e-4; 							% Simulation time-step [s] 5e-3 with regular, 10e-3 with irregular, 5e-4 for numerical model
%simu.cicEndTime = 30/Tsc;
simu.cicEndTime = 60/Tsc;
simu.stateSpace = 1;   

% simu_slr = 0.5;                                   % Slider crank radius
% simu_sll = 7.5;                                     % Slider crank arm length
% simu_sla = 1.537456817533593
% simu_slr = 1;                                   % Slider crank radius
% simu_sll = 7.5;                                     % Slider crank arm length
% simu_sla = 1.504080178384672
% simu_slr = 1.5;                                   % Slider crank radius
% simu_sll = 7.5;                                   % Slider crank arm length
% simu_sla = 1.470628905633338;
% simu_slr = 2.0;                                  % Slider crank radius
% simu_sll = 5;                                % Slider crank arm length
% simu_sla = 1.369438406004585;
% simu_slr = 2.0;                                  % Slider crank radius
% simu_sll = 7.5;                                % Slider crank arm length
% simu_sla = 1.437064737384947;                  % This is for r=2 and l=7.5m: Slider crank initial angle in radians: it should be calculated using Theta_initial=Initial_Angle_Solver(r,l,l);
% simu_slr = 2.0;                                  % Slider crank radius
% simu_sll = 10;                                % Slider crank arm length
% simu_sla = 1.470628905633338;
% simu_slr = 2.5;                                  % Slider crank radius
% simu_sll = 7.5;                                % Slider crank arm length
% simu_sla = 1.403348247575250;                  % This is for r=2.5 and l=7.5m: Slider crank initial angle in radians: it should be calculated using Theta_initial=Initial_Angle_Solver(r,l,l);

% simu_slr = 0.5;                                   % Slider crank radius
% simu_sll = 5;                                     % Slider crank arm length
% simu_sla = 1.520775469989128
% simu_slr = 1;                                   % Slider crank radius
% simu_sll = 5;                                     % Slider crank arm length
% simu_sla = 1.470628905633338
% simu_slr = 1.5;                                   % Slider crank radius
% simu_sll = 5;                                   % Slider crank arm length
% simu_sla = 1.420228054018215;
% simu_slr = 1.5;                                   % Slider crank radius
% simu_sll = 10;                                   % Slider crank arm length
% simu_sla = 1.495725835718180
simu_slr = 1.5;                                   % Slider crank radius
simu_sll = 7;                                   % Slider crank arm length
simu_sla = Initial_Angle_Solver(simu_slr,simu_sll,simu_sll);
% simu_slr = 1.5;                                   % Slider crank radius
% simu_sll = 2.5;                                   % Slider crank arm length
% simu_sla = 1.266103672779448

%% Wave Information 
% % noWaveCIC, no waves with radiation CIC  
% waves = waveClass('noWaveCIC');       % Initialize Wave Class and Specify Type  

% Regular Waves  
% waves = waveClass('regular');           % Initialize Wave Class and Specify Type                                 
% waves.height = 2.5/Ls;                          % Wave Height [m]
% waves.period = 8/Tsc;                            % Wave Period [s]

% % Regular Waves with CIC
% waves = waveClass('regularCIC');           % Initialize Wave Class and Specify Type                                 
% waves.height = 2.5;                          % Wave Height [m]
% waves.period = 8;                            % Wave Period [s]

% % Irregular Waves using PM Spectrum 
% waves = waveClass('irregular');         % Initialize Wave Class and Specify Type
waves.height = scale*2.6/Ls;
waves.period = sqrt(scale)*12/Tsc;
% waves.spectrumType = 'PM';              % Specify Wave Spectrum Type

%Irregular Waves using JS Spectrum with Equal Energy and Seeded Phase
waves = waveClass('irregular');         % Initialize Wave Class and Specify Type
waves.height = scale*3.6/Ls;
waves.period = sqrt(scale)*7/Tsc;
waves.spectrumType = 'JS';              % Specify Wave Spectrum Type
waves.bem.option = 'EqualEnergy';         % Uses 'EqualEnergy' bins (default) 
waves.phaseSeed = 1;                    % Phase is seeded so eta is the same
waves.bem.count = 35;                     % Number of components

% % Irregular Waves using PM Spectrum with Traditional and State Space 
% waves = waveClass('irregular');         % Initialize Wave Class and Specify Type
% waves.height = 2.5;                          % Significant Wave Height [m]
% waves.period = 8;                            % Peak Period [s]
% waves.spectrumType = 'PM';              % Specify Wave Spectrum Type
% simu.stateSpace = 1;                        % Turn on State Space
% waves.bem.option = 'Traditional';         % Uses 1000 frequnecies

% % Irregular Waves with imported spectrum
% waves = waveClass('spectrumImport');        % Create the Wave Variable and Specify Type
% waves.spectrumDataFile = 'spectrumData.mat';  %Name of User-Defined Spectrum File [:,2] = [f, Sf]

% % Waves with imported wave elevation time-history  
% waves = waveClass('etaImport');         % Create the Wave Variable and Specify Type
% waves.etaDataFile = 'etaData.mat'; % Name of User-Defined Time-Series File [:,2] = [time, eta]

%% Body Data
% Float
body(1) = bodyClass('hydroData/rm3.h5');      
    %Create the body(1) Variable, Set Location of Hydrodynamic Data File 
    %and Body Number Within this File.   
body(1).geometryFile = 'geometry/float.stl';    % Location of Geomtry File
body(1).mass = 'equilibrium';                   
    %Body Mass. The 'equilibrium' Option Sets it to the Displaced Water 
    %Weight.
body(1).inertia = 1/Ls^5*[20907301 21306090.66 37085481.11];  %Moment of Inertia [kg*m^2]   
%body(1).centerGravity = [0 0 -0.72];
body(1).quadDrag.cd=[1 0 1 0 1 0];
body(1).quadDrag.area=[20*3*(1/Ls^2) 0*(1/Ls^2)  pi*10^2*(1/Ls^2) 0*(1/Ls^5) pi*10^5*(1/Ls^5) 0*(1/Ls^5)];

% Spar/Plate
body(2) = bodyClass('hydroData/rm3.h5'); 
body(2).geometryFile = 'geometry/plate.stl'; 
body(2).mass = 'equilibrium';                   
body(2).inertia = 1/Ls^5.*[94419614.57 94407091.24 28542224.82];
%body(1).centerGravity = [0;0;-21.29];
body(2).quadDrag.cd=[4 0 4 0 4 0];
body(2).quadDrag.area=[20*3*(1/Ls^2) 0*(1/Ls^2)  pi*10^2*(1/Ls^2) 0*(1/Ls^5) pi*10^5*(1/Ls^5) 0*(1/Ls^5)];

body(3) = bodyClass(''); 
    body(3).geometryFile = 'geometry/float.stl';
    body(3).nonHydro          = 1;                    % Turn non-hydro body on
    body(3).name            = 'Crank';   
    body(3).mass            = 1/Ls^3.*10;                   
    %body(3).inertia = [1e5 1e5 1e5];
    body(3).inertia    = [2e5 8e5 2e5]/(1*Ls^5);
    body(3).volume         = 0;                    % Specify Displaced Volume  
%    body(3).centerGravity              = [0 0 9];              % Specify Cg 
%    body(3).centerGravity              = 1./Ls.*[1.21 0 3.9675];      % Specify Cg for r=2.5m, l=5m
    body(3).centerGravity              = 1./Ls.*[0.5*simu_slr*sin(simu_sla)  0  simu_sll - 0.5*simu_slr*cos(simu_sla) - 0.72];
    
body(4) = bodyClass(''); 
    body(4).geometryFile = 'geometry/float.stl';
    body(4).nonHydro          = 1;                    % Turn non-hydro body on
    body(4).name            = 'Arm';   
    body(4).mass            = 1/Ls^3.*10;                   
    body(4).inertia    = 1/Ls^5.*[1 1 1];
    body(4).volume         = 0;                    % Specify Displaced Volume  
%    body(4).centerGravity              = [2.18 0 4.5];              % Specify Cg     
%    body(4).centerGravity              = 1./Ls.*[1.21 0 1.4675];              % Specify Cg for r=2.5m, l=5m
    body(4).centerGravity              = 1./Ls.*[0.5*simu_slr*sin(simu_sla)  0  0.5*simu_sll*cos(pi-2*simu_sla) - 0.72];
    
%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); % Initialize Constraint Class for Constraint1
constraint(1).location = 1./Ls.*[0 0 -60];                    % Constraint Location [m]
constraint(2) = constraintClass('Constraint2'); % Initialize Constraint Class for Constraint1
constraint(2).location = 1./Ls.*[0 0 -0.72];                    % Constraint Location [m]
constraint(3) = constraintClass('Constraint3'); % Initialize Constraint Class for Constraint1
%constraint(3).location = [4.359 0 9];                    % Constraint Location [m]
%constraint(3).location = 1./Ls.*[2.4206 0 3.655];                    % Constraint Location [m] for r=2.5m, l=5m
constraint(3).location = 1./Ls.*[simu_slr*sin(simu_sla)  0  simu_sll - simu_slr*cos(simu_sla) - 0.72];
constraint(4) = constraintClass('Constraint4'); % Initialize Constraint Class for Constraint1
constraint(4).location = 1./Ls.*[0 0 -0.72];                    % Constraint Location [m]
mooring(1)=mooringClass('Mooring1');
mooring(1).location=1./Ls.*[0 0 -10];
mooring(1).matrix.stiffness(1,1)=1e5*(15/Ls)^2;
mooring(1).matrix.stiffness(2,2)=0;
mooring(1).matrix.stiffness(3,3)=1e5*(15/Ls)^2;


% Translational PTO
pto(1) = ptoClass('PTO1');                      % Initialize PTO Class for PTO1
pto(1).stiffness = 0/Ls^2;                                   % PTO Stiffness [N/m]
pto(1).damping = 0;   3872/Ls^2.5;%1000000;                             % PTO Damping [N/(m/s)]
%pto(1).location = 1./Ls.*[0 0 4.28];                           % PTO Location [m]
pto(1).location = 1./Ls.*[0 0 simu_sll - 0.72];
