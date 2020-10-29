function results = dynamicsAnalysis(x, minus1, minus2)
% Based on Lecture17 slide 8 steps

%%% Stage 0: Seed with 1st order BDF

r_ddot = minus1.r_ddot;
p_ddot = minus1.p_ddot;

%%% Stage 1: Position & Velocity
% Find constants and set BDF coefficients based on order
if orderNum == 1
    % From table:
    beta0 = 1;
    alpha0 = 1;
    alpha1 = -1;
    C_r_dot = alpha0*minus1.r_dot;
    C_p_dot = alpha0*minus1.p_dot;
    C_r = alpha0*minus1.r + beta0*h*alpha0*minus1.r_dot;
    C_p = alpha0*minus1.p + beta0*h*alpha0*minus1.p_dot;
end


r = C_r + beta0^2*h^2*r_ddot;
p = C_p + beta0^2*h^2*p_ddot;

    

end
