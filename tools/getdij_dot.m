function dij_dot = getdij_dot(r_i_dot,r_j_dot,p_i,p_j,s_i_p_bar,s_j_p_bar,p_i_dot,p_j_dot)
% GETDIJ
%
% Author: K. Heidi Fehr
% Email: kfehr@wisc.edu
% October 2020; Last revision: 8-Oct-2020
%
% TO-DO:
    dij_dot = r_j_dot + getB(p_j, s_j_p_bar)*p_j_dot...
        -r_i_dot -getB(p_i,s_i_p_bar)*p_i_dot;
end