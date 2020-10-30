function tau_hat = getTauHat(p,p_dot,body)

J_bar = getJSymmetric(body.mass,body.dim_a,body.dim_b,body.dim_c);
G_dot = getG(p_dot);
tau_hat = 8*G_dot.'*J_bar*G_dot*p;

% n_bar = [0;0;body.mass*9.81];
% G = getG(p);
% tau_hat = 2*G.'*n_bar + 8*G_dot.'*J_bar*G_dot*p;


end