time = 0:10e-3:10;
time = 0:10e-3:1;

for i = 1:length(time)
    x(i) = simEngine3D_A6P2(time(i));
end