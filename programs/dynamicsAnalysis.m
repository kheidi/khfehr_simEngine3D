function results = dynamicsAnalysis(orderNum, body, h, t, varargin)
% varargin: minus1, minus2
%minus needs to have:
%r,p,r_dot,p_dot,r_ddot,p_ddot,lambda,lambda.p,phi_r,phi_p

% Based on Lecture17 slide 8 steps

%%% Stage 0: Set up next time step
n = varargin{1};
t = t + h;
M = getM(body.mass);

% Find constants and set BDF coefficients based on order
if orderNum == 1
    % From table:
    beta0 = 1;
    alpha0 = 1;
    alpha1 = -1;
    C_r_dot = alpha0*n.r_j_dot;
    C_p_dot = alpha0*n.p_j_dot;
    C_r = alpha0*n.r_j + beta0*h*alpha0*n.r_j_dot;
    C_p = alpha0*n.p_j + beta0*h*alpha0*n.p_j_dot;
end

counter = 1;

while counter < 50
   
    %%% Stage 1: Position & Velocity
    n.r_j = C_r + beta0^2*h^2*n.r_ddot;
    n.p_j = C_p + beta0^2*h^2*n.p_ddot;
    n.r_j_dot = C_r_dot + beta0*h*n.r_ddot;
    n.p_j_dot = C_p_dot + beta0*h*n.p_ddot;
    
    % Find new values
    newPhi = revJoint_Phi(n,t);
    n.phi_r = newPhi.phi_r;
    n.phi_p = newPhi.phi_p;
    newGamma = revJoint_gamma(n,t);
    newJp = getJ_p_symm(n.p_j,body.mass,body.dim_a,body.dim_b,body.dim_c);
    newP = getP(n.p_j);
    newF = [0;0;body.mass*-9.81];
    newTauHat = getTauHat(n.p_j,n.p_j_dot,body);
    n.phi_param = newPhi.phi_param;
    n.phi = newPhi.phi;

    %%% Stage 2: Find residual

    g = [
        M*n.r_ddot + n.phi_r.'*n.lambda - newF;
        newJp*n.p_ddot + n.phi_p.'*n.lambda + newP.'*n.lambda_p - newTauHat;
        (1/(beta0^2*h^2))*n.phi_param;
        (1/(beta0^2*h^2))*n.phi];
    
    % Find psi
    psi = getBigBlue([n.r_j;n.p_j],newPhi.phi_q,body.mass,body.dim_a,body.dim_b,body.dim_c);
    
    deltaZ = psi\-g
    
end

end
