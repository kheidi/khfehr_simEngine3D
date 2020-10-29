function tau_hat = getTauHat(p,p_dot,body)

J_bar = getJSymmetric(body.mass,body.dim_a,body.dim_b,body.dim_c);
G_dot = getG(p_dot);
tau_hat = 8*G_dot.'*J_bar*G_dot*p;

end