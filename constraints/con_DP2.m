function results = con_DP2(r_i,r_j,p_i,p_i_dot,p_j,p_j_dot,a_i_bar,a_j_bar,s_i_P_bar,s_j_P_bar,r_i_dot,r_j_dot,f,df,ddf,a_i_dot, a_j_dot)
% CON_DP2 
%
% Author: K. Heidi Fehr
% Email: kfehr@wisc.edu
% October 2020
%
% TO-DO: 
%   -add ability to only send in certain variables (varargin)
%   -phi_p and phi_r might not be in the right size matrix

    %Phi
    A_i = getA(p_i);
    A_j = getA(p_j);
    s_i_P = A_i*s_i_P_bar;
    s_j_Q = A_j*s_j_P_bar;
    dij = getdij(r_i,r_j,s_i_P,s_j_Q);
    results.phi = a_i_bar.'*A_i.'*dij-f;
    
    %Nu
    results.nu = df;
    
    %Gamma
    a_i = A_i*a_i_bar;
    a_j = A_j*a_j_bar; 
    dij_dot = getdij_dot(r_i_dot,r_j_dot,p_i,p_j,s_i_P_bar,s_j_P_bar,p_i_dot,p_j_dot);
    results.gamma = -a_i.'*getB(p_j_dot,s_j_P_bar)*p_j_dot...
        + a_i.'*getB(p_i_dot,s_i_P_bar)*p_i_dot...
        - dij.'*getB(p_i_dot,a_i_bar)*p_i_dot...
        - 2*a_i_dot.'*dij_dot + ddf;
    
    %Phi_r
    phi_r_i = -(a_i);
    phi_r_j = a_i;
    results.phi_r = [phi_r_i,phi_r_j];
    
    %Phi_p
    phi_p_i = getB(p_i,a_i_bar).'*dij - getB(p_i,s_i_P_bar).'*a_i;
    phi_p_j = getB(p_j,s_i_P_bar).'*a_i;
    results.phi_p = [phi_p_i,phi_p_j];
    
end