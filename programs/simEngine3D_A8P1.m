% To-Do: Can't get initial conditions to pass requirements
clear
h = 10e-3;

%% Set up initial conditions

%Real initial conditions, point O starts rotated 45 degrees (pi/2)
rotM = [0,0,-1;0,1,0;1,0,0]*RZ(pi/2);
p = rotM2eulP(rotM);

state.p_i = [1;0;0;0];%getEParams([0;0;0]);
state.p_j = [0.653281458948577;0.270598059802840;0.653281505927862;0.270598040343383];%p;
state.r_i = [0;0;0];
state.r_j = [0;2/(sqrt(2));-2/sqrt(2)];
state.p_i_dot = [0;0;0;0]; %gamma
state.p_j_dot = [0;0;0;0]; %gamma
state.r_j_dot = [0;0;0]; %gamma

allPhi = revJoint_Phi(state,0);
phi_q = allPhi.phi_q;
gamma = revJoint_gamma(state,0);

body.density = 7800;
body.dim_a = 4; %square bar
body.dim_b = 0.05;
body.dim_c = 0.05;
body.mass = (body.density*(body.dim_a*body.dim_b*body.dim_c));

g = -9.81;
F = [0;0;body.mass*g];

results = findInitialConditions(state.r_j, state.p_j, state.r_j_dot, state.p_j_dot, phi_q, gamma, F, body);

%% Format to send into dynamicsAnalysis
state.r_ddot = results.r_ddot;
state.p_ddot = results.p_ddot;
state.lambda_p = results.lambda_p;
state.lambda = results.lambda;
t = 0;
n{1} = state;
n{2} = dynamicsAnalysis(1,body,h,t,state);
i = 3;
while n{i-1}.t < 10
    n{i} = dynamicsAnalysis(2,body,h,n{i-1}.t,n{i-1},n{i-2});
    i = i + 1;
end

for k = 1:length(n)
    acceleration(k,:) = n{k}.r_ddot.';
end

figure
plot(acceleration)

