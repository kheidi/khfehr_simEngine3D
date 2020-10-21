function J = getJSymmetric(mass,a,b,c)
    J = zeros(3);
    J(1,1) = (1/12)*mass*(b^2 + c^2);
    J(2,2) = (1/12)*mass*(a^2+c^2);
    J(3,3) = (1/12)*mass*(a^2+b^2);
end