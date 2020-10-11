function results = con_CD(r_i,p_i,p_i_dot,r_j,p_j,p_j_dot,s_i_P_bar,s_j_P_bar,c,f,df,ddf)
% CDDIRECT 
%
% Input:
%
%     -r_i
%     -r_j
%     -p_i
%     -p_i_dot
%     -p_j
%     -p_j_dot
%     -s_i_P_bar
%     -s_j_P_bar
%     -c
%     -f
%     -df
%     -ddf
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
    results.phi = c.'*dij-f;
    
    %Gamma
    B_i_dot = getB(p_i_dot,s_i_P_bar);
    B_j_dot = getB(p_j_dot,s_j_P_bar);
    results.gamma = c.'*B_i_dot*p_i_dot-c.'*B_j_dot*p_j_dot+ddf;   
    
    %Nu
    results.nu = df;
    
    %Phi_r
    phi_r_i = -c.';
    phi_r_j = c.';
    results.phi_r = [phi_r_i,phi_r_j];
    
    %Phi_p
    phi_p_i = -c.'*getB(p_i,s_i_P_bar);
    phi_p_j = c.'*getB(p_j,s_j_P_bar);
    results.phi_p = [phi_p_i,phi_p_j];

end