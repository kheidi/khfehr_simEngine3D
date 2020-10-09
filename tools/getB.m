function B = getB(eulerParams,a_bar)
% getB
%
% Author: K. Heidi Fehr
% Email: kfehr@wisc.edu
% October 2020; Last revision: 8-Oct-2020
%
% TO-DO:

    %Lecture 9 slide 40
    a_bar_tilde = skewM(a_bar);
    eBold = [eulerParams(2);eulerParams(3);eulerParams(4)];
    eBold_tilde = skewM(eBold);
    e0 = eulerParams(1);
    B = 2*[(e0*eye(3)+eBold_tilde)*a_bar,eBold*(a_bar.')-(e0*eye(3)+eBold_tilde)*a_bar_tilde];
end
