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

%% EQUATIONS
% Provided:
f = @(x,y) 1 - x - (4*x*y)/(1+x^2);
g = @(x,y) x*(1-(y/(1+x^2)));

% Jacobian:
J_f_x = @(x,y) 1+h+4*h*y*((1-x^2)/((1+x^2)^2));
J_f_y = @(x,y) (4*h*x)/(1+x^2);
J_g_x = @(x,y) -h + h*y*((1-x^2)/((1+x^2)^2));
J_g_y = @(x,y) 1 + ((h*x)/(1+x^2)); 

%% NR Solve
% Initialize:
f_prev = zeros(1,length(time));
g_prev = zeros(1,length(time))
;
x_prev = 0;
y_prev = 2;
error = 1;
c = 1; %count

for i = 2:length(time)
    
    
    f_first(1,i) = f_prev(1,i-1) + h*f(f_prev(1,i-1),g_prev(1,i-1));
    g_first(1,i) = g_prev(1,i-1) + h*f(f_prev(1,i-1),g_prev(1,i-1));
    
    %Evaulate at current
    f_eval = f(f_first(1,i),g_first(1,i));
    g_eval = g(f_first(1,i),g_first(1,i));
    
    %First guess
    f_new(1,1) = f_prev(1,i-1) + h*f_eval;
    g_new(1,1) = g_prev(1,i-1) + h*g_eval;
    
    while error > 0.00001
        f_eval = f(f_new(1,c),g_new(1,c));
        g_eval = g(f_new(1,c),g_new(1,c));
        
        %find delta
        fg = [ 
            f_new(1,c) - f_prev(1,i-1) - h*f_eval;
            g_new(1,c) - g_prev(1,i-1) - h*g_eval];
        J = [
            J_f_x(f_new(1,c),g_new(1,c)),J_f_y(f_new(1,c),g_new(1,c));
            J_g_x(f_new(1,c),g_new(1,c)),J_g_y(f_new(1,c),g_new(1,c))];
        delta = J\-fg;
        
        f_new(1,c+1) = f_new(1,c) + delta(1);
        g_new(1,c+1) = g_new(1,c) + delta(2);
        
        error = norm(f_new(1,c+1)-f_new(1,c));
            
        if c > 30
            break
        end
    end
    
    c = c + 1;
    
    %Update previous
    f_prev(1,i) = f_new

end

figure;
plot(x_array)
    