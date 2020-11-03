%% Vibrating Cantilevered Beam
% Author: K. Heidi Fehr

%% Knowns
globalZero = [0;0;0]; % Center of beam, (u,v,w)
L = 0.5; %m
H = 0.003; %m
W = 0.003; %m
g = [0;0;-9.81]; %m/s
E = 2e11; %Pa
rho = 7700; % density, kg/m^3
nu = 0.3; %poissons ratio
k1 = 10*((1+nu)/(12+11*nu));
k2 = k1;

%% Initial calculations
r1 = [-0.25;0;0]; %r(j)
r2 = [0.25;0;0]; %r(j+1)

% For node 1:
xi = (2*r1(1))/L; %slide 21-26
eta = (2*r1(2))/W;
zeta = (2*r1(3))/H;

%% Part a) Shape function in normalized coordinates

% Slide 22-38
S_xiXi_1 = (3/4)*(xi^2-1);
S_xiXi_2 = (L/8)*(3*xi^2-2*xi-1);
S_xiXi_3 = -(H*eta)/4;
S_xiXi_4 = -(W*zeta)/4;
S_xiXi_5 = (3/4)*((-xi^2) + 1);
S_xiXi_6 = (L/8)*(3*(xi^2) + 2*xi - 1);
S_xiXi_7 = H*eta/4;
S_xiXi_8 = W*zeta/4;


