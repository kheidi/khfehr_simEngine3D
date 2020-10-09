function results = con_DP1(p_i,p_i_dot,p_j,p_j_dot,a_i_bar,a_j_bar,f,df,ddf)
% DP1DIRECT 
%
% Author: K. Heidi Fehr
% Email: kfehr@wisc.edu
% October 2020; Last revision: 6-Oct-2020
%
% TO-DO: 

    %Phi
    A_i = getA(p_i);
    A_j = getA(p_j);
    results.phi = (a_i_bar.'*A_i.'*A_j*a_j_bar)-f;
    
    %Nu
    B_i = getB(p_i,a_i_bar); %Lecture 13, slide 23
    B_j = getB(p_j,a_j_bar);
    a_i_dot = B_i*p_i_dot;
    a_j_dot = B_j*p_j_dot;
    a_i = A_i*a_i_bar;
    a_j = A_j*a_j_bar;
    results.nu = df;
    
    %Gamma
    B_i_dot = getB(p_i_dot,a_i_bar);
    B_j_dot = getB(p_j_dot,a_j_bar);   
    results.gamma = -a_i.'*B_j_dot*p_j_dot - a_j.'*B_i_dot*p_i_dot - 2*a_i_dot.'*a_j_dot+ddf;
    
    %Phi_r
    phi_r_i = zeros(1,3);
    phi_r_j = zeros(1,3);
    results.phi_r = [phi_r_i,phi_r_j];
    
    %Phi_p
    phi_p_i = a_j.'*getB(p_i,a_i_bar);
    phi_p_j = a_i.'*getB(p_j,a_j_bar);
    results.phi_p = [phi_p_i,phi_p_j];
    
end