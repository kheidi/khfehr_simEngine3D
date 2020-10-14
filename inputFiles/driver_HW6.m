syms t
data.theta = @(t) (pi/4)*cosd(2*t);
data.theta_dot = matlabFunction( diff(theta(t)) );
data.theta_dot_dot = matlabFunction( diff(theta_dot(t)) );

eulerAng_i = [0;0;0];
data.p_i = getEParams(eulerAng_i);
data.p_i_dot = getEParams([0;0;0]);

eulerAng_j = [-90;-90;90+data.theta(0)];
data.p_j = getEParams(eulerAng_j);
data.p_j_dot = getEParams([0;0;data.theta_dot(0)]);
% 
data.a_i_bar = [1;0;0];
data.a_j_bar = [1;0;0];

t = 0;
% data.f = data.theta(t);
% data.df = data.theta_dot(t);
% data.ddf = data.theta_dot_dot(t);

data.f = 0;
data.df = 0;
data.ddf = 0;

results = con_DP1(data,'phi','nu','phi_p','nu','gamma')