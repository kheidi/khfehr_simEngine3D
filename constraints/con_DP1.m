function results = con_DP1(obj,varargin)
% CON_DP1
%   Reflects the fact that the motion is such that the dot product between
%   a vector attached to body i and a second vector attached to body j
%   assuses a specified value. (Definition: Dan Negrut, ME 751, UW Madison, 
%   Lecture 8, Slide 34)
%
% All possible inputs:
%     -p_i
%     -p_i_dot
%     -p_j
%     -p_j_dot
%     -a_i_bar
%     -a_j_bar
%     -f
%     -df
%     -ddf
%
% Possible flags:
%     -'phi'
%     -'nu'
%     -'phi_r'
%     -'phi_p'
%     -'gamma'
%
% Author: K. Heidi Fehr
% Email: kfehr@wisc.edu
% October 2020; Last revision
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
        a_i_bar = obj.a_i_bar;
        a_j_bar = obj.a_j_bar;
        f = obj.f;
        %Actual Calculations
        A_i = getA(p_i);
        A_j = getA(p_j);
        results.phi = (a_i_bar.'*A_i.'*A_j*a_j_bar)-f;
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
        a_i_bar = obj.a_i_bar;
        a_j_bar = obj.a_j_bar;
        p_i_dot = obj.p_i_dot;
        p_j_dot = obj.p_j_dot;
        ddf = obj.ddf;
        
        %Actual Calculations
        A_i = getA(p_i);
        A_j = getA(p_j);
        a_i = A_i*a_i_bar;
        a_j = A_j*a_j_bar;
        B_i = getB(p_i,a_i_bar); %Lecture 13, slide 23
        B_j = getB(p_j,a_j_bar);
        a_i_dot = B_i*p_i_dot;
        a_j_dot = B_j*p_j_dot;
        B_i_dot = getB(p_i_dot,a_i_bar);
        B_j_dot = getB(p_j_dot,a_j_bar); 
        results.gamma = -a_i.'*B_j_dot*p_j_dot - a_j.'*B_i_dot*p_i_dot - 2*a_i_dot.'*a_j_dot+ddf;
    end
    
    %Phi_r 
    %Lecture 16, slide 36
    if findPhi_r == true
        if obj.ground == 1
            phi_r_j = zeros(1,3);
            results.phi_r = phi_r_j;
        else
            results.phi_r = zeros(1,6);
        end
    end
    
    %Phi_p
    if findPhi_p == true
        %Restructure variables
        p_i = obj.p_i;
        p_j = obj.p_j;
        a_i_bar = obj.a_i_bar;
        a_j_bar = obj.a_j_bar;
        
        %Actual Calculations       
        A_i = getA(p_i);
        A_j = getA(p_j);
        a_i = A_i*a_i_bar;
        a_j = A_j*a_j_bar;
        phi_p_i = a_j.'*getB(p_i,a_i_bar);
        phi_p_j = a_i.'*getB(p_j,a_j_bar);
        results.phi_p = [phi_p_i;phi_p_j];
        if obj.ground == 1
            results.phi_p = phi_p_j;
        else
            results.phi_p = [phi_p_i,phi_p_j];
        end
    end

    
end