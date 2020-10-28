function J_p = getJ_p_symm(p,mass, a, b, c)

    numBodies = length(mass);
    for i = 1:numBodies
        G{i} = getG(p(:,i));
        J{i} = getJSymmetric(mass(i),a,b,c);
    end
    J_p = zeros(4*numBodies);
    bodyCount = 1;
    for i = 1:4:4*numBodies
        J_p(i:i+3,i:i+3) = 4*G{bodyCount}.'*J{bodyCount}*G{bodyCount};
    end
end