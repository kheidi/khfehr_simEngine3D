clear
time = 0:10e-3:2;
time = 0:10e-2:3;
% time = [0];

for i = 1:length(time)
    [phiResultsD,locationD] = simEngine3D_A6P2(time(i));
    location(:,i) = locationD;
    phi(i,1) = phiResultsD.phi;
    nu(i,1) = phiResultsD.nu;
    gamma(i,1) = phiResultsD.gamma;
end

figure;
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

% for i = 1:eulAngles
%     eulAngles{i} = quat2eul(location(4:7,1))
% end

figure
for i = 1:length(location)
    plot(location(2,i),location(3,i),'o') 
    hold all
    pause(0.5)
end