clear;
close all;
M = readmatrix('results.csv');
data = readtable('results.csv');
for i = 1:length(data.Case)
    if data.Case(i) == string('True')
        ConCase(i) = 1;
    else
        ConCase(i) = 0;
    end
end
figure;
yyaxis left
plot(data.time, data.angle,'b-',"LineWidth",2)
ylabel('Angle between legs (degrees)')
yyaxis right
plot(data.time,ConCase,'k-',"LineWidth",2)
ylabel('Collision Toggle Case')
xlabel('Time (s)')
xlim([0, data.time(end)])
ax = gca;
ax.YAxis(1).Color = 'b';
ax.YAxis(2).Color = 'k';

figure
plot3(data.time,data.StancePosX,data.StancePosY,'LineWidth',2,'Color','#D81B60')
hold on
plot3(data.time,data.SwingPosX,data.SwingPosY,'LineWidth',2,'Color','#90C3F1')
[x y] = meshgrid(-1.5:0.1:1.5); % Generate x and y data
z = zeros(size(x, 1)); % Generate z data
surf(x, y, z,'EdgeColor','none') % Plot the surface
alpha 0.1
legend('Stance','Swing')
ylabel('X (m)')
zlabel('Y (m)')
xlabel('Time (s)')
grid on
ylim([-0.2,0.1])
zlim([-0.02,0.05])



figure
plot(data.time,(-1)*data.ContactForceY,'-k','LineWidth',1)
ylim([-20 140])
ylabel('Vertical Ground Reaction Force (N)')
xlabel('Time (s)')
xlim([0, data.time(end)])

figure
sgtitle('Hip Reaction Force')
subplot(3,1,1)
plot(data.time,data.StanceHipJointRForceX,'r','LineWidth',1,'Color','#D81B60')
hold on
plot(data.time,data.SwingHipJointRForceX,'b','LineWidth',1,'Color','#90C3F1')
hold off
xlim([0, data.time(end)])
ylabel('Force in X-direction (N)')
subplot(3,1,2)
plot(data.time,data.StanceHipJointRForceY,'r','LineWidth',1,'Color','#D81B60')
hold on
plot(data.time,data.SwingHipJointRForceY,'b','LineWidth',1,'Color','#90C3F1')
hold off
legend('Stance','Swing')
ylabel('Force in Y-direction (N)')
xlim([0, data.time(end)])
subplot(3,1,3)
plot(data.time,data.StanceHipJointRForceZ,'r','LineWidth',1,'Color','#D81B60')
hold on
plot(data.time,data.SwingHipJointRForceZ,'b','LineWidth',1,'Color','#90C3F1')
hold off
ylabel('Force in Z-direction (N)')
xlabel('Time (s)')
xlim([0, data.time(end)])

figure
sgtitle('Hip Reaction Torque')
subplot(3,1,1)
plot(data.time,data.StanceHipJointRTorqueX,'r','LineWidth',1,'Color','#D81B60')
hold on
plot(data.time,data.SwingHipJointRTorqueX,'b','LineWidth',1,'Color','#90C3F1')
hold off
legend('Stance','Swing')
ylabel('Torque in X-direction (Nm)')
xlim([0, data.time(end)])
subplot(3,1,2)
plot(data.time,data.StanceHipJointRTorqueY,'r','LineWidth',1,'Color','#D81B60')
hold on
plot(data.time,data.SwingHipJointRTorqueY,'b','LineWidth',1,'Color','#90C3F1')
hold off
ylabel('Torque in Y-direction (Nm)')
xlim([0, data.time(end)])
subplot(3,1,3)
plot(data.time,data.StanceHipJointRTorqueZ,'r','LineWidth',1,'Color','#D81B60')
hold on
plot(data.time,data.SwingHipJointRTorqueZ,'b','LineWidth',1,'Color','#90C3F1')
hold off
ylabel('Torque in Z-direction (Nm)')
xlabel('Time (s)')
xlim([0, data.time(end)])




