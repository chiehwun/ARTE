%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PARAMETERS Returns a data structure containing the parameters of the
%   example 4 DOF planar robot.
%
%   Author: Arturo Gil. Universidad Miguel Hernandez de Elche. 
%   email: arturo.gil@umh.es date:   05/03/2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Copyright (C) 2012, by Arturo Gil Aparicio
%
% This file is part of ARTE (A Robotics Toolbox for Education).
% 
% ARTE is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% ARTE is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with ARTE.  If not, see <http://www.gnu.org/licenses/>.
function robot = parameters()

robot.name='Example 4DOF planar arm';

%kinematic data DH parameters
robot.DH.theta='[q(1) q(2) q(3) q(4)]';
robot.DH.d='[0  0  0  0]';
robot.DH.a='[1  1  1  1]';
robot.DH.alpha='[0  0  0  0]';

%number of degrees of freedom
robot.DOF = 4;

%Jacobian matrix
% if not defined, compute it with manipulator_jacobian
robot.J=[];
%the proper rows of J to compute manipulability
robot.selJ =[1,2,6];
robot.kind=['R' 'R' 'R' 'R'];


%Function name to compute inverse kinematic
robot.inversekinematic_fn = 'inverse_kinematics_4dofplanar(robot, T, q)';
robot.directkinematic_fn = 'directkinematic(robot, q)';

%minimum and maximum rotation angle in rad
robot.maxangle =[deg2rad(-180) deg2rad(180); %Axis 1, minimum, maximum
                deg2rad(-180) deg2rad(180);
                deg2rad(-180) deg2rad(180)]; %Axis 2, minimum, maximum
          
            %minimum and maximum rotation angle in rad
robot.maxangle =[deg2rad(-90) deg2rad(90); %Axis 1, minimum, maximum
                deg2rad(-90) deg2rad(90);
                deg2rad(-180) deg2rad(180)]; %Axis 2, minimum, maximum
            
%maximum absolute speed of each joint rad/s or m/s
robot.velmax = []; %empty, not available

robot.accelmax=robot.velmax/0.1; % 0.1 is here an acceleration time
% end effectors maximum velocity
robot.linear_velmax = 0; %m/s, example, not available

%base reference system
robot.T0 = eye(4);

%INITIALIZATION OF VARIABLES REQUIRED FOR THE SIMULATION
%position, velocity and acceleration
robot=init_sim_variables(robot);
robot.path = pwd;

%this is an ad hoc transformation between the piece and the robot's end
%effector
% robot.Tcoupling=[-1 0 0  0;
%      0 1 0  0;
%      0 0 -1 0;
%      0 0 0 1];
% Tc1 = [cos(-pi/2) 0 sin(-pi/2) 0;
%        0 1 0 0;
%        -sin(-pi/2) 0 cos(-pi/2) 0;
%        0  0  0  1       ];
% Tc2 = [1 0 0 0;
%        0 cos(pi) -sin(pi) 0;
%        0  sin(pi) cos(pi) 0;
%        0 0 0 1];
% robot.Tcoupling =Tc1*Tc2;
robot.Tcoupling = eye(4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GRAPHICS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%read graphics files
robot.graphical.has_graphics=1;
robot.graphical.color = [255 20 40]./255;
%for transparency
robot.graphical.draw_transparent=0;
%draw DH systems
robot.graphical.draw_axes=1;
%DH system length and Font size, standard is 1/10. Select 2/20, 3/30 for
%bigger robots
robot.graphical.axes_scale=1;
%adjust for a default view of the robot
robot.axis=[-3.5 3.5 -3.5 3.5 0 1]
robot = read_graphics(robot);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%DYNAMIC PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
robot.has_dynamics=1;

%consider friction in the computations
robot.dynamics.friction=0;

%link masses (kg)
robot.dynamics.masses=[1 1 1] ;

%COM of each link with respect to own reference system
robot.dynamics.r_com=[-0.5      0         0; %(rx, ry, rz) link 1
                      -0.5      0         0;
                      -0.5      0         0];%(rx, ry, rz) link 2

%link masses
m1 = robot.dynamics.masses(1);
m2 = robot.dynamics.masses(2);
m3 = robot.dynamics.masses(3);

a=eval(robot.DH.a);
L1 = a(1);
L2 = a(2);
L3 = a(3);

%Momentos de inercia de cada eslabon.
% Ixx	Iyy	Izz	Ixy	Iyz	Ixz, por cada fila
robot.dynamics.Inertia=[0   m1*L1^2/3   m1*L1^2/3    0	0	0;
                        0   m2*L2^2/3   m2*L2^2/3    0	0	0;
                        0   m3*L3^2/3   m3*L3^2/3    0	0	0];
     
%Actuator rotor inertia
robot.motors.Inertia=[0 0 0];
%Reduction ratio motor/joint speed
robot.motors.G=[1 1 1];
%consider friction
robot.friction=0;
%Viscous friction factor, motor referred
%robot.B = [1e-3  1e-3 1e-3];
robot.motors.Viscous = [10  10 10];
%Coulomb friction, motor referred
robot.motors.Coulomb = [0 0;
            0 0;
            0 0];
        
%SPECIAL PARAMETERS TO SOLVE THE INVERSE KINEMATICS
robot.parameters.step_time=0.1;
%Error in XYZ to stop inverse kinematics
robot.parameters.epsilonXYZ=0.01;
%Error in Quaternion to stop inverse kinematics.
robot.parameters.epsilonQ=0.01;
robot.parameters.stop_iterations=500;

