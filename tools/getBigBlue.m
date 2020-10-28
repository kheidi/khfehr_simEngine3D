function BB = getBigBlue(q,phi_q,mass,dim_a,dim_b,dim_c)

% TO-DO: Make BB able to adapt to different numbers of bodies.

    
    p = q(4:7,:);
    r = p(1:3,:);
    
    numBodies = length(mass);
    numConstraints = length(q);
    M = getM(mass);
    P = getP(p);
    phi_r = phi_q(1:6,1:3);
    phi_p = phi_q(1:6,4:7);
    J_p = getJ_p_symm(p,mass,dim_a,dim_b,dim_c);
    
    BB = zeros(14);
    
    BB(1:3,1:3) = M;
    BB(9:14,1:3) = phi_r;
    BB(1:3, 9:14) = phi_r.';
    BB(4:7,4:7) = J_p;
    BB(4:7,8) = P.';
    BB(8,4:7) = P;
    BB(9:14,4:7) = phi_p;
    BB(4:7,9:14) = phi_p.';
    
        
end