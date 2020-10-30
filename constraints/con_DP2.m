function results = con_DP2(obj,varargin)
% CON_DP2 
%
% All possible inputs:
%     -r_i
%     -r_j
%     -p_i
%     -p_i_dot
%     -p_j
%     -p_j_dot
%     -a_i_bar
%     -a_j_bar
%     -s_i_P_bar
%     -s_j_P_bar
%     -r_i_dot
%     -r_j_dot
%     -f
%     -df
%     -ddf
%     -a_i_dot
%     -a_j_dot
%
% Possible flags:
%     -'phi'
%     -'nu'
%     -'phi_r'
%     -'phi_p'
%
% Author: K. Heidi Fehr
% Email: kfehr@wisc.edu
% October 2020
%
% TO-DO: 
%   -phi_p and phi_r might not be in the right size matrix
%   -Results not tested


    %Which flag/s is/are activated?
    findPhi = ismember('phi',varargin);
    findNu = ismember('nu',varargin);
    findGamma = ismember('gamma',varargin);
    findPhi_r = ismember('phi_r',varargin);
    findPhi_p = ismember('phi_p',varargin);
    
    %Phi
    if findPhi == true
        %Restructure variables
        p_i = obj.p_i;
        p_j = obj.p_j;
        s_i_P_bar = obj.s_i_P_bar;
        s_j_P_bar = obj.s_j_P_bar;
        a_i_bar = obj.a_i_bar;
        r_i = obj.r_i;
        r_j = obj.r_j;
        f = obj.f;
        
        %Actual Calculations
        A_i = getA(p_i);
        A_j = getA(p_j);
        s_i_P = A_i*s_i_P_bar;
        s_j_Q = A_j*s_j_P_bar;
        dij = getdij(r_i,r_j,s_i_P,s_j_Q);
        results.phi = a_i_bar.'*A_i.'*dij-f;
    end
    
    %Nu
    if findNu == true
        %Restructure variables
        df = obj.df;
        
        %Actual Calculations
        results.nu = df;
    end
    
    %Gamma
    if findGamma == true
        %Restructure variables
        p_i = obj.p_i;
        p_j = obj.p_j;
        r_i = obj.r_i;
        r_j = obj.r_j; 
        a_i_bar = obj.a_i_bar;
        p_i_dot = obj.p_i_dot;
        p_j_dot = obj.p_j_dot;
        r_i_dot = obj.r_i_dot;
        r_j_dot = obj.r_j_dot;
        B_i = getB(p_i,a_i_bar); %Lecture 13, slide 23
        a_i_dot = B_i*p_i_dot;
        s_i_P_bar = obj.s_i_P_bar;
        s_j_P_bar = obj.s_j_P_bar;
        ddf = obj.ddf;
        
        %Actual Calculations
        A_i = getA(p_i);
        A_j = getA(p_j);
        a_i = A_i*a_i_bar;
        s_i_P = A_i*s_i_P_bar;
        s_j_Q = A_j*s_j_P_bar;
        dij = getdij(r_i,r_j,s_i_P,s_j_Q);
        dij_dot = getdij_dot(r_i_dot,r_j_dot,p_i,p_j,s_i_P_bar,s_j_P_bar,p_i_dot,p_j_dot);
        results.gamma = -a_i.'*getB(p_j_dot,s_j_P_bar)*p_j_dot...
            + a_i.'*getB(p_i_dot,s_i_P_bar)*p_i_dot...
            - dij.'*getB(p_i_dot,a_i_bar)*p_i_dot...
            - 2*a_i_dot.'*dij_dot + ddf;
    end

    %Phi_r    
    if findPhi_r == true
        %Restructure variables
        p_i = obj.p_i;
        a_i_bar = obj.a_i_bar;
        
        %Actual Calculations
        A_i = getA(p_i);
        a_i = A_i*a_i_bar;
        phi_r_i = -(a_i);
        phi_r_j = a_i;
        if obj.ground == 1
            results.phi_r = phi_r_j;
        else
            results.phi_r = [phi_r_i,phi_r_j];
        end
    end

    
    %Phi_p
    if findPhi_p == true
        %Restructure variables
        p_i = obj.p_i;
        p_j = obj.p_j;
        r_i = obj.r_i;
        r_j = obj.r_j;
        a_i_bar = obj.a_i_bar;
        s_i_P_bar = obj.s_i_P_bar;
        s_j_P_bar = obj.s_j_P_bar;
        
        %Actual Calculations
        A_i = getA(p_i);
        A_j = getA(p_j);
        a_i = A_i*a_i_bar;
        s_i_P = A_i*s_i_P_bar;
        s_j_Q = A_j*s_j_P_bar;
        dij = getdij(r_i,r_j,s_i_P,s_j_Q);
        phi_p_i = getB(p_i,a_i_bar).'*dij - getB(p_i,s_i_P_bar).'*a_i;
        phi_p_j = getB(p_j,s_i_P_bar).'*a_i;
        if obj.ground == 1
            results.phi_p = phi_p_j;
        else
            results.phi_p = [phi_p_i,phi_p_j];
        end
 
    end

    
end