%% Homework 10: Vibrating Cantilevered Beam
% Author: K. Heidi Fehr, Date: 11/05/2020

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


%%% Part A) Shape function in normalized coordinates
syms xi eta zeta
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
fprintf('Normalized Coordinates Shape Function with respect to Xi:\n\n')
disp(S_xiXi(1));
disp(S_xiXi(2));
disp(S_xiXi(3));
disp(S_xiXi(4));
disp(S_xiXi(5));
disp(S_xiXi(6));
disp(S_xiXi(7));
disp(S_xiXi(8));



%%% Part B)

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

%Shape functions, but symbolic:
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

% Matrix to be normalized:
J0 = [Sym_xiXi_all*e0, Sym_xiEta_all*e0, Sym_xiZeta_all*e0];
detJ = det(J0);
% Expression to integrate:
% limits
% rho = 1;
a = -1;
b = 1;
f = rho*(Sym_xi_all.')*Sym_xi_all*detJ;
% integrals
M = int(f,zeta,a,b);
M = int(M,eta,a,b);
M = int(M,xi,a,b);

fprintf('Diagonal terms of M:\n\n')
disp(vpa(diag(M)));

%%% Part C) Generalized Force Vector due to Gravity

% Function slide 21-35
F_grav = g;
f = rho*(Sym_xi_all.')*F_grav*detJ;
a = -1;
b = 1;
% integrals
Q_g = int(f,zeta,a,b);
Q_g = int(Q_g,eta,a,b);
Q_g = int(Q_g,xi,a,b);

fprintf('Generalized force vector due to gravity:\n\n')
disp(vpa(Q_g));

%%% Part D) Internal Force Vector
% Given in the exercise:
e = [0,0,0,1,0,0,0,1,0,0,0,1,...
    0.5,0,0,...
    0,0,-1,...
    0,1,0,1,0,0].';
%Slide 22-37
r = Sym_xi_all*e;
r0 = Sym_xi_all*e0;

%Deformation Gradient Tensor, 22-39
F_e = [Sym_xiXi_all*e, Sym_xiEta_all*e, Sym_xiZeta_all*e]*inv(J0);
Jinv = inv(J0);

SF1 = (Jinv(1,1)*Sym_xiXi_all + Jinv(2,1)*Sym_xiEta_all + Jinv(3,1)*Sym_xiZeta_all);
SF2 = (Jinv(1,2)*Sym_xiXi_all + Jinv(2,2)*Sym_xiEta_all + Jinv(3,2)*Sym_xiZeta_all);
SF3 = (Jinv(1,3)*Sym_xiXi_all + Jinv(2,3)*Sym_xiEta_all + Jinv(3,3)*Sym_xiZeta_all);
SF{1} = SF1;
SF{2} = SF2;
SF{3} = SF3;

%Cauchy-Green Deformation Tensor 22-40
C = F_e.'*F_e;

%Green-Lagrange Strain Tensor, 22-41
E = 0.5*(C-eye(3));
%E in vector form:
epsilon = [E(1,1), E(2,2), E(3,3), 2*E(2,3), 2*E(1,3), 2*E(1,2)].';

%Elasticity Matrix, 22-46
D = ((youngsM*nu)/((1+nu)*(1-2*nu)))*...
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
        part1 = part1 + (SF{i}.'*SF{i} *e)*((D(i,j)/2)*(e.'*SF{j}.'*SF{j}*e-1));
    end
end
% Set up part 2 which is everything but that double summation:
part2 = ((SF2.'*SF3+SF3.'*SF2)*e) * (D(4,4)*(e.'*SF2.'*SF3*e))...
    + ((SF1.'*SF3+SF3.'*SF1)*e) * (D(5,5)*(e.'*SF1.'*SF3*e))...
    + ((SF1.'*SF2+SF2.'*SF1)*e) * (D(6,6)*(e.'*SF1.'*SF2*e));
% integrals
f = (part1+part2)*detJ;
a = -1;
b = 1;
% integrals
Q_intLH = int(f,zeta,a,b);
Q_intLH= int(Q_intLH,eta,a,b);
Q_intLH = (-1)*int(Q_intLH,xi,a,b);

fprintf('Generalized internal force vector:\n\n')
disp(vpa(Q_intLH));

%%% Part E) Global position of points & plot
syms xi eta zeta
% Function to calculate positions of points from Xi and nodal coordinates
Sym_r_p = Sym_xi_all*e; % e contains nodal coordinate 
xi_ = -1:0.1:1; % Xi
for i = 1:length(xi_)
    r_p(i,:) = double(subs(Sym_r_p, [xi,eta,zeta], [xi_(i),0,0]));
end

figure;
plot(r_p(:,1),r_p(:,3))
title('Two-Node Beam in at New Global Coordinates')
axis equal

%%% Part F) Gen. force vector due to external point force
pointXi = [1,0,0]; %TBD
force_applied = [10*cosd(45);0;10*sind(45)]; %N, provided
shapePoint = double(subs(Sym_xi_all, [xi,eta,zeta], [1,0,0]));
%Slide 24-20
Q_ext = shapePoint.'*force_applied;
fprintf('Generalized force vector due to external point force:\n\n')
disp(Q_ext)

%% Homework 10

%% Set up new information
%%% Constraint, absolute position
g = [0;0;0];
phi_abs = [
    1 0 0 zeros(1,21);
    0 1 0 zeros(1,21);
    0 0 1 zeros(1,21)]*e0-g;

%%% New External Force @ Tip
if t <= 0.05
    Ftip = [0;0;-(1-cos((2*pi*t)/0.1))];
    else
        Ftip = [0;0;0];
end

%% Functions
function [Weight, Point] = GQValues(n)
% Values from: https://pomax.github.io/bezierinfo/legendre-gauss.html
if n == 1
    Weight = 2;
    Point = 0;
elseif n == 2
    Weight = [
        1;
        1];
    Point = [
        -0.5773502691896257;
        0.5773502691896257];
elseif n == 3
    Weight = [
        0.8888888888888888;
        0.5555555555555556;
        0.5555555555555556];
    Point = [
        0;
        -0.7745966692414834;
        0.7745966692414834];
elseif n == 4
    Weight = [
        0.6521451548625461;
        0.6521451548625461;
        0.3478548451374538;
        0.3478548451374538];
    Point = [
        -0.3399810435848563;
        0.3399810435848563;
        -0.8611363115940526;
        0.8611363115940526];
elseif n == 5
    Weight = [
        0.5688888888888889;
        0.4786286704993665;
        0.4786286704993665;
        0.2369268850561891;
        0.2369268850561891];
    Point = [
        0.0000000000000000;
        -0.5384693101056831;
        0.5384693101056831;
        -0.9061798459386640;
        0.9061798459386640];
elseif n == 6
    Weight = [
        0.3607615730481386;
        0.3607615730481386;
        0.4679139345726910;
        0.4679139345726910;
        0.1713244923791704;
        0.1713244923791704];
    Point = [
        0.6612093864662645;
        -0.6612093864662645;
        -0.2386191860831969;
        0.2386191860831969;
        -0.9324695142031521;
        0.9324695142031521];
end
end


    
    
    
    
    
    
    
    
    