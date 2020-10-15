data.theta = @(t) (pi/4)*cosd(2*t);
data.theta_dot = matlabFunction( diff(data.theta(t)) );
data.theta_dot_dot = matlabFunction( diff(data.theta_dot(t)) );

f = @(t) cosd((pi/4)*cosd(2*t));
df = matlabFunction( diff(f(t)) );
ddf = matlabFunction( diff(df(t)) );

results = con_DP1(data,'phi')

%% Knowns and Constraints
% Parallel-1
clear data
data.a_j_bar = [0;0;1]; %cj bar
data.a_i = [0;0;1];
data.f = 0;
con1 = con_DP1(data,'phi','nu','gamma','phi_r','phi_p');

data.a_j_bar = [0;0;1]; %cj bar
data.a_i = [0;1;0];
data.f = 0;
con2 = con_DP1(data,'phi','nu','gamma','phi_r','phi_p');

% Spherical
clear data
data.r_i = [0;0;0];
data.s_i_P_bar = [0;0;0]; %also s_i_P since A = I
data.f = 0;
data.c = [1;0;0];
con3 = con_CD(data,'phi','nu','gamma','phi_r','phi_p');

data.c = [0;1;0];
con4 = con_CD(data,'phi','nu','gamma','phi_r','phi_p');

data.c = [0;0;1];
con5 = con_CD(data,'phi','nu','gamma','phi_r','phi_p');




