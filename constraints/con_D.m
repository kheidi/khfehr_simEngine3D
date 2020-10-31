function results = con_D(obj,varargin)
% CON_D 
%
% All possible inputs in OBJ struct:
%     -r_i
%     -r_j
%     -p_i
%     -p_i_dot
%     -p_j
%     -p_j_dot
%     -s_i_P_bar
%     -s_j_P_bar
%     -r_i_dot
%     -r_j_dot
%     -f
%     -df
%     -ddf
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
%   -Results not verified

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
        r_i = obj.r_i;
        r_j = obj.r_j;
        f = obj.f;
        
        %Actual Calculations
        A_i = getA(p_i);
        A_j = getA(p_j);
        s_i_P = A_i*s_i_P_bar;
        s_j_Q = A_j*s_j_P_bar;
        dij = getdij(r_i,r_j,s_i_P,s_j_Q);
        results.phi = dij.'*dij-f;
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
        p_i_dot = obj.p_i_dot;
        p_j_dot = obj.p_j_dot;
        r_i_dot = obj.r_i_dot;
        r_j_dot = obj.r_j_dot;
        s_i_P_bar = obj.s_i_P_bar;
        s_j_P_bar = obj.s_j_P_bar;
        ddf = obj.ddf;
        
        %Actual Calculations
        A_i = getA(p_i);
        A_j = getA(p_j);
        s_i_P = A_i*s_i_P_bar;
        s_j_Q = A_j*s_j_P_bar;
        dij = getdij(r_i,r_j,s_i_P,s_j_Q);
        dij_dot = getdij_dot(r_i_dot,r_j_dot,p_i,p_j,s_i_P_bar,s_j_P_bar,p_i_dot,p_j_dot);
        results.gamma = -2*dij.'*getB(p_j_dot,s_j_P_bar)*p_j_dot...
            +2*dij.'*getB(p_i_dot,s_i_P_bar)*p_i_dot...
            -2*(dij_dot.')*dij_dot+ddf;
    end
    
    
    %Lecture 16, slide 38
    %Phi_r    
    if findPhi_r == true
        %Restructure variables
        p_i = obj.p_i;
        p_j = obj.p_j;
        s_i_P_bar = obj.s_i_P_bar;
        s_j_P_bar = obj.s_j_P_bar;
        r_i = obj.r_i;
        r_j = obj.r_j;
        
        %Actual Calculations
        A_i = getA(p_i);
        A_j = getA(p_j);
        s_i_P = A_i*s_i_P_bar;
        s_j_Q = A_j*s_j_P_bar;
        dij = getdij(r_i,r_j,s_i_P,s_j_Q);
        phi_r_i = -dij;
        phi_r_j = dij;
        if obj.ground == 1
            results.phi_r = phi_r_j;
        else
            results.phi_r = [phi_r_i,phi_r_j];
        end
    end
    
    %Phi_p
    if findPhi_p == true
        %Restructure variables
        r_i = obj.r_i;
        r_j = obj.r_j;
        p_i = obj.p_i;
        p_j = obj.p_j;
        s_i_P_bar = obj.s_i_P_bar;
        s_j_P_bar = obj.s_j_P_bar;
        
        %Actual Calculations
        A_i = getA(p_i);
        A_j = getA(p_j);
        s_i_P = A_i*s_i_P_bar;
        s_j_Q = A_j*s_j_P_bar;
        dij = getdij(r_i,r_j,s_i_P,s_j_Q);
        phi_p_i = -getB(p_i,s_i_P_bar).'*dij;
        phi_p_j = getB(p_j,s_j_P_bar).'*dij;
        if obj.ground == 1
            results.phi_p = phi_p_j;
        else
            results.phi_p = [phi_p_i;phi_p_j];
        end
 
    end

end