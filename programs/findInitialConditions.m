function results = findInitialConditions(r0, p0, r_dot0, p_dot0, phi_q, physicalProperties)
% Needs:
%   r0,p0,r_dot0, p_dot0

mass = physicalProperties.mass;
dim_a = physicalProperties.dim_a;
dim_b = physicalProperties.dim_b;
dim_c = physicalProperties.dim_c;


%%% Right Hand Side

F; %given
G_dot = getG(p0);
J_bar = getJSymmetric(mass,dim_a,dim_b,dim_c);
tau_hat = 8*G_dot.'*J_bar*G_dot*p0;

RHS = [F;tau_hat;

%%% Left Hand Side (bigBlue)

q = [r0;p0];
LHS = getBigBlue(q,phi_q,mass,dim_a,dim_b,dim_c)

end