function J = getJSymmetric(mass,a,b,c)
    if nargin <3
        b = a;
        c = a;
    end
    J = zeros(3);
    J(1,1) = (1/12)*mass*(b^2 + c^2);
    J(2,2) = (1/12)*mass*(a^2+c^2);
    J(3,3) = (1/12)*mass*(a^2+b^2);
    
    J(1,1) = mass/12*2*0.05^2;
    J(2,2) = mass/12*(4^2+0.05^2);
    J(3,3) = mass/12*(4^2+0.05^2);
    
end