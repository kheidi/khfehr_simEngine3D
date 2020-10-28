clear
%% Knowns
nb = 2;
density = 7800;
L = -2;
dim_a = 4; %square bar
dim_b = 0.05;
dim_c = 0.05;
mass = (density*(dim_a*dim_b*dim_c));
g = -9.81;
F = [0;0;mass*g];
J_bar = getJSymmetric(mass,dim_a,dim_b,dim_c);

time = 0:10e-3:10;
initial = [.7;.1;.7;.1];

for i = 1:length(time)
    [results,locationD] = simEngine3D_A6P2(time(i),initial);
    location(:,i) = locationD;
    velocity(:,i) = results.q_dot;
    acceleration(:,i) = results.q_ddot;
    initial = locationD(4:7);
    BB = getBigBlue(results.q, results.phi_q,mass,dim_a,dim_b,dim_c);
    G_dot = getG(results.q_dot(4:7));
    tau_hat(:,i) = 8*G_dot.'*J_bar*G_dot*results.q(4:7);
    P = getP(location(4:7,i));
    M = getM(mass);
    p(:,1) = location(4:7,i);
    J_p = getJ_p_symm(p,mass,dim_a,dim_b,dim_c);
%     mat1 = zeros(7,7);
%     mat1(1:3,2:7) = results.phi_r(1:6,:).';
%     mat1(4:7,2:7) = results.phi_p(1:6,:).';
%     mat1(4:7,1) = P.';
    mat1 = [results.phi_r',zeros(3*(1),1);...
                   results.phi_p',p];
    mat2 = [
        F-M*results.q_ddot(1:3);
        tau_hat(:,i)-J_p*results.q_ddot(4:7)];
    lambda = mat1\mat2;
    lambda = lambda(1:end-nb+1);
    reaction = BB*[results.q_ddot(1:3);results.q_ddot(4:7);lambda];
    G = getG(p);
    lambda = lambda(1:6);
    for hh = 1:6
          torques{i}{hh,1} = -1/2*G*results.phi_p(hh,:)'*lambda(hh);
    end
                  
%     torque(:,i) =   -(1/2)*getG(p)*results.phi_p.'*lambda;
    
end

torque =zeros(3,length(time));
% Find the torque on the driving constraint
for i = 1: length(time)
    torque(:,i) = torques{i}{6,1};
end

% Plot 

%% Plot Torque
figure; 
plot(torque(1,:));
hold on;
plot(torque(2,:));
plot(torque(3,:));
legend('X','Y','Z');

%% Plot Position of O'

figure;
sgtitle("Plot Position of O'");
subplot(3,1,1);
x = time;
y1 = location(1,:);
plot(x,y1)
title('X Position')

subplot(3,1,2);
x = time;
y2 = location(2,:);
plot(x,y2)
title('Y Position')

subplot(3,1,3);
x = time;
y3 = location(3,:);
plot(x,y3)
title('Z Position')

%% Plot Position of Q

figure;
sgtitle("Plot Position of Q");
subplot(3,1,1);
yline(0,'-r')
xlim([0 10])
title('X Position')

subplot(3,1,2);
yline(0,'-r')
xlim([0 10])
title('Y Position')

subplot(3,1,3);
yline(0,'-r')
xlim([0 10])
title('Z Position')

%% Plot Velocity
figure;
hold on;
plot(time,velocity(2,:));
plot(time,velocity(3,:));
legend('Vel in Y', 'Vel in Z');
sgtitle("Velocity of O'")
hold off

%% Plot Acceleration
figure;
hold on;
plot(time,acceleration(2,:));
plot(time,acceleration(3,:));
legend('Acc in Y', 'Acc in Z');
sgtitle("Acceleration of O'")
hold off

%% Plot Acceleration
figure;
yline(0,'-r')
xlim([0 10])
sgtitle("Acceleration of Q'")

%% Plot Velocity
figure;
yline(0,'-r')
xlim([0 10])
sgtitle("Velocity of Q")

hold off
%% Plot Animation
% figure
% title('Animation')
% for i = 1:length(location)
%     plot(location(2,i),location(3,i),'o') 
%     axis([-3 3 -3 3])
%     pause(10e-5)
% end
