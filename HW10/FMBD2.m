%% Homework 10: Vibrating Cantilevered Beam
% Author: K. Heidi Fehr, Date: 11/05/2020

%% Knowns

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

% Undeformed initial condition
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

GQPoints = [6,2,2];
M = getMass(L,H,W,rho,e0,GQPoints);

fprintf('Diagonal terms of M:\n\n')
disp(vpa(diag(M)));

%% Part C) Generalized Force Vector due to Gravity

% Function slide 21-35
GQPoints = [6,2,2];
F_grav = g;
Q_g = getQ_g(L,H,W,rho,e0,F_grav,GQPoints);

fprintf('Generalized force vector due to gravity:\n\n')
disp(vpa(Q_g));

%% Part D) Internal Force Vector
% Given in the exercise:
e = [0,0,0,1,0,0,0,1,0,0,0,1,...
    0.5,0,0,...
    0,0,-1,...
    0,1,0,1,0,0].';
D = ((youngsM*nu)/((1+nu)*(1-2*nu)))*...
    [
    (1-nu)/nu,1,1,0,0,0;
    1,(1-nu)/nu,1,0,0,0;
    1,1,(1-nu)/nu,0,0,0;
    0,0,0,(1-2*nu)/(2*nu),0,0;
    0,0,0,0,((1-2*nu)/(2*nu))*k2,0;
    0,0,0,0,0,((1-2*nu)/(2*nu))*k3];
GQPoints = [5,3,3];
Q_intLH = getQ_int(L,H,W,rho,e0,e,D,GQPoints);

fprintf('Generalized internal force vector:\n\n')
disp(vpa(Q_intLH));

%% Part E) Global position of points & plot
syms xi eta zeta
% Function to calculate positions of points from Xi and nodal coordinates
Sym_r_p = getS_xi(xi,eta,zeta,L,H,W)*e; % e contains nodal coordinate 
xi_ = -1:0.1:1; % Xi
for i = 1:length(xi_)
    r_p(i,:) = double(subs(Sym_r_p, [xi,eta,zeta], [xi_(i),0,0]));
end

figure;
plot(r_p(:,1),r_p(:,3))
title('Two-Node Beam in at New Global Coordinates')
axis equal

%% Part F) Gen. force vector due to external point force
pointXi = [1,0,0]; %TBD
force_applied = [10*cosd(45);0;10*sind(45)]; %N, provided
shapePoint = double(subs(getS_xi(xi,eta,zeta,L,H,W), [xi,eta,zeta], [1,0,0]));
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

function S_xi_all = getS_xi(xi,eta,zeta,L,H,W)
S_xi(1) = (1/4)*((xi^3)-(3*xi)+2);
S_xi(2) = (L/8)*((xi^3)-(xi^2)-(xi)+1);
S_xi(3) = ((H*eta)/4)*(-xi+1);
S_xi(4) = ((W*zeta)/4)*(-xi+1);
S_xi(5) = (1/4)*((-xi^3)+(3*xi)+2);
S_xi(6) = (L/8)*((xi^3)+(xi^2)-(xi)-1);
S_xi(7) = ((H*eta)/4)*(xi+1);
S_xi(8) = ((W*zeta)/4)*(xi+1);

S_xi_all = [
    S_xi(1)*eye(3);
    S_xi(2)*eye(3);
    S_xi(3)*eye(3);
    S_xi(4)*eye(3);
    S_xi(5)*eye(3);
    S_xi(6)*eye(3);
    S_xi(7)*eye(3);
    S_xi(8)*eye(3)].';
end

function S_xiXi_all = getS_xiXi(xi,eta,zeta,L,H,W)
S_xiXi(1) = (3/4)*((xi^2)-1);
S_xiXi(2) = (L/8)*(3*(xi^2)-2*xi-1);
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
end
 
function S_xiEta_all = getS_xiEta(xi,eta,zeta,L,H,W)
% S_xiEta = sym('Sym_xiEta', [3 24]);

S_xiEta(1) = 0;
S_xiEta(2) = 0;
S_xiEta(3) = (H/4)*(-xi+1);
S_xiEta(4) = 0;
S_xiEta(5) = 0;
S_xiEta(6) = 0;
S_xiEta(7) = (H/4)*(xi+1);
S_xiEta(8) = 0;

S_xiEta_all = [
    S_xiEta(1)*eye(3);
    S_xiEta(2)*eye(3);
    S_xiEta(3)*eye(3);
    S_xiEta(4)*eye(3);
    S_xiEta(5)*eye(3);
    S_xiEta(6)*eye(3);
    S_xiEta(7)*eye(3);
    S_xiEta(8)*eye(3)].';
end

function S_xiZeta_all = getS_xiZeta(xi,eta,zeta,L,H,W)

% S_xiZeta = sym('Sym_xiZeta', [3 24]);

S_xiZeta(1) = 0;
S_xiZeta(2) = 0;
S_xiZeta(3) = 0;
S_xiZeta(4) = (W/4)*(-xi+1);
S_xiZeta(5) = 0;
S_xiZeta(6) = 0;
S_xiZeta(7) = 0;
S_xiZeta(8) = (W/4)*(xi+1);

