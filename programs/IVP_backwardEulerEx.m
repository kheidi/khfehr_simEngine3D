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
h = 0.01
x_array(1) = 0;
y_array(1) = 2;
t = linspace(0,20,1);

x_prev = 0;
y_prev = 0;
%% NR Solve
for i = 1:500
    x = x_array(i);
    y = y_array(i);
    %% FUNCTIONS
    % x = xn and y = yn
    g(1,1) = x*(1+h) + (4*h*x*y)/(1+x^2) - x_prev- h;
    g(2,1) = -h*x + y+(h*x*y)/(1+x^2) - y_prev;

    % Jacobian:
    J(1,1) = 1+h+4*h*y*((1-x^2)/((1+x^2)^2));
    J(1,2) = (4*h*x)/(1+x^2);
    J(2,1) = -h + h*y*((1-x^2)/((1+x^2)^2));
    J(2,2) = 1 + ((h*x)/(1+x^2));

    delta = inv(J)*-g
    x_array(i+1) = x+delta(1);
    y_array(i+1) = y+delta(2);
    x_prev = x;
    y_prev = y;
end
    