%% Vibrating Cantilevered Beam
% Author: K. Heidi Fehr

%% Knowns
globalZero = [0;0;0]; % Center of beam, (u,v,w)
L = 0.5; %m
H = 0.003; %m
W = 0.003; %m
g = [0;0;-9.81]; %m/s
youngsM = 2e11; %Pa
rho = 7700; % density, kg/m^3
nu = 0.3; %poissons ratio
k1 = 10*((1+nu)/(12+11*nu));
k2 = k1;

%% Initial calculations
r1 = [0;0;0]; %r(j)
r2 = [0.5;0;0]; %r(j+1)

% (u,v,w)
p1 = [-0.25;0;0]; %r(j)
r2 = [0.25;0;0]; %r(j+1)

% For node 1:
xi = (2*p1(1))/L; %slide 21-26
eta = (2*p1(2))/W;
zeta = (2*p1(3))/H;

%% Part a) Shape function in normalized coordinates
% Slide 22-38
S_xiXi(1) = (3/4)*(xi^2-1);
S_xiXi(2) = (L/8)*(3*xi^2-2*xi-1);
S_xiXi(3) = -(H*eta)/4;
S_xiXi(4) = -(W*zeta)/4;
S_xiXi(5) = (3/4)*((-xi^2) + 1);
S_xiXi(6) = (L/8)*(3*(xi^2) + 2*xi - 1);
S_xiXi(7) = H*eta/4;
S_xiXi(8) = W*zeta/4;

S_xiXi_all = [
    S_xiXi(1)*eye(3);
    S_xiXi(2)*eye(3);
    S_xiXi(3)*eye(3);
    S_xiXi(4)*eye(3);
    S_xiXi(5)*eye(3);
    S_xiXi(6)*eye(3);
    S_xiXi(7)*eye(3);
    S_xiXi(8)*eye(3)].';

%% Part b) 

% e0  
% Undeformed initial position:
clear
L = 0.5; %m
H = 0.003; %m
W = 0.003; %m
g = [0;0;-9.81]; %m/s
youngsM = 2e11; %Pa
poissonsR = 0.3;
rho = 7700; % density, kg/m^3
nu = 0.3; %poissons ratio
k1 = 10*((1+nu)/(12+11*nu));
k2 = k1;
k3 = k2;

r1 = [0;0;0]; %r(j)
r2 = [0.5;0;0]; %r(j+1)
r1_u = [1;0;0];
r1_j = [0;1;0];
r1_w = [0;0;1];
r2_u = [1;0;0];
r2_j = [0;1;0];
r2_w = [0;0;1];

e1 = [r1;r1_u;r1_j;r1_w];
e2 = [r2;r2_u;r2_j;r2_w];
e0 = [e1;e2];

%%% Shape functions, but symbolic:
syms xi eta zeta
% Slide 22-38
Sym_xi(1) = (1/4)*((xi^3)-(3*xi)+2);
Sym_xi(2) = (L/8)*((xi^3)-(xi^2)-(xi)+1);
Sym_xi(3) = ((H*eta)/4)*(-xi+1);
Sym_xi(4) = ((W*zeta)/4)*(-xi+1);
Sym_xi(5) = (1/4)*((-xi^3)+(3*xi)+2);
Sym_xi(6) = (L/8)*((xi^3)+(xi^2)-(xi)-1);
Sym_xi(7) = ((H*eta)/4)*(xi+1);
Sym_xi(8) = ((W*zeta)/4)*(xi+1);

Sym_xi_all = [
    Sym_xi(1)*eye(3);
    Sym_xi(2)*eye(3);
    Sym_xi(3)*eye(3);
    Sym_xi(4)*eye(3);
    Sym_xi(5)*eye(3);
    Sym_xi(6)*eye(3);
    Sym_xi(7)*eye(3);
    Sym_xi(8)*eye(3)].';

Sym_xiXi(1) = (3/4)*((xi^2)-1);
Sym_xiXi(2) = (L/8)*(3*(xi^2)-2*xi-1);
Sym_xiXi(3) = -(H*eta)/4;
Sym_xiXi(4) = -(W*zeta)/4;
Sym_xiXi(5) = (3/4)*((-xi^2) + 1);
Sym_xiXi(6) = (L/8)*(3*(xi^2) + 2*xi - 1);
Sym_xiXi(7) = H*eta/4;
Sym_xiXi(8) = W*zeta/4;

Sym_xiXi_all = [
    Sym_xiXi(1)*eye(3);
    Sym_xiXi(2)*eye(3);
    Sym_xiXi(3)*eye(3);
    Sym_xiXi(4)*eye(3);
    Sym_xiXi(5)*eye(3);
    Sym_xiXi(6)*eye(3);
    Sym_xiXi(7)*eye(3);
    Sym_xiXi(8)*eye(3)].';

Sym_xiEta = sym('Sym_xiEta', [3 24]);

Sym_xiEta(1) = 0;
Sym_xiEta(2) = 0;
Sym_xiEta(3) = (H/4)*(-xi+1);
Sym_xiEta(4) = 0;
Sym_xiEta(5) = 0;
Sym_xiEta(6) = 0;
Sym_xiEta(7) = (H/4)*(xi+1);
Sym_xiEta(8) = 0;

Sym_xiEta_all = [
    Sym_xiEta(1)*eye(3);
    Sym_xiEta(2)*eye(3);
    Sym_xiEta(3)*eye(3);
    Sym_xiEta(4)*eye(3);
    Sym_xiEta(5)*eye(3);
    Sym_xiEta(6)*eye(3);
    Sym_xiEta(7)*eye(3);
    Sym_xiEta(8)*eye(3)].';

Sym_xiZeta = sym('Sym_xiZeta', [3 24]);

Sym_xiZeta(1) = 0;
Sym_xiZeta(2) = 0;
Sym_xiZeta(3) = 0;
Sym_xiZeta(4) = (W/4)*(-xi+1);
Sym_xiZeta(5) = 0;
Sym_xiZeta(6) = 0;
Sym_xiZeta(7) = 0;
Sym_xiZeta(8) = (W/4)*(xi+1);

Sym_xiZeta_all = [
    Sym_xiZeta(1)*eye(3);
    Sym_xiZeta(2)*eye(3);
    Sym_xiZeta(3)*eye(3);
    Sym_xiZeta(4)*eye(3);
    Sym_xiZeta(5)*eye(3);
    Sym_xiZeta(6)*eye(3);
    Sym_xiZeta(7)*eye(3);
    Sym_xiZeta(8)*eye(3)].';

clear Sym_xiXi_all Sym_xiEta_all Sym_xiZeta_all
Sym_xiXi_all = diff(Sym_xi_all,xi);

Sym_xiEta_all = diff(Sym_xi_all,eta);

Sym_xiZeta_all = diff(Sym_xi_all,zeta);

%%% Matrix to be normalized:
J0 = [Sym_xiXi_all*e0, Sym_xiEta_all*e0, Sym_xiZeta_all*e0];
N = det(J0);
%%% Expression to integrate:
% limits
% rho = 1;
a = -1;
b = 1;
f = rho*(Sym_xi_all.')*Sym_xi_all*N;
% integrals
M = int(f,zeta,a,b);
M = int(M,eta,a,b);
M = int(M,xi,a,b);

%% Part C) Generalized Force Vector due to Gravity

% Function slide 21-35
F_grav = g;
f = rho*(Sym_xi_all.')*F_grav*N;
a = -1;
b = 1;
% integrals
Q_g = int(f,zeta,a,b);
Q_g = int(Q_g,eta,a,b);
Q_g = int(Q_g,xi,a,b);

%% Part D) Internal Force Vector
% Given in the exercise:
e = [0,0,0,1,0,0,0,1,0,0,0,1,...
    0.5,0,0,...
    0,0,-1,...
    0,1,0,1,0,0].';
r = Sym_xi_all*e;
r0 = Sym_xi_all*e0;

%Deformation Gradient Tensor, 22-39
F = [Sym_xiXi_all*e, Sym_xiEta_all*e, Sym_xiZeta_all*e]*inv(J0);

%Cauchy-Green Deformation Tensor 22-40
C = F.'*F;

%Green-Lagrange Strain Tensor, 22-41
E = 0.5*(C-eye(3));
%E in vector form:
epsilon = [E(1,1), E(2,2), E(3,3), 2*E(2,3), 2*E(1,3), 2*E(1,2)].';

%Elasticity Matrix, 22-46
D = ((poissonsR*nu)/((1+nu)*(1-2*nu)))*...
    [
    (1-nu)/nu,1,1,0,0,0;
    1,(1-nu)/nu,1,0,0,0;
    1,1,(1-nu)/nu,0,0,0;
    0,0,0,(1-2*nu)/(2*nu),0,0;
    0,0,0,0,((1-2*nu)/(2*nu))*k2,0;
    0,0,0,0,0,((1-2*nu)/(2*nu))*k3];

%Strain Energy - U Linear Hookean, 22-44
f = epsilon.'*D*epsilon;
a = -1;
b = 1;
% integrals
ULH = int(f,zeta,a,b);
ULH= int(ULH,eta,a,b);
ULH = 0.5*int(ULH,xi,a,b);

%Q Linear Lookean, 22-48
% Set up the first part thats a double summation:
part1 = sym(1);
for i = 1:3
    for j = 1:3
        part1 = part1 + (F(i).'*F(i) *e)*((D(i,j)/2)*(e.'*F(j).'*F(j)*e-1));
    end
end
% Set up part 2 which is everything but that double summation:
part2 = ((F(2).'*F(3)+F(3).'*F(2))*e) * (D(4,4)*(e.'*F(2).'*F(3)*e))...
    + ((F(1).'*F(3)+F(3).'*F(1))*e) * (D(5,5)*(e.'*F(1).'*F(3)*e))...
    + ((F(1).'*F(2)+F(2).'*F(1))*e) * (D(6,6)*(e.'*F(1).'*F(2)*e)



    
    




