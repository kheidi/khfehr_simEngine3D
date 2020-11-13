%% Homework 10: CFD
% Author: Katherine Heidi Fehr

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
mass = 1; %maybe? thats what lecture 27 @ 1:16:00 says?

%% Represent initial particles graphically
figure
hold on
color = repmat(linspace(0,0.9,100)',1,3);
c = 1;
for m = 1:10
    for n = 1:10
     plot(x{m,n}(1),x{m,n}(2),'.','color', color(c,:))
     c = c+1;
    end
end
xlim([-1,10])
ylim([-1,10])
title('Initial position of particles')

figure
hold on
for m = 1:10
    for n = 1:10
     q = quiver(x{m,n}(1),x{m,n}(2),v{m,n}(1),v{m,n}(2),0);
     q.Marker = '.';
    end
end
xlim([-1,10])
ylim([-1,10])
title('Velocity of particles')


%% Part (1) Smoothing Function
% The following loop compares each particle to all other particles, except
% for itself
grad_vx = cell(1,100);
grad_vx(1:100) = {zeros(1,2)};
for i = 1:100

    for j = 1:100
        
        if i == j %don't compare to yourself!
            % Add setting things to ]zero
            gradiW{i,j} = [0,0];
               
        else
        
        r = norm(x{i}-x{j}); %distance between points
        R = r/h;
        
        if R >= 0 && R < 1 
            gradiW{i,j} = ((15/(7*pi*h^3))*((x{i}-x{j})/norm((x{i}-x{j})))*(((3*R^2)/2)-2*R));
        elseif R >= 1 && R < 2
            gradiW{i,j} = (15/(7*pi*h^3)*((x{i}-x{j})/norm((x{i}-x{j})))*(-1)*((2-R)^2)/2);
        elseif R >= 2
            gradiW{i,j} = (15/(7*pi*h^3)*((x{i}-x{j})/norm((x{i}-x{j})))*0);
        end
        
        grad_i = (x{i}-x{j})/r;
        grad_vx{i} = grad_vx{i} + (v{j}-v{i}).'*gradiW{i,j};
        
        end
    end
    grad_vx{i} = grad_vx{i}*(mass/rho);
end

disp('Velocity Gradient')
for i = 1:100
    fprintf('Particle number %d:\n', i)
    disp(grad_vx{i})
end

%% Part (2): Analytical Solution Comparison
% The solution I computed is very different from the analytical solution as
% can be seen in some examples below. 

for i = 1:100 
    X = x{i}(1);
    Y = x{i}(2);
    
    vA(1,1) = (2*X^2+4*X+1)*exp(-((X+1)^2+(Y+1)^2));
    vA(1,2) = -2*(X+1)*(Y+1)*exp(-((X+1)^2+(Y+1)^2));
    vA(2,1) = -2*(X+1)*(Y+1)*exp(-((X+1)^2+(Y+1)^2));
    vA(2,2) = (2*Y^2+4*Y+1)*exp(-((X+1)^2+(Y+1)^2));
    
    vAll{i} = vA;
  
end

% Compare a few points:
clc
error = (grad_vx{55}-vAll{55})./vAll{55};
disp('Error in middle of area (Point 55):')
disp(error)

error = (grad_vx{5}-vAll{5})./vAll{5};
disp('Error at edge of area (Point 5):')
disp(error)

error = (grad_vx{99}-vAll{99})./vAll{99};
disp('Error at edge of area (Point 99):')
disp(error)

for i = 1:100
    errorT = abs((grad_vx{i}-vAll{i})./vAll{i});
    maxEperP = max(max(errorT));
    minEperP = min(min(errorT));
    errorA{i} = errorT;
    maxA(i) = maxEperP;
    minA(i) = minEperP;
end
disp('Max Error')
disp(max(maxA))
disp('Min Error')
disp(min(minA))

%% Part (3): Gradient Close to the Boundary
% I know that the best results should be in the middle of the group of
% particles, this is because the center has more information about its
% neighbours. However in my results the error seems random, the edges are
% bad and the middle is bad.

%% Part (4): Find the time derivative
% I had issues understanding how to implement the formulas as I don't have
% experience with functions that use the alpha and beta. I did my best!

