function J_p = getJ_p_symm(p,mass, a, b, c)

    G = getG(p);
    J = getJSymmetric(mass,a,b,c);
    
    J_p = 4*G.'*J*G;
    
%     numBodies = length(mass);
%     J_p = zeros(4*numBodies);
%     bodyCount = 1;
%     for i = 1:4:4*numBodies
%         J_p(i:i+3,i:i+3) = 4*G{bodyCount}.'*J{bodyCount}*G{bodyCount};
%     end
end