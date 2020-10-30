function J = getJSymmetric(mass,a,b,c)
%     if nargin <3
%         b = a;
%         c = a;
%     end
nb = length(mass);
J = zeros(3*nb,3*nb);
count = 1;
for i = 1:3:3*nb
    
    J(i,i) = (1/12)*mass(count)*(b(count)^2 + c(count)^2);
    J(i+1,i+1) = (1/12)*mass(count)*(a(count)^2+c(count)^2);
    J(i+2,i+2) = (1/12)*mass(count)*(a(count)^2+b(count)^2);
    count = count+1;
    
end