function eulerParams = getEParams(eulerAngles)
    e0 = cosd(0.5*(eulerAngles(1)+eulerAngles(3)))*cosd(0.5*eulerAngles(2));
    e1 = cosd(0.5*(eulerAngles(1)-eulerAngles(3)))*cosd(0.5*eulerAngles(2));
    e2 = cosd(0.5*(eulerAngles(1)-eulerAngles(3)))*cosd(0.5*eulerAngles(2));
    e3 = cosd(0.5*(eulerAngles(1)-eulerAngles(3)))*cosd(0.5*eulerAngles(2));
    eulerParams = [e0;e1;e2;e3];
end