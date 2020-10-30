function results = findInitialConditions(r0, p0, r_dot0, p_dot0, phi_r, phi_p, gamma, F, physicalProperties)
% Needs:
%   r0,p0,r_dot0, p_dot0

mass = physicalProperties.mass;
dim_a = physicalProperties.dim_a;
dim_b = physicalProperties.dim_b;
dim_c = physicalProperties.dim_c;

nb = length(mass);
nc = length(gamma) - 1;

%%% Right Hand Side

G_dot = getG(p_dot0);
J_bar = getJSymmetric(mass,dim_a,dim_b,dim_c);
tau_hat = 8*G_dot.'*J_bar*G_dot*p0;
gamma_p = gamma(end); %euler param gamma
gamma_hat = gamma(1:end-1);

RHS = [F;tau_hat;gamma_p;gamma_hat];

%%% Left Hand Side (bigBlue)

% q = [r0;p0];
% LHS = getBigBlue(q,phi_q,mass,dim_a,dim_b,dim_c);
Jp = getJ_p_symm(p0,mass,dim_a,dim_b,dim_c);
P = getP(p0);
M = getM(mass);
LHS = [
    M, zeros(3*nb,4*nb), zeros(3*nb,nb), phi_r.';
    zeros(4*nb,3*nb), Jp, P.', phi_p.';
    zeros(nb,3*nb), P, zeros(nb,nb),zeros(nb,nc);
    phi_r, phi_p, zeros(nc,nb), zeros(nc,nc)];

%%% Solve for acceleration & lambdas

results.full = LHS\RHS;
results.r_ddot = results.full(1:3);
results.p_ddot = results.full(4:7);
results.lambda_p = results.full(8);
results.lambda = results.full(9:14);

end