function gamma = revJoint_gamma(data)

% Needs:
%   -p_i,p_j,r_i,r_j,d,df,ddf, p_i_dot,p_j_dot,r_j_dot
    L = 2;
%%% Driving Constraint
    data.a_i_bar = [0;1;0]; %z axis of G-RF, this is what we want to set the angle with respect to
    data.a_j_bar = [1;0;0];
    con6 = con_DP1(data,'gamma');
    
    %%% Parallel-1
    data.a_j_bar = [0;0;1]; %cj bar
    data.a_i_bar = [0;0;1]; %same as ai, Z axis of ground

    data.f = 0;
    data.df = 0;
    data.ddf = 0;
    con1 = con_DP1(data,'gamma');

    data.a_j_bar = [0;0;1]; %cj bar
    data.a_i_bar = [0;1;0]; %same as ai, Y axis of ground
    data.f = 0;
    data.df = 0;
    data.ddf = 0;
    con2 = con_DP1(data,'gamma');
    
    %%% Spherical
    data.r_i = [0;0;0];
    data.s_i_P_bar = [0;0;0]; %also s_i_P since A = I
    data.s_j_P_bar = [-L;0;0];
    data.f = 0;
    data.df = 0;
    data.ddf = 0;
    data.c = [1;0;0];
    con3 = con_CD(data,'gamma');

    data.c = [0;1;0];
    con4 = con_CD(data,'gamma');

    data.c = [0;0;1];
    con5 = con_CD(data,'gamma');
    
    con7.gamma = [-2*data.p_j_dot.'*data.p_j_dot];
    
    gamma = [
            con1.gamma;
            con2.gamma;
            con3.gamma;
            con4.gamma;
            con5.gamma;
            con6.gamma;
            con7.gamma];  
        
end