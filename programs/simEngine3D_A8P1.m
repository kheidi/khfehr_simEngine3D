% To-Do: Can't get initial conditions to pass requirements
clear
h = 1e-3;
L = 2;
%% Set up initial conditions

%Real initial conditions, point O starts rotated 45 degrees (pi/2)
rotM = [0,0,-1;0,1,0;1,0,0]*RZ(sqrt(2)/2);
p = rotM2eulP(rotM);

state.p_i = [1;0;0;0];%getEParams([0;0;0]);
state.p_j = [0.653281458948577;0.270598059802840;0.653281505927862;0.270598040343383];%p;
state.r_i = [0;0;0];
state.r_j = [0;(sqrt(2));-sqrt(2)];
state.p_i_dot = [0;0;0;0]; %gamma
state.p_j_dot = [0;0;0;0]; %gamma
state.r_j_dot = [0;0;0]; %gamma
state.ground = 1;

allPhi = revJoint_Phi(state,L,0);
phi_q = allPhi.phi_q;
gamma = revJoint_gamma(state,L,0);
state.nu = allPhi.nu_array;
state.phi_q = allPhi.phi_q;

body.density = 7800;
body.dim_a = 4; %square bar
body.dim_b = 0.05;
body.dim_c = 0.05;
body.mass = (body.density*(body.dim_a*body.dim_b*body.dim_c));
body.L = L;

g = -9.81;
F = [0;0;body.mass*g];

results = findInitialConditions(state.r_j, state.p_j, state.r_j_dot, state.p_j_dot, allPhi.phi_r, allPhi.phi_p, gamma, F, body);

%% Format to send into dynamicsAnalysis
state.r_ddot = results.r_ddot;
state.p_ddot = results.p_ddot;
state.lambda_p = results.lambda_p;
state.lambda = results.lambda;
t = 0;
state.t = t;
tic
n{1} = state;
n{2} = dynamicsAnalysis(1,body,h,t,L,state);
i = 3;
while n{i-1}.t < 10
    n{i} = dynamicsAnalysis(2,body,h,n{i-1}.t,L,n{i-1},n{i-2});
    i = i + 1;
end
elapsedT = toc

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