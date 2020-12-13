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
ylabel('Constraint Condition Case')
xlim([0, data.time(end)])
ax = gca;
ax.YAxis(1).Color = 'b';
ax.YAxis(2).Color = 'k';

figure
plot(data.StancePosX*(-1),data.StancePosY,'LineWidth',2,'Color','#D81B60')
hold on
plot(data.SwingPosX*(-1),data.SwingPosY,'LineWidth',2,'Color','#90C3F1')
yline(0)
legend('Stance','Swing')
ylabel('Y (m)')
xlabel('X (m)')

figure
plot(data.time,data.ContactForceY,'-k','LineWidth',1)
ylim([-140 20])
ylabel('Vertical Ground Reaction Force (N)')
xlabel('Time')
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




