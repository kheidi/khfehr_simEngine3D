function P = getP(p)
    [rows numBodies] = size(p);
    P = zeros(numBodies,4*numBodies);
    bodyCount = 1;
    for i = 1:4:4*numBodies
        P(bodyCount,i:i+3) = p(:,bodyCount);
        bodyCount = bodyCount + 1;
    end
end