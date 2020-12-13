%% Start time
t = 0;
h = 1e-3;
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
state(pointID).pointAbar = [0;0;0]; 
state(pointID).pointBbar = [0;0;0];


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
state(pointID).pointAbar = [-2;0;0]; 
state(pointID).pointBbar = [2;0;0];

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
state(pointID).pointAbar = [-1;0;0]; 
state(pointID).pointBbar = [1;0;0];

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
joint_1_2.pointAbar_i = state(1).pointAbar;
joint_1_2.pointAbar_j = state(2).pointAbar;
joint_1_2.pointBbar_i = state(1).pointBbar;
joint_1_2.pointBbar_j = state(2).pointBbar;


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
joint_2_3.pointAbar_i = state(2).pointAbar;
joint_2_3.pointAbar_j = state(3).pointAbar;
joint_2_3.pointBbar_i = state(2).pointBbar;
joint_2_3.pointBbar_j = state(3).pointBbar;


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


gamma = [GAMMA_j12;GAMMA_j23];
F = [0;0;physicalProperties.mass(1)*-9.81;0;0;physicalProperties.mass(2)*-9.81];


phi_qtemp = [PHI_j12.phi_q(1:5,:),zeros(5,7);PHI_j23.phi_q(1:5,:)];
phi_r = phi_qtemp(:,1:6);
phi_p = phi_qtemp(:,7:14);

results = findInitialConditions(r, p, r_dot, p_dot, phi_r, phi_p, gamma, F, physicalProperties);

%% Format to send into dynamicsAnalysis
newstate.p_i = state(1).p;
newstate.r_i = state(1).r;
newstate.p_i_dot = state(1).p_dot;
newstate.r_i_dot = state(1).r_dot;

newstate.p_j = p;
newstate.p_j_dot = p_dot;
newstate.r_j = r;
newstate.r_j_dot = r_dot;

newstate.r_ddot = results.r_ddot;
newstate.p_ddot = results.p_ddot;
newstate.lambda_p = results.lambda_p;
newstate.lambda = results.lambda;
t = 0;
newstate.t = t;
n{1} = newstate;
n{2} = free_dynamicsAnalysis(1,physicalProperties,h,t,L,newstate);
i = 3;
while n{i-1}.t < 10
    n{i} = free_dynamicsAnalysis(1,physicalProperties,h,n{i-1}.t,L,n{i-1},n{i-2});
    i = i + 1;
end

%% Find velocity violations

for i = 1:length(n)
    nu = n{1,i}.nu;
    phi_r = n{1,i}.phi_q(:,1:3);
    phi_p = n{1,i}.phi_q(:,4:7);
    nu_hat  = phi_r*n{1,i}.r_j_dot + phi_p*n{1,i}.p_j_dot;
    violation(:,i) = norm(nu_hat - nu);
end

%% Find final positions and torques

for i = 1:length(n)
    final{i} = finalResults_j(n{i},body,F);
    time(i,1) = n{i}.t;
    torque(i,:) = final{i}.torque;
    location(i,:) = final{i}.location;
    velocity(i,:) = final{i}.velocity;
    acceleration(i,:) = final{i}.acceleration;
end

%% Plot Torque
figure; 
plot(time,torque(:,1));
hold on;
plot(time,torque(:,2));
plot(time,torque(:,3));
xlabel('Time (s)')
legend('X','Y','Z');
title('Reaction Torque')

%% Plot Position of O'

figure;
sgtitle("Plot Position of O'");
subplot(3,1,1);
x = time;
y1 = location(:,1);
plot(x,y1)
xlabel('Time (s)')
title('X Position')

subplot(3,1,2);
x = time;
y2 = location(:,2);
plot(x,y2)
xlabel('Time (s)')
title('Y Position')

subplot(3,1,3);
x = time;
y3 = location(:,3);
plot(x,y3)
xlabel('Time (s)')
title('Z Position')

%% Plot Velocity
figure;
hold on;
plot(time,velocity(:,2));
plot(time,velocity(:,3));
xlabel('Time (s)')
legend('Vel in Y', 'Vel in Z');
sgtitle("Velocity of O'")
hold off

%% Plot Acceleration
figure;
hold on;
plot(time,acceleration(:,2));
plot(time,acceleration(:,3));
legend('Acc in Y', 'Acc in Z');
xlabel('Time (s)')
sgtitle("Acceleration of O'")
hold off

%% Plot Violation
figure;
hold on;
plot(time,violation);
sgtitle("Velocity Violations over Time")
xlabel('Time (s)')
ylabel('Velocity Violations')
hold off


