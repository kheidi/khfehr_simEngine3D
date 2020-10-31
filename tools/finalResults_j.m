function x = finalResults_j(results, body, F)

mass = body.mass;
dim_a = body.dim_a;
dim_b = body.dim_b;
dim_c = body.dim_c;
nb = length(mass);

results.q = [results.r_j;results.p_j];
results.q_dot = [results.r_j_dot;results.p_j_dot];
results.q_ddot = [results.r_ddot;results.p_ddot];

location = [results.r_j;results.p_j];
velocity = [results.r_j_dot;results.p_j_dot];
acceleration = [results.r_ddot;results.p_ddot];

results.phi = revJoint_Phi(results,body.L,results.t);
results.phi_q = results.phi.phi_q;
results.phi_p = results.phi.phi_p;
results.phi_r = results.phi.phi_r;
BB = getBigBlue(results.q, results.phi_q,mass,dim_a,dim_b,dim_c);
G_dot = getG(results.q_dot(4:7));
J_bar = getJSymmetric(mass,dim_a,dim_b,dim_c);
tau_hat = 8*G_dot.'*J_bar*G_dot*results.q(4:7);
P = getP(location(4:7,1));
M = getM(mass);
p(:,1) = location(4:7,1);
J_p = getJ_p_symm(p,mass,dim_a,dim_b,dim_c);


mat1 = [results.phi_r',zeros(3*(1),1);...
               results.phi_p',p];
mat2 = [
    F-M*results.q_ddot(1:3);
    tau_hat-J_p*results.q_ddot(4:7)];
lambda = mat1\mat2;
lambda = lambda(1:end-nb+1);
reaction = BB*[results.q_ddot(1:3);results.q_ddot(4:7);lambda];
G = getG(p);
lambda = lambda(1:6);
for hh = 1:6
      torques{1}{hh,1} = -1/2*G*results.phi_p(hh,:)'*lambda(hh);
end
torque =zeros(3,length(results.t));
% Find the torque on the driving constraint
for i = 1: length(results.t)
    torque(:,i) = torques{1}{6,1};
end

x.torque = torque;
x.location = location;
x.velocity = velocity;
x.acceleration = acceleration;

end