sum1 = 0;
sum2 = 0;

%%% Find epsilon
% Non pairwise form
alpha = 1;
beta = 1;
for i = 1:100
    for j = 1:100
        sum1 = sum1 + (mass/rho)*v{j}(beta)*gradiW{i}(alpha);
        sum2 = sum2 + (mass/rho)*v{j}(alpha)*gradiW{i}(beta);
        if alpha == beta
            epsilon{i}(alpha,beta) = sum1+sum2+([v{i}(beta) v{i}(alpha)]*[gradiW{i}(alpha);gradiW{i}(beta)])-(2/3)*dot(v{j},gradiW{j});
        else
            epsilon{i}(alpha,beta) = sum1+sum2;
        end
    end
    sum1 = 0;
    sum2 = 0;
end

alpha = 1;
beta = 2;
for i = 1:100
    for j = 1:100
        sum1 = sum1 + (mass/rho)*v{j}(beta)*gradiW{i}(alpha);
        sum2 = sum2 + (mass/rho)*v{j}(alpha)*gradiW{i}(beta);
        if alpha == beta
            epsilon{i}(alpha,beta) = sum1+sum2+([v{i}(beta) v{i}(alpha)]*[gradiW{i}(alpha);gradiW{i}(beta)])-(2/3)*dot(v{j},gradiW{j});
        else
            epsilon{i}(alpha,beta) = sum1+sum2;
        end
    end
    sum1 = 0;
    sum2 = 0;
end

alpha = 2;
beta = 2;
for i = 1:100
    for j = 1:100
        sum1 = sum1 + (mass/rho)*v{j}(beta)*gradiW{i}(alpha);
        sum2 = sum2 + (mass/rho)*v{j}(alpha)*gradiW{i}(beta);
        if alpha == beta
            epsilon{i}(alpha,beta) = sum1+sum2+([v{i}(beta) v{i}(alpha)]*[gradiW{i}(alpha);gradiW{i}(beta)])-(2/3)*dot(v{j},gradiW{j});
        else
            epsilon{i}(alpha,beta) = sum1+sum2;
        end
    end
    sum1 = 0;
    sum2 = 0;
end
alpha = 2;
beta = 1;
for i = 1:100
    for j = 1:100
        sum1 = sum1 + (mass/rho)*v{j}(beta)*gradiW{i}(alpha);
        sum2 = sum2 + (mass/rho)*v{j}(alpha)*gradiW{i}(beta);
        if alpha == beta
            epsilon{i}(alpha,beta) = sum1+sum2+([v{i}(beta) v{i}(alpha)]*[gradiW{i}(alpha);gradiW{i}(beta)])-(2/3)*dot(v{j},gradiW{j});
        else
            epsilon{i}(alpha,beta) = sum1+sum2;
        end
    end
    sum1 = 0;
    sum2 = 0;
end

%%% Time derivative of velocity
alpha = 1;
beta = 1;
sum1 = 0;
sum2 = 0;
for i = 1:100
    for j = 1:100
        sum1 = sum1 + (-mass)*((p/(rho^2))+(p/(rho^2)))*gradiW{i}(alpha);
        
        sum2 = sum2 + mass*(mu/(rho^2))*(epsilon{i}(1,:)+epsilon{j}(1,:))*gradiW{i}.';
        dv{i}(alpha,beta) = sum1+sum2;
    end
    sum1 = 0;
    sum2 = 0;
end
alpha = 2;
beta = 1;
sum1 = 0;
sum2 = 0;
for i = 1:100
    for j = 1:100
        sum1 = sum1 + (-mass)*((p/(rho^2))+(p/(rho^2)))*gradiW{i}(alpha);
        
        sum2 = sum2 + mass*(mu/(rho^2))*(epsilon{i}(1,:)+epsilon{j}(1,:))*gradiW{i}.';
        dv{i}(alpha,beta) = sum1+sum2;
    end
    sum1 = 0;
    sum2 = 0;
end

disp('Time derivative of velocity')
for i = 1:100
    fprintf('Particle number %d:\n', i)
    disp(dv{i})
end