S_xiZeta_all = [
    S_xiZeta(1)*eye(3);
    S_xiZeta(2)*eye(3);
    S_xiZeta(3)*eye(3);
    S_xiZeta(4)*eye(3);
    S_xiZeta(5)*eye(3);
    S_xiZeta(6)*eye(3);
    S_xiZeta(7)*eye(3);
    S_xiZeta(8)*eye(3)].';
end
    
function M = getMass(L,H,W,rho,e0,GQPoints)
M = 0
[W_xi P_xi] = GQValues(GQPoints(1));
[W_eta P_eta] = GQValues(GQPoints(1));
[W_zeta P_zeta] = GQValues(GQPoints(1));

for i = 1:length(P_xi)
    for j = 1:length(P_eta)
        for k = 1:length(P_zeta)
            xi = P_xi(i);
            eta = P_eta(j);
            zeta = P_zeta(k);
            %Jacobian
            J0 = [getS_xiXi(xi,eta,zeta,L,H,W)*e0, getS_xiEta(xi,eta,zeta,L,H,W)*e0, getS_xiZeta(xi,eta,zeta,L,H,W)*e0];
            detJ = det(J0);
            %Find Mass Matrix
            M = M + rho*(getS_xi(xi,eta,zeta,L,H,W).')*getS_xi(xi,eta,zeta,L,H,W)*detJ*W_xi(i)*W_eta(j)*W_zeta(k);
        end
    end
end
    
end

function Q_g = getQ_g(L,H,W,rho,e0,F_grav,GQPoints)
Q_g = 0;
[W_xi P_xi] = GQValues(GQPoints(1));
[W_eta P_eta] = GQValues(GQPoints(1));
[W_zeta P_zeta] = GQValues(GQPoints(1));

for i = 1:length(P_xi)
    for j = 1:length(P_eta)
        for k = 1:length(P_zeta)
            xi = P_xi(i);
            eta = P_eta(j);
            zeta = P_zeta(k);
            %Jacobian
            J0 = [getS_xiXi(xi,eta,zeta,L,H,W)*e0, getS_xiEta(xi,eta,zeta,L,H,W)*e0, getS_xiZeta(xi,eta,zeta,L,H,W)*e0];
            detJ = det(J0);
            %Find Mass Matrix
            Q_g = Q_g + rho*(getS_xi(xi,eta,zeta,L,H,W).')*F_grav*detJ*W_xi(i)*W_eta(j)*W_zeta(k);
        end
    end
end
    
end
function SF = getSF(xi,eta,zeta,L,W,H,e0)

J0 = [getS_xiXi(xi,eta,zeta,L,H,W)*e0, getS_xiEta(xi,eta,zeta,L,H,W)*e0, getS_xiZeta(xi,eta,zeta,L,H,W)*e0];
Jinv = inv(J0);

S_xiXi_all = getS_xiXi(xi,eta,zeta,L,H,W);
S_xiEta_all = getS_xiEta(xi,eta,zeta,L,H,W);
S_xiZeta_all = getS_xiZeta(xi,eta,zeta,L,H,W);

SF1 = (Jinv(1,1)*S_xiXi_all + Jinv(2,1)*S_xiEta_all + Jinv(3,1)*S_xiZeta_all);
SF2 = (Jinv(1,2)*S_xiXi_all + Jinv(2,2)*S_xiEta_all + Jinv(3,2)*S_xiZeta_all);
SF3 = (Jinv(1,3)*S_xiXi_all + Jinv(2,3)*S_xiEta_all + Jinv(3,3)*S_xiZeta_all);
SF{1} = SF1;
SF{2} = SF2;
SF{3} = SF3;

end

function Q_int = getQ_int(L,H,W,rho,e0,e,D,GQPoints)
Q_int = 0;
[W_xi P_xi] = GQValues(GQPoints(1));
[W_eta P_eta] = GQValues(GQPoints(1));
[W_zeta P_zeta] = GQValues(GQPoints(1));

for i = 1:length(P_xi)
    for j = 1:length(P_eta)
        for k = 1:length(P_zeta)
            xi = P_xi(i);
            eta = P_eta(j);
            zeta = P_zeta(k);
            %Jacobian
            J0 = [getS_xiXi(xi,eta,zeta,L,H,W)*e0, getS_xiEta(xi,eta,zeta,L,H,W)*e0, getS_xiZeta(xi,eta,zeta,L,H,W)*e0];
            detJ = det(J0);
            
            SF = getSF(xi,eta,zeta,L,W,H,e0);
            SF1 = SF{1};
            SF2 = SF{2};
            SF3 = SF{3};
            
            part1 = 0;
            for m = 1:3
                for n = 1:3
                    part1 = part1 + (SF{m}.'*SF{m} *e)*((D(m,n)/2)*(e.'*SF{n}.'*SF{n}*e-1));
                end
            end
            part2 = ((SF2.'*SF3+SF3.'*SF2)*e) * (D(4,4)*(e.'*SF2.'*SF3*e))...
                + ((SF1.'*SF3+SF3.'*SF1)*e) * (D(5,5)*(e.'*SF1.'*SF3*e))...
                + ((SF1.'*SF2+SF2.'*SF1)*e) * (D(6,6)*(e.'*SF1.'*SF2*e));
            
            %Find Mass Matrix
            Q_int = Q_int + (part1+part2)*detJ*W_xi(i)*W_eta(j)*W_zeta(k);
        end
    end
end
Q_int = -1*Q_int;  
end
