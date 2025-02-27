
%   INVERSE KINEMATICS using a Jacobian paradigm
%
function q = inverse_kinematics_jacobian(robot, Tf, q0)

% Obtain thea matriz de posici�n/orientaci�n en Quaternion representation
Qf = T2quaternion_shepherd(Tf);
Pf = Tf(1:3,4);
q=q0;
step_time = robot.parameters.step_time;
i=0;
step_time = 50/1000;

%this is a gradient descent solution based on moore-penrose inverse
while i < robot.parameters.stop_iterations
    Ti = directkinematic(robot, q);
    Qi = T2quaternion_shepherd(Ti);
    %Qi2 = T2quaternion2(Ti);
    %errorQ_est = Qi - Qi2
    %errorQ_est=norm(Qi-Qi2)
    Pi = Ti(1:3,4);
    %compute linear speed and angular speed that are served as a high level
    %based on the current pose
    v0 = compute_high_level_action_kinematic_v(Pf, Pi); %1m/s 
    w0 = compute_high_level_action_kinematic_w(Qf, Qi); %1rad/s
    %the restriction is the speed to reach the point
    Vref = [v0' w0']';
    
    fprintf('Iteration %d, error (v0, w0): (%f, %f)\n', i, norm(v0), norm(w0));
    if norm(v0) < robot.parameters.epsilonXYZ && norm(w0) < robot.parameters.epsilonQ
        fprintf('INVERSE KINEMATICS SUCCESS: REACHED epsilonXYZ AND epsilonQ\n')
        q = atan2(sin(q), cos(q));
        return;
    end
    qd = inverse_kinematic_moore_penrose(robot, q, Vref);
    %K = 50*max([norm(v0) norm(w0)]);
    % normalize to unit norm qd and some scaling based on the error
    %qd = K*qd/norm(qd);
    %actually move the robot.
    q = q + qd*step_time;
    drawrobot3d(robot, q)
    pause(0.01);   
    i=i+1;
end
fprintf('INVERSE KINEMATICS FAILED: COULD NOT REACH POSITION/ORIENTATION\n')




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%En base a la posici�n y orientaci�n final, calcular cu�les deben ser las
%velocidades...
% Esto es diferente a calcular la velocidades cuando ya hay contacto y se
% trata de un problema de control... pero es parecido
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [v] = compute_high_level_action_kinematic_v(Pf, Pi)
%compute a constant linear speed till target
v = (Pf-Pi);
v = v(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%En base a la posici�n y orientaci�n final, calcular cu�les deben ser las
%velocidades...
% Esto es diferente a calcular la velocidades cuando ya hay contacto y se
% trata de un problema de control... pero es parecido
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [w] = compute_high_level_action_kinematic_w(Qf, Qi)
%compute a constant angular speed till target
%asume the movement is performed in 1 second
w = angular_w_between_quaternions(Qi, Qf, 1);
w = w(:);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute angular speed w that moves Q0 into Q1 in time total_time.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function w = angular_w_between_quaternions(Q0, Q1, total_time)
global robot
%below this number, the axis is considered as [1 0 0]
%this is to avoid numerical errors
%this is the actual error allowed for w
epsilon_len = robot.parameters.epsilonQ;
%Let's first find quaternion q so q*q0=q1 it is q=q1/q0 
%For unit length quaternions, you can use q=q1*Conj(q0)
Q = qprod(Q1, qconj(Q0));

%To find rotation velocity that turns by q during time Dt you need to 
%convert quaternion to axis angle using something like this:
len=sqrt(Q(2)^2 + Q(3)^2 + Q(4)^2);

if len > epsilon_len
    angle=2*atan2(len, Q(1));
    axis=[Q(2) Q(3) Q(4)]./len;
else
    angle=0;
    axis=[1 0 0];
end
w=axis*angle/total_time;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % check whether orientation has been reached
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function reach = reached_orientation(Qf, Qi)
% Q = Qf-Qi;
% reach = sqrt(Q(1)^2 + Q(2)^2 + Q(3)^2 + Q(4)^2);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % check whether orientation has been reached
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function reach = reached_position(Pf, Pi)
% P = Pf-Pi;
% reach = sqrt(P(1)^2 + P(2)^2 + P(3)^2);



