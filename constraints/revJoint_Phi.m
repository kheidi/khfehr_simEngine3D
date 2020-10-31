function phi = revJoint_Phi(guess,L,t)

% Needs:
%   -p_i,p_j,r_i,r_j,d,df,ddf

f = @(t) sin((pi/4)*cos(2*t));
df = @(t)pi.*sin(t.*2.0).*cos((pi.*cos(t.*2.0))./4.0).*(-1.0./2.0);
ddf = @(t)pi.^2.*sin(t.*2.0).^2.*sin((pi.*cos(t.*2.0))./4.0).*(-1.0./4.0)-pi.*cos(t.*2.0).*cos((pi.*cos(t.*2.0))./4.0);

guess.f = f(t);
guess.df = df(t);
guess.ddf = ddf(t);


%% Constraints
%%% Parallel-1
clear data; data = guess;
data.a_j_bar = [0;0;1]; %cj bar
data.a_i_bar = [0;0;1]; %same as ai, Z axis of ground

data.f = 0;
data.df = 0;
data.ddf = 0;
con1 = con_DP1(data,'phi','phi_r','phi_p','nu');

data.a_j_bar = [0;0;1]; %cj bar
data.a_i_bar = [0;1;0]; %same as ai, Y axis of ground
data.f = 0;
data.df = 0;
data.ddf = 0;
con2 = con_DP1(data,'phi','phi_r','phi_p','nu');

%%% Spherical
clear data; data = guess;
data.r_i = [0;0;0];
data.s_i_P_bar = [0;0;0]; %also s_i_P since A = I
data.s_j_P_bar = [-L;0;0];
data.f = 0;
data.df = 0;
data.ddf = 0;
data.c = [1;0;0];
con3 = con_CD(data,'phi','phi_r','phi_p','nu');

data.c = [0;1;0];
con4 = con_CD(data,'phi','phi_r','phi_p','nu');

data.c = [0;0;1];
con5 = con_CD(data,'phi','phi_r','phi_p','nu');


%%% Movement Function 
% Driving Constraint
clear data; data = guess;
data.a_i_bar = [0;1;0]; %z axis of G-RF, this is what we want to set the angle with respect to
data.a_j_bar = [1;0;0];
con6 = con_DP1(data,'phi','phi_r','phi_p','nu');

%%% Euler Param Constraint
con7.phi = (data.p_j.'*data.p_j) - 1;
if data.ground == 1
    con7.phi_r = [0;0;0].';
    con7.phi_p = data.p_j.';
else
    con7.phi_r = [0;0;0;0;0;0].';
    con7.phi_p = [data.p_i;data.p_j].';
end

con7.nu = 0;
%con7.phi_p = [2;2;2;2;2;2;2;2].';

%%% Build Phi_q / Jacobian
% We only care about solving for the body j so we will only keep the
% sections that pertain to it.
phi.phi_q = [
    con1.phi_r,con1.phi_p;
    con2.phi_r,con2.phi_p;
    con3.phi_r,con3.phi_p;
    con4.phi_r,con4.phi_p;
    con5.phi_r,con5.phi_p;
    con6.phi_r,con6.phi_p;
    con7.phi_r,con7.phi_p];
phi.phi_G = [con1.phi;
    con2.phi;
    con3.phi;
    con4.phi;
    con5.phi;
    con6.phi;
    con7.phi];
phi.phi_param = con7.phi;
phi.phi = phi.phi_G(1:6);
phi.phi_r = [
    con1.phi_r;
    con2.phi_r;
    con3.phi_r;
    con4.phi_r;
    con5.phi_r;
    con6.phi_r];
phi.phi_p = [
    con1.phi_p;
    con2.phi_p;
    con3.phi_p;
    con4.phi_p;
    con5.phi_p;
    con6.phi_p];

%%% Find q_dot
phi.nu_array = [
    con1.nu;
    con2.nu;
    con3.nu;
    con4.nu;
    con5.nu;
    con6.nu;
    con7.nu];
phi.q_dot = inv(phi.phi_q)*phi.nu_array;


end