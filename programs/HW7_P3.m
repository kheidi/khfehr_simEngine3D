%% Part A
clc;
clear all;

t0 = 1;
tf = 10;
h = 0.01;
time = t0:h:tf;

y(1,1) = 1;
y_exact(1) = 1;

for i =1:length(time) - 1
    t = time(i);
    y(i+1) = fzero(@(Y) y(i) + h*(-Y^2-(1/(t^4))) - Y,y(i));
    y_exact(i+1) = (1/t) + (1/t^2)*tan((1/t) + pi - 1);
    
end
y_exact(1) = 1;
figure
hold on
plot(time,y,'-b','LineWidth',3)
plot(time,y_exact,'--r','LineWidth',3)
hold off

%% Part B

clear;
sh = 1;
figure;
hold on;
h = 1;
count = 0;
error = 1;
y_exact(1) = 1;
while error > 0.1
    
    h = h/2;
    t0 = 1;
    tf = 10;
    time = t0:h:tf;

    y(1,1) = 1;


    for i =1:length(time) - 1
        t = time(i);
        y(i+1) = fzero(@(Y) y(i) + h*(-Y^2-(1/(t^4))) - Y,y(i));
        y_exact(i+1) = (1/t) + (1/t^2)*tan((1/t) + pi - 1);

    end

    plot(time,y)
    error = norm(y-y_exact);
    
    if count > 30
        break
    end
    
    count = count + 1;
    
    
end

txt = {'For error < 0.1 final h:',h,'Number of iterations: ',count};
text(4,0.5,txt)
ylabel('y')
xlabel('Time')
title('Convergence Plot, Problem 3 (b)')

%% Part C

clear;
sh = 1;
figure;
hold on;
h = 1;
count = 0;
error = 1;
y_exact(1) = 1;
while error > 0.1
    
    h = h/2;
    t0 = 1;
    tf = 10;
    time = t0:h:tf;

    y(1,1) = 1;


    for i =1:length(time) - 1
        t = time(i);
        y(i+1) = fzero(@(Y) y(i) + h*(-Y^2-(1/(t^4))) - Y,y(i));
        y_exact(i+1) = (1/t) + (1/t^2)*tan((1/t) + pi - 1);

    end

    plot(time,y)
    error = norm(y-y_exact);
    
    if count > 30
        break
    end
    
    count = count + 1;
    
    
end

txt = {'For error < 0.1 final h:',h,'Number of iterations: ',count};
text(4,0.5,txt)
ylabel('y')
xlabel('Time')
title('Convergence Plot, Problem 3 (b)')
