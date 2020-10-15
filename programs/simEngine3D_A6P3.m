clear
time = 0:10e-3:10;
%time = 0:10e-2:3;
time = [0];

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