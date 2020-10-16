clear
time = 0:10e-3:10;
initial = [.7;.1;.7;.1];

for i = 1:length(time)
    [phiResultsD,locationD] = simEngine3D_A6P2(time(i),initial);
    location(:,i) = locationD;
    phi(i,1) = phiResultsD.phi;
    nu(i,1) = phiResultsD.nu;
    gamma(i,1) = phiResultsD.gamma(1).';
    initial = locationD(4:7);
end

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
title('X Position')

subplot(3,1,2);
yline(0,'-r')
title('Y Position')

subplot(3,1,3);
yline(0,'-r')
title('Z Position')

%% Plot Velocity
figure;
plot(time,nu)
sgtitle("Velocity of O'")

%% Plot Acceleration
figure;
plot(time,gamma)
sgtitle("Acceleration of O'")

%% Plot Acceleration
figure;
yline(0,'-r')
sgtitle("Acceleration of Q'")

%% Plot Velocity
figure;
yline(0,'-r')
sgtitle("Velocity of Q")

hold off
%% Plot Animation
figure
title('Animation')
for i = 1:length(location)
    plot(location(2,i),location(3,i),'o') 
    axis([-3 3 -3 3])
    hold all
    pause(10e-3)
end
hold off