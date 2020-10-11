function results = con_D(r_i,r_j,p_i,p_i_dot,p_j,p_j_dot,s_i_P_bar,s_j_P_bar,r_i_dot,r_j_dot,f,df,ddf)
% CON_D 
%
% Author: K. Heidi Fehr
% Email: kfehr@wisc.edu
% October 2020
%
% TO-DO: 
%   -add ability to only send in certain variables (varargin)

    %Phi
    A_i = getA(p_i);
    A_j = getA(p_j);
    s_i_P = A_i*s_i_P_bar;
    s_j_Q = A_j*s_j_P_bar;
    dij = getdij(r_i,r_j,s_i_P,s_j_Q);
    results.phi = dij.'*dij-f;
    
    %Nu
    results.nu = df;
    
    %Gamma
    dij_dot = getdij_dot(r_i_dot,r_j_dot,p_i,p_j,s_i_P_bar,s_j_P_bar,p_i_dot,p_j_dot);
    results.gamma = -2*dij.'*getB(p_j_dot,s_j_P_bar)*p_j_dot...
        +2*dij.'+getB(p_i_dot,s_i_P_bar)*p_i_dot...
        -2*(dij_dot.')*dij_dot+ddf;
    
    %Phi_r
    phi_r_i = -dij;
    phi_r_j = dij;
    results.phi_r = [phi_r_i,phi_r_j];
    
    %Phi_p
    phi_p_i = -getB(p_i,s_i_P_bar).'*dij;
    phi_p_j = getB(p_j,s_j_P_bar).'*dij;
    results.phi_p = [phi_p_i,phi_p_j];
    
end