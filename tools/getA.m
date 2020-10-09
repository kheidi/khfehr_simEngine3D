function A = getA(eulerParams)
% GETA 
%
% Author: K. Heidi Fehr
% Email: kfehr@wisc.edu
% October 2020; Last revision: 8-Oct-2020
%
% TO-DO:

    %Eq 9.3.7 in text
    e0 = eulerParams(1);
    e1 = eulerParams(2);
    e2 = eulerParams(3);
    e3 = eulerParams(4);
    A = zeros(3);
    A(1,1) = e0^2+e1^2-0.5;
    A(1,2) = (e1*e2-e0*e3);
    A(1,3) = (e1*e3+e0*e2);
    A(2,1) = (e1*e2+e0*e3);
    A(2,2) = e0^2+e2^2-0.5;
    A(2,3) = (e2*e3-e0*e1);
    A(3,1) = (e1*e3-e0*e2);
    A(3,2) = (e2*e3+e0*e1);
    A(3,3) = e0^2+e3^2-0.5;
    A = 2*A;
end
