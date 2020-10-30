%% Start time
t = 0;
%% Define bodies
L = 2;
%%% Body 1: Ground
bodyID = 1;
L1 = 0;
state(bodyID).p = [1;0;0;0];%getEParams([0;0;0]);
state(bodyID).r = [0;0;0];
state(bodyID).p_dot = [0;0;0;0]; %gamma

body(bodyID).L = 0;
body(bodyID).dim_a = 0;
body(bodyID).dim_b = 0;
body(bodyID).dim_c = 0;
body(bodyID).density = 0;
body(bodyID).mass = 0;
state(bodyID).ground = 1;


%%% Body 2: 
bodyID = 2;
L2 = L;
R2 = RY(pi/2)*RZ(pi/2);
p = rotM2eulP(R2);

state(bodyID).p = p;
state(bodyID).r = [0;2;0];
state(bodyID).p_dot = [0;0;0;0]; %gamma
state(bodyID).r_dot = [0;0;0]; %gamma
state(bodyID).ground = 0;

body(bodyID).L = 2;
body(bodyID).dim_a = 4;
body(bodyID).dim_b = 0.05;
body(bodyID).dim_c = 0.05;
body(bodyID).density = 7800;
body(bodyID).mass = (body(bodyID).density*(body(bodyID).dim_a*body(bodyID).dim_b*body(bodyID).dim_c));


%%% Body 3:
bodyID = 3;
L3 = L/2;
R3 = RY(pi/2)*RZ(pi/2)*RZ(-pi/2);
p = rotM2eulP(R3);

state(bodyID).p = p;
state(bodyID).r = [0;4;-L/2];
state(bodyID).p_dot = [0;0;0;0]; %gamma
state(bodyID).r_dot = [0;0;0]; %gamma
state(bodyID).ground = 0;

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


PHI_j12 = revJoint_Phi(joint_1_2,L2,t);
GAMMA_j12 = revJoint_gamma(joint_1_2,L2,t);

%%% Second joint, at P

joint_2_3.p_i = state(2).p;
joint_2_3.p_j = state(3).p;
joint_2_3.r_i = state(2).r;
joint_2_3.r_j = state(3).r;
joint_2_3.p_i_dot = state(2).p_dot;
joint_2_3.p_j_dot = state(3).p_dot;
joint_2_3.r_j_dot = state(3).r_dot;
joint_2_3.ground = state(2).ground;

PHI_j23 = revJoint_Phi(joint_2_3,L3,t);
GAMMA_j23 = revJoint_gamma(joint_2_3,L3,t);