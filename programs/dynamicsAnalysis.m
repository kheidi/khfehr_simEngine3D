function results = dynamicsAnalysis(orderNum, body, minus1, minus2)
% varargin: minus1, minus2
%minus needs to have: r,p,r_dot,p_dot

% Based on Lecture17 slide 8 steps

%%% Stage 0: Set up next time step
n = minus1;

%%% Stage 1: Position & Velocity
% Find constants and set BDF coefficients based on order
if orderNum == 1
    % From table:
    beta0 = 1;
    alpha0 = 1;
    alpha1 = -1;
    C_r_dot = alpha0*n.r_dot;
    C_p_dot = alpha0*n.p_dot;
    C_r = alpha0*minus1.r + beta0*h*alpha0*n.r_dot;
    C_p = alpha0*minus1.p + beta0*h*alpha0*n.p_dot;
end


n.r = C_r + beta0^2*h^2*n.r_ddot;
n.p = C_p + beta0^2*h^2*n.p_ddot;
n.r_dot = C_r_dot + beta0*h*n.r_ddot;
n.p_dot = C_p_dot + beta0*h*n.p_ddot;

%%% Stage 2: Find residual

M = getM(body.mass);
F = M*n.r_ddot * n.phi_r.' * n.lambda;

J_p = getJ_p_symm(n.p,body.mass,body.dim_a,body.dim_b,body.dim_c);
P = getP(n.p);
tau_hat = J_p*n.p_ddot + n.phi_p.'*n.lambda + P.'*n.lambda_p;



    

end
