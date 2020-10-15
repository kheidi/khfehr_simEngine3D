%% Pendulum
% This program simulates a 3D pendulum with a movement of theta(t) =
% (pi/4)*cos(2t)
% Author: K. Heidi Fehr
% Email: kfehr@wisc.edu
% October 2020; Last revision: 14-Oct-2020
%
% TO-DO: 


clear
%% Knowns
L=2;
syms t;

%% Guess Parameters
guess.p_i = getEParams([0;0;0]);
guess.p_j = getEParams([-90;-90;90+25]);
guess.r_i = [0;0;0];
guess.r_j = [0;sqrt(2);-sqrt(2)];

%% Constraints
%%% Parallel-1
clear data; data = guess;
data.a_j_bar = [0;0;1]; %cj bar
data.a_i_bar = [0;0;1]; %same as ai, Z axis of ground

data.f = 0;
con1 = con_DP1(data,'phi','phi_r','phi_p');

data.a_j_bar = [0;0;1]; %cj bar
data.a_i_bar = [0;1;0]; %sane as ai, Y axis of ground
data.f = 0;
con2 = con_DP1(data,'phi','phi_r','phi_p');

%%% Spherical
clear data; data = guess;
data.r_i = [0;0;0];
data.s_i_P_bar = [0;0;0]; %also s_i_P since A = I
data.s_j_P_bar = [-L;0;0];
data.f = 0;
data.c = [1;0;0];
con3 = con_CD(data,'phi','phi_r','phi_p');

data.c = [0;1;0];
con4 = con_CD(data,'phi','phi_r','phi_p');

data.c = [0;0;1];
con5 = con_CD(data,'phi','phi_r','phi_p');


%%% Movement Function 
% Driving Constraints
f = @(t) cosd((pi/4)*cosd(2*t)); %change to input
df = matlabFunction( diff(f(t)) );
ddf = matlabFunction( diff(df(t)) );

T = 0; %change to input
data.f = f(T);
data.df = df(T);
data.ddf = ddf(T);

data.a_i_bar = [0;0;-1]; %z axis of G-RF, this is what we want to set the angle with respect to
data.a_j_bar = [1;0;0];
con6 = con_DP1(data,'phi','phi_r','phi_p');

%%% Euler Param Constraint
con7.phi = data.p_j.'*data.p_j - 1;
con7.phi_r = [0;0;0;0;0;0].';
con7.phi_p = [2;2;2;2;2;2;2;2].';

%% Calculations for Newton Rhapson

%%% Current r-p
rp = [guess.r_j;guess.p_j];

%%% Build Phi_q
% We only care about solving for the body j so we will only keep the
% sections that pertain to it.
phi_q = [
    con1.phi_r(4:6),con1.phi_p(5:8);
    con2.phi_r(4:6),con2.phi_p(5:8);
    con3.phi_r(4:6),con3.phi_p(5:8);
    con4.phi_r(4:6),con4.phi_p(5:8);
    con5.phi_r(4:6),con5.phi_p(5:8);
    con6.phi_r(4:6),con6.phi_p(5:8);
    con7.phi_r(4:6),con7.phi_p(5:8)];

%%% phi_Q
% This is the collection of each phi value
phi_Q = [
    con1.phi;
    con2.phi;
    con3.phi;
    con4.phi;
    con5.phi;
    con6.phi;
    con7.phi];
    
%%% New r-p
rp_next = rp-(phi_q*phi_Q)




