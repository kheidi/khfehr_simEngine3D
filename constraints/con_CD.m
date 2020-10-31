function results = con_CD(obj,varargin)
% CON_CD
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
%     -c
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
%   -

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
        c = obj.c;
        f = obj.f;
        
        %Actual Calculations
        A_i = getA(p_i);
        A_j = getA(p_j);
        s_i_P = A_i*s_i_P_bar;
        s_j_Q = A_j*s_j_P_bar;
        dij = getdij(r_i,r_j,s_i_P,s_j_Q);
        results.phi = c.'*dij-f;

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
        p_i_dot = obj.p_i_dot;
        p_j_dot = obj.p_j_dot;
        s_i_P_bar = obj.s_i_P_bar;
        s_j_P_bar = obj.s_j_P_bar;
        c = obj.c;
        ddf = obj.ddf;
        
        %Actual Calculations
        B_i_dot = getB(p_i_dot,s_i_P_bar);
        B_j_dot = getB(p_j_dot,s_j_P_bar);
        results.gamma = c.'*B_i_dot*p_i_dot-c.'*B_j_dot*p_j_dot+ddf;  
    end
    
    %Phi_r
    if findPhi_r == true
        %Restructure variables
        c = obj.c;
        
        %Actual Calculations
        phi_r_i = -c.';
        phi_r_j = c.';
        if obj.ground == 1
            results.phi_r = phi_r_j;
        else
            results.phi_r = [phi_r_i;phi_r_j];
        end

    end
    
    %Phi_p
    if findPhi_p == true
        %Restructure variables
        p_i = obj.p_i;
        p_j = obj.p_j;
        s_i_P_bar = obj.s_i_P_bar;
        s_j_P_bar = obj.s_j_P_bar;
        c = obj.c;
        
        %Actual Calculations
        phi_p_i = -c.'*getB(p_i,s_i_P_bar);
        phi_p_j = c.'*getB(p_j,s_j_P_bar);
        if obj.ground == 1
            results.phi_p = phi_p_j;
        else
            results.phi_p = [phi_p_i;phi_p_j];
        end
            

    end
    
end