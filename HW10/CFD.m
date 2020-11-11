%% Homework 10: CFD

%% Knowns
for m = 1:10
    for n = 1:10
        x{m,n} = [m-1,n-1];
        v{m,n} = [-m*exp(-(m^2+n^2)),-n*exp(-(m^2+n^2))];
    end
end
mu = 0.1; %viscosity
rho = 1; %density
p = 10; %pressure
h = 1.3; %particle spacing?
mass = h; %maybe? thats what lecture 27 @ 1:16:00 says?

%% Smoothing Function
% The following loop compares each particle to all other particles, except
% for itself
grad_vx(1:100) = 0;
for i = 1:100

    for j = 1:100
        
        if i == j %don't compare to yourself!
            break
        end
        
        r = norm(x{i}-x{j}); %distance between points
        R = r/h;
        
        W(i,j) = 15/(7*pi*h^2);
        if R >= 0 && R < 1 
            W(i,j) = W(i,j)*((R^3)/2-(R^2)-(2/3));
        elseif R >= 1 && R < 2
            W(i,j) = W(i,j)*(((2-R)^3)/6);
        elseif R >= 2
            W(i,j) = W(i,j)*0;
        end
        
        grad_i = (x{i}-x{j})/r;
        grad_vx(i) = grad_fx(i) + (v{j}-v{i})*grad_i*W(i,j);
    end
    grad_vx(i) = grad_fx(i)*(mass/rho);
end

