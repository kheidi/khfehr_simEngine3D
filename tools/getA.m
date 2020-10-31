function A = getA(e)
% GETA 
%
% Author: K. Heidi Fehr
% Email: kfehr@wisc.edu
% October 2020; Last revision: 8-Oct-2020
%
% TO-DO:

% Unstack p  
e = reshape(e,[4,length(e)/4]);
[x nb] = size(e);

row = 1;
col = 1;

A = zeros(3*nb);
for i = 1:nb
    e0 = e(1,i);
    e1 = e(2,i);
    e2 = e(3,i);
    e3 = e(4,i);
    
    %Eq 9.3.7 in text
    At = eye(3);
    At(1,1) = e0^2+e1^2-0.5;
    At(1,2) = (e1*e2-e0*e3);
    At(1,3) = (e1*e3+e0*e2);
    At(2,1) = (e1*e2+e0*e3);
    At(2,2) = e0^2+e2^2-0.5;
    At(2,3) = (e2*e3-e0*e1);
    At(3,1) = (e1*e3-e0*e2);
    At(3,2) = (e2*e3+e0*e1);
    At(3,3) = e0^2+e3^2-0.5;
    At = 2*At;
    
    A(row:row+2,col:col+2) = At;
    row = row+3;
    col = col+3;
    
end
    
end
