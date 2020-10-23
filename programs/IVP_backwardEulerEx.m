%% Example of Solving an IVP with BackwardEuler
% HW 7, Problem 2
%
% Author: K. Heidi Fehr
% Email: kfehr@wisc.edu
% October 2020; Last revision: 14-Oct-2020
%
% TO-DO: 
%   -

%% KNOWNS
h = 0.01;
x_array(1) = 0;
y_array(1) = 2;
t0 = 0;
tf = 20;
time = t0:h:tf;

x_prev = 0;
y_prev = 2;

%% EQUATIONS
% Provided:
f = @(x,y) 1 - x - (4*x*y)/(1+x^2);
g = @(x,y) x(1-(y/(1+x^2)));

% Jacobian:
J_f_x = 1+h+4*h*y*((1-x^2)/((1+x^2)^2));
J_f_y = (4*h*x)/(1+x^2);
J_g_x = -h + h*y*((1-x^2)/((1+x^2)^2));
J_g_y = 1 + ((h*x)/(1+x^2)); 

%% NR Solve
for i = 1:500
    x = x_array(i);
    y = y_array(i);

    delta = inv(J)*-g
    x_array(i+1) = x+delta(1);
    y_array(i+1) = y+delta(2);
    x_prev = x;
    y_prev = y;
end

figure;
plot(x_array)
    