function next_n = dynamicsAnalysis(orderNum, body, h, t,L,varargin)
% varargin: minus1, minus2
%minus needs to have:
%r,p,r_dot,p_dot,r_ddot,p_ddot,lambda,lambda.p,phi_r,phi_p

% Based on Lecture17 slide 8 steps

%%% Stage 0: Set up next time step
t = t + h;
M = getM(body.mass);

% Find constants and set BDF coefficients based on order
if orderNum == 1
    n = varargin{1};
    % From table:
    beta0 = 1;
    alpha0 = 1;
    alpha1 = -1;
    C_r_dot = alpha0*n.r_j_dot;
    C_p_dot = alpha0*n.p_j_dot;
    C_r = alpha0*n.r_j + beta0*h*alpha0*n.r_j_dot;
    C_p = alpha0*n.p_j + beta0*h*alpha0*n.p_j_dot;
elseif orderNum == 2
    n = varargin{1};
    n2 = varargin{2};
    beta0 = 2/3;
    alpha0 = 1;
    alpha1 = -4/3;
    alpha2 = 1/3;
    C_r_dot = -alpha1*n.r_j_dot + -alpha2*n2.r_j_dot;
    C_p_dot = -alpha1*n.p_j_dot + -alpha2*n2.p_j_dot;
    C_r = -alpha1*n.r_j + -alpha2*n2.r_j + beta0*h*C_r_dot;
    C_p = -alpha1*n.p_j + -alpha2*n2.p_j + beta0*h*C_p_dot;
    
end

counter = 1;
error = 1;

while error > 1e-3
   
    %%% Stage 1: Position & Velocity
    n.r_j = C_r + beta0^2*h^2*n.r_ddot;
    n.p_j = C_p + beta0^2*h^2*n.p_ddot;
    n.r_j_dot = C_r_dot + beta0*h*n.r_ddot;
    n.p_j_dot = C_p_dot + beta0*h*n.p_ddot;

    % Find new values
    sep1.p_i = n.p_i;
    sep1.r_i = n.r_i;
    sep1.p_j = n.p_j(1:4);
    sep1.r_j = n.r_i(1:3);
    sep1.pointBbar_i = [0;0;0];
    sep1.pointAbar_j = [-2;0;0];
    sep1.ground = 1;
    phi1 = free_revJoint_Phi(sep1,L,t);
    

    sep2.p_i = n.p_i(1:4);
    sep2.r_i = n.r_i(1:3);
    sep2.p_j = n.p_j(5:end);
    sep2.r_j = n.r_j(4:end);
    sep2.pointBbar_i = [2;0;0];
    sep2.pointAbar_j = [-1;0;0]; 
    sep2.ground = 0;
    phi2 = free_revJoint_Phi(sep2,L,t);
    
%     newPhi = free_revJoint_Phi(n,L,t);
    phi_q = [phi1.phi_q(1:5,:);phi2.phi_q(1:5,:)]
    n.phi_r = phi_q(:,1:6);
    n.phi_p = phi_q(:,7:14);
    newGamma = free_revJoint_gamma(n,L,t);
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
    if counter == 1
        psi = getBigBlue([n.r_j;n.p_j],newPhi.phi_q,body.mass,body.dim_a,body.dim_b,body.dim_c);
    end

    deltaZ = (psi\-g);
    Z = [n.r_ddot;n.p_ddot;n.lambda_p;n.lambda];
    Z = Z+deltaZ;
    
    counter = counter + 1;
    
    if counter > 10
        disp('Did not converge in under 50 iterations, accepting results.')
        break
    end
    
    n.r_ddot = Z(1:length(n.r_ddot));
    n.p_ddot = Z(length(n.r_ddot)+1:length(n.r_ddot)+length(n.p_ddot));
    n.lambda_p = Z(length(n.r_ddot)+length(n.p_ddot)+1:length(n.r_ddot)+length(n.p_ddot)+length(n.lambda_p));
    n.lambda = Z(length(n.r_ddot)+length(n.p_ddot)+length(n.lambda_p)+1:end);
    
    error = norm(deltaZ);
    
end

%%% Compute stage 1 again to get final answer
next_n.r_ddot = n.r_ddot;
next_n.p_ddot = n.p_ddot;
next_n.lambda_p = n.lambda_p;
next_n.lambda = n.lambda;

next_n.r_j = C_r + beta0^2*h^2*next_n.r_ddot;
next_n.p_j = C_p + beta0^2*h^2*next_n.p_ddot;
next_n.r_j_dot = C_r_dot + beta0*h*next_n.r_ddot;
next_n.p_j_dot = C_p_dot + beta0*h*next_n.p_ddot;

% Other variables to keep
next_n.p_i = n.p_i;
next_n.r_i = n.r_i;
next_n.p_i_dot = n.p_i_dot;
next_n.p_i_dot = n.p_i_dot;
next_n.ground = n.ground;

next_n.nu = newPhi.nu_array;
next_n.phi_q = newPhi.phi_q;
next_n.t = t;

end
