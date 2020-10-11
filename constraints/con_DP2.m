function results = con_DP2(p_i,p_i_dot,p_j,p_j_dot,a_i_bar,a_j_bar,s_i_P_bar,s_j_P_bar,r_i_dot,r_j_dot,f,df,ddf)
% DP1DIRECT 
%
% Author: K. Heidi Fehr
% Email: kfehr@wisc.edu
% October 2020
%
% TO-DO: 

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

    
    %Phi_p

    
end