%% Start time
t = 0;
%% Define bodies
L = 2;
%%% Body 1: Ground
pointID = 1;
L1 = 0;
state(pointID).p = [1;0;0;0];%getEParams([0;0;0]);
state(pointID).r = [0;0;0];
state(pointID).p_dot = [0;0;0;0]; %gamma
state(pointID).r_dot = [0;0;0];
state(pointID).ground = 1;


%%% Body 2: 
pointID = 2;
bodyID = 1;
L2 = L;
R2 = RY(pi/2)*RZ(pi/2);
p = rotM2eulP(R2);

state(pointID).p = p;
state(pointID).r = [0;2;0];
state(pointID).p_dot = [0;0;0;0]; %gamma
state(pointID).r_dot = [0;0;0]; %gamma
state(pointID).ground = 0;

body(bodyID).L = 2;
body(bodyID).dim_a = 4;
body(bodyID).dim_b = 0.05;
body(bodyID).dim_c = 0.05;
body(bodyID).density = 7800;
body(bodyID).mass = (body(bodyID).density*(body(bodyID).dim_a*body(bodyID).dim_b*body(bodyID).dim_c));


%%% Body 3:
pointID = 3;
bodyID = 2;
L3 = L/2;
R3 = RY(pi/2)*RZ(pi/2)*RZ(-pi/2);
p = rotM2eulP(R3);

state(pointID).p = p;
state(pointID).r = [0;4;-L/2];
state(pointID).p_dot = [0;0;0;0]; %gamma
state(pointID).r_dot = [0;0;0]; %gamma
state(pointID).ground = 0;

body(bodyID).L = 1;
body(bodyID).dim_a = 2;
body(bodyID).dim_b = 0.05;
body(bodyID).dim_c = 0.05;
body(bodyID).density = 7800;
body(bodyID).mass = (body(bodyID).density*(body(bodyID).dim_a*body(bodyID).dim_b*body(bodyID).dim_c));

%% Set up and find constraint info

%%% First joint, at Q

joint_1_2.p_i = state(1).p;
joint_1_2.p_j = state(2).p;
joint_1_2.r_i = state(1).r;
joint_1_2.r_j = state(2).r;
joint_1_2.p_i_dot = state(1).p_dot;
joint_1_2.p_j_dot = state(2).p_dot;
joint_1_2.r_j_dot = state(2).r_dot;
joint_1_2.ground = state(1).ground;


PHI_j12 = free_revJoint_Phi(joint_1_2,L2,t);
GAMMA_j12 = free_revJoint_gamma(joint_1_2,L2,t);

%%% Second joint, at P

joint_2_3.p_i = state(2).p;
joint_2_3.p_j = state(3).p;
joint_2_3.r_i = state(2).r;
joint_2_3.r_j = state(3).r;
joint_2_3.p_i_dot = state(2).p_dot;
joint_2_3.p_j_dot = state(3).p_dot;
joint_2_3.r_j_dot = state(3).r_dot;
joint_2_3.ground = state(2).ground;

PHI_j23 = free_revJoint_Phi(joint_2_3,L3,t);
GAMMA_j23 = free_revJoint_gamma(joint_2_3,L3,t);

%% Just start trying things?

clear p r p_dot r_dot
for i = 2:length(state)
    p(:,i-1) = state(i).p;
    r(:,i-1) = state(i).r;
    p_dot(:,i-1) = state(i).p_dot;
    r_dot(:,i-1) = state(i).r_dot;
end
p = [state(2).p;state(3).p];
r = [state(2).r;state(3).r];
p_dot = [state(2).p_dot;state(3).p_dot];
r_dot = [state(2).r_dot;state(3).r_dot];

for i = 1:length(body)
    physicalProperties.mass(i) = body(i).mass;
    physicalProperties.dim_a(i) = body(i).dim_a;
    physicalProperties.dim_b(i) = body(i).dim_b;
    physicalProperties.dim_c(i) = body(i).dim_c;
end

phi_r = [PHI_j12.phi_r;PHI_j23.phi_r];
phi_p = [PHI_j12.phi_p;PHI_j23.phi_p];
gamma = [GAMMA_j12;GAMMA_j23];
F = [0;0;sum(mass)*9.81;0;0;sum(mass)*9.81];

phi_q = buildCons.buildPhi_q(PHI_j12,PHI_j23);
phi_r = phi_q(:,1:3);
phi_p = phi_q(:,4:7);

results = findInitialConditions(r, p, r_dot, p_dot, phi_r, phi_p, gamma, F, physicalProperties);




