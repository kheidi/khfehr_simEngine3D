function a_tilde = skewM(a)
% SKEWM
%
% Author: K. Heidi Fehr
% Email: kfehr@wisc.edu
% October 2020; Last revision: 8-Oct-2020
%
% TO-DO:
    a_tilde = [
        0       -a(3)   a(2);
        a(3)    0      -a(1);
        -a(2)   a(1)    0];
end