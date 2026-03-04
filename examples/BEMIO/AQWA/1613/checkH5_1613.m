% h5disp('raftL=40D=10.h5')
g = 9.81; % gravity

% Get density
rho = h5read('raftL=40D=10.h5','/simulation_parameters/rho');
K_h1 = g*rho* h5read('raftL=40D=10.h5','/body1/hydro_coeffs/linear_restoring_stiffness');
K_h2 = g*rho* h5read('raftL=40D=10.h5','/body2/hydro_coeffs/linear_restoring_stiffness');


