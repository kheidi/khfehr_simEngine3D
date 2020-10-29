% To-Do: Can't get initial conditions to pass requirements

%% Set up initial conditions

%Real initial conditions, point O starts rotated 45 degrees (pi/2)
rotM = RY(pi/2)*RZ(pi/2);
p = rotM2eulP(rotM);

initialGuess.p_i = [0;0;0;0];%getEParams([0;0;0]);
initialGuess.p_j = p;
initialGuess.r_i = [0;0;0];
initialGuess.r_j = [0;2/(sqrt(2));-2/sqrt(2)];
initialGuess.p_i_dot = [0;0;0;0]; %gamma
initialGuess.p_j_dot = [0;0;0;0]; %gamma
initialGuess.r_j_dot = [0;0;0]; %gamma

f = @(t) sin((pi/4)*cos(2*t));
df = @(t)pi.*sin(t.*2.0).*cos((pi.*cos(t.*2.0))./4.0).*(-1.0./2.0);
ddf = @(t)pi.^2.*sin(t.*2.0).^2.*sin((pi.*cos(t.*2.0))./4.0).*(-1.0./4.0)-pi.*cos(t.*2.0).*cos((pi.*cos(t.*2.0))./4.0);

initialGuess.f = f(0);
initialGuess.df = df(0);
initialGuess.ddf = ddf(0);

PHI = revJoint_Phi(initialGuess);
phi_q = PHI.phi_q;
gamma = revJoint_gamma(initialGuess);

physicalProperties.mass = (density*(dim_a*dim_b*dim_c));
physicalProperties.dim_a = 4; %square bar
physicalProperties.dim_b = 0.05;
physicalProperties.dim_c = 0.05;

g = -9.81;
F = [0;0;mass*g];

results = findInitialConditions(initialGuess.r_j, initialGuess.p_j, initialGuess.r_j_dot, initialGuess.p_j_dot, phi_q, gamma, F, physicalProperties);



