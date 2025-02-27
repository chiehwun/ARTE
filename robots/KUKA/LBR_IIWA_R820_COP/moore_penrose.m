% SCRIPT TEST FOR THE KUKA LBR ROBOT KINEMATICS

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
robot = load_robot('KUKA', 'LBR_IIWA_R820_COP');
close all

% test both solutions: based on the transpose an on the Moore-Penrose
q = pi/8*[1,1,1,1,1,1,1]';
q = [0.1 0.2 .3 .4 .5 .6 .7];
drawrobot3d(robot, q)
J = manipulator_jacobian(robot, q);

% rigth
R = J'*inv(J*J');

% left
L=inv(J'*J)*J';

M = pinv(J)

R-L


