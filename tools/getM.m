function M = getM(mass)
    numBodies = length(mass);
    M = zeros(3*numBodies);
    bodyCount = 1;
    for i = 1:3:3*numBodies
        M(i:i+2,i:i+2) = mass(bodyCount).*eye(3);
        bodyCount = bodyCount + 1;
    end
end