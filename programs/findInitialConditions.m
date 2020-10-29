function results = findInitialConditions(r0, p0, r_dot0, p_dot0, phi_q, gamma, F, physicalProperties)
% Needs:
%   r0,p0,r_dot0, p_dot0

mass = physicalProperties.mass;
dim_a = physicalProperties.dim_a;
dim_b = physicalProperties.dim_b;
dim_c = physicalProperties.dim_c;


%%% Right Hand Side

G_dot = getG(p0);
J_bar = getJSymmetric(mass,dim_a,dim_b,dim_c);
tau_hat = 8*G_dot.'*J_bar*G_dot*p0;
gamma_p = gamma(end); %euler param gamma
gamma_hat = gamma(1:end-1);

RHS = [F;tau_hat;gamma_p;gamma_hat];

%%% Left Hand Side (bigBlue)

q = [r0;p0];
LHS = getBigBlue(q,phi_q,mass,dim_a,dim_b,dim_c);

%%% Solve for acceleration & lambdas

results.full = LHS\RHS;
results.r_ddot = results.full(1:3);
results.p_ddot = results.full(4:7);
results.lambda_p = results.full(8);
results.lambda = results.full(9:14);

end