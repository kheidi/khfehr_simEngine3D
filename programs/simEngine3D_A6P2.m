function [phiResults,location] = simEngine3D_A6P2(T,previous)
%% Pendulum Assignment
% This program simulates a 3D pendulum with a movement of theta(t) =
% (pi/4)*cos(2t)
% Author: K. Heidi Fehr
% Email: kfehr@wisc.edu
% October 2020; Last revision: 14-Oct-2020
%
% TO-DO: 
%   -

    %% Knowns
    L=2;
    syms t;
    theta = @(t) (pi/4)*cos(2*t);
    dtheta = @(t)pi.*sin(t.*2.0).*(-1.0./2.0);
    ddtheta = @(t)-pi.*cos(t.*2.0);
    
    %% Guess Parameters
    guess.p_i = getEParams([0;0;0]);
    guess.p_j = previous;
    guess.r_i = [0;0;0];
    guess.r_j = [0;-1;-1];
    f = @(t) sin((pi/4)*cos(2*t));
    df = @(t)pi.*sin(t.*2.0).*cos((pi.*cos(t.*2.0))./4.0).*(-1.0./2.0);
    ddf = @(t)pi.^2.*sin(t.*2.0).^2.*sin((pi.*cos(t.*2.0))./4.0).*(-1.0./4.0)-pi.*cos(t.*2.0).*cos((pi.*cos(t.*2.0))./4.0);

    guess.f = f(T);
    guess.df = df(T);
    guess.ddf = ddf(T);
    
    error = 100;
    i =0;
    while error>1e-5
        i = i+1;

        %% Constraints
        %%% Parallel-1
        clear data; data = guess;
        data.a_j_bar = [0;0;1]; %cj bar
        data.a_i_bar = [0;0;1]; %same as ai, Z axis of ground

        data.f = 0;
        data.df = 0;
        data.ddf = 0;
        con1 = con_DP1(data,'phi','phi_r','phi_p','nu');

        data.a_j_bar = [0;0;1]; %cj bar
        data.a_i_bar = [0;1;0]; %same as ai, Y axis of ground
        data.f = 0;
        data.df = 0;
        data.ddf = 0;
        con2 = con_DP1(data,'phi','phi_r','phi_p','nu');

        %%% Spherical
        clear data; data = guess;
        data.r_i = [0;0;0];
        data.s_i_P_bar = [0;0;0]; %also s_i_P since A = I
        data.s_j_P_bar = [-L;0;0];
        data.f = 0;
        data.df = 0;
        data.ddf = 0;
        data.c = [1;0;0];
        con3 = con_CD(data,'phi','phi_r','phi_p','nu');

        data.c = [0;1;0];
        con4 = con_CD(data,'phi','phi_r','phi_p','nu');

        data.c = [0;0;1];
        con5 = con_CD(data,'phi','phi_r','phi_p','nu');


        %%% Movement Function 
        % Driving Constraint
        clear data; data = guess;
        data.a_i_bar = [0;1;0]; %z axis of G-RF, this is what we want to set the angle with respect to
        data.a_j_bar = [1;0;0];
        con6 = con_DP1(data,'phi','phi_r','phi_p','nu');

        %%% Euler Param Constraint
        con7.phi = (data.p_j.'*data.p_j) - 1;
        con7.phi_r = [0;0;0;0;0;0].';
        con7.phi_p = 2*data.p_j.';
        con7.nu = 0;
        %con7.phi_p = [2;2;2;2;2;2;2;2].';

        %% Calculations for Newton Rhapson

        %%% Current r-p
        rp = [guess.r_j;guess.p_j];

        %%% Build Phi_q
        % We only care about solving for the body j so we will only keep the
        % sections that pertain to it.
        phi_q = [
            con1.phi_r(4:6),con1.phi_p(5:8);
            con2.phi_r(4:6),con2.phi_p(5:8);
            con3.phi_r(4:6),con3.phi_p(5:8);
            con4.phi_r(4:6),con4.phi_p(5:8);
            con5.phi_r(4:6),con5.phi_p(5:8);
            con6.phi_r(4:6),con6.phi_p(5:8);
            con7.phi_r(4:6),con7.phi_p(1:4)];

        %%% phi_Q
        % This is the collection of all phi values
        phi_Q = [con1.phi;
            con2.phi;
            con3.phi;
            con4.phi;
            con5.phi;
            con6.phi;
            con7.phi];

        
        %%% Find q_dot
        nu_array = [
            con1.nu;
            con2.nu;
            con3.nu;
            con4.nu;
            con5.nu;
            con6.nu;
            con7.nu];
        q_dot = inv(phi_q)*nu_array;
        
        %%% New r-p
        rp_next = rp-(inv(phi_q)*phi_Q);
        store(:,i) = rp_next;
        error = norm(rp-rp_next);

        guess.r_j = rp_next(1:3);
        guess.p_j = rp_next(4:7);

        if i>50
            disp('Did not converge in under 50 iterations')
            break
        end

    end

    % Plot results to see convergence
%     figure;
%     hold on
%     for j = 1:7
%         plot(store(j,:),'-*')
%     end

    %% Evaluate results
    
    %%% Driving Constraint
    clear data; data = guess;
    data.a_i_bar = [0;1;0]; %z axis of G-RF, this is what we want to set the angle with respect to
    data.a_j_bar = [1;0;0];
    data.p_i_dot = getEParams([0;0;0]);
 
    data.r_j_dot = q_dot(1:3);
    data.p_j_dot = q_dot(4:7);
    drivingConstraints = con_DP1(data,'phi','phi_r','phi_p','gamma','nu');
    phiResults = drivingConstraints;
    location = rp_next;
    
%     %%% Parallel-1
%     clear data; data = guess
%     data.a_j_bar = [0;0;1]; %cj bar?
%     data.a_i_bar = [0;0;1]; %same as ai, Z axis of ground
% 
%     data.f = 0;
%     data.df = 0;
%     data.ddf = 0;
%     con1 = con_DP1(data,'phi','phi_r','phi_p');
% 
%     data.a_j_bar = [0;0;1]; %cj bar
%     data.a_i_bar = [0;1;0]; %same as ai, Y axis of ground
%     data.f = 0;
%     data.df = 0;
%     data.ddf = 0;
%     con2 = con_DP1(data,'phi','phi_r','phi_p');
%     
    

end
