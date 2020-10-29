function phi = revJoint_Phi(guess)

% Needs:
%   -p_i,p_j,r_i,r_j,d,df,ddf

    L = 2;
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

        %%% Build Phi_q / Jacobian
        % We only care about solving for the body j so we will only keep the
        % sections that pertain to it.
        phi.phi_q = [
            con1.phi_r(4:6),con1.phi_p(5:8);
            con2.phi_r(4:6),con2.phi_p(5:8);
            con3.phi_r(4:6),con3.phi_p(5:8);
            con4.phi_r(4:6),con4.phi_p(5:8);
            con5.phi_r(4:6),con5.phi_p(5:8);
            con6.phi_r(4:6),con6.phi_p(5:8);
            con7.phi_r(4:6),con7.phi_p(1:4)];
        phi.phi_G = [con1.phi;
            con2.phi;
            con3.phi;
            con4.phi;
            con5.phi;
            con6.phi;
            con7.phi];

end