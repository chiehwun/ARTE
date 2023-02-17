%% Record Current axisLim, view status
c_axis = [get(gca,"XLim"),get(gca,"YLim"),get(gca,"ZLim")];
[caz,cel] = view();

%% Homogeneous Transformation Matrix for each Joint
T{1} = rigidtform3d([0 0 90], [0 0.039311 -0.12]).A;
% T{1} = rigidtform3d([0 0 90], [0 0.039311 0.2]).A; % remove link0
T{2} = rigidtform3d([-90 0 180], [-0.02 0 0.035]).A;
% T{2} = rigidtform3d([-90 0 180], [-0.02 0 0.2]).A; % remove link1
T{3} = rigidtform3d([90 0 90], [-0.001 0.17 0]).A;
% T{3} = rigidtform3d([90 0 90], [-0.001 0.4 0]).A; % remove link2
T{4} = rigidtform3d([-90 0 0], [0.015+0.0037 -0.035 0]).A;
% T{4} = rigidtform3d([-90 0 0], [0.015 -0.035 0.2]).A; % remove link3
T{5} = rigidtform3d([90 0 90], [0 -0.008+0.001 0.079+0.0012]).A;
% T{5} = rigidtform3d([90 0 90], [0 -0.008 0.2]).A; % remove link4
T{6} = rigidtform3d([0 0 90], [0 0 -0.015]).A;
T{7} = rigidtform3d([0 0 0], [0 0 0]).A;

%% 
% close all;
% user_mode = 'test';
user_mode = 'save';

transform_to_own_delta('DELTA', 'DRV70L', 1000, T, user_mode);
if strcmp(user_mode, 'test')
    axis(c_axis);
    view([caz,cel]);
    set(gcf, 'WindowState', 'maximized');
else
    close all;
end

%% BACKUPS of Calibration Results
% NOTE 1: Paste to transform_to_own.m (82)
% T{1} = rigidtform3d([0 0 90], [0 0.039311 -0.12]).A;
% % T{1} = rigidtform3d([0 0 90], [0 0.039311 0.2]).A; % remove link0
% T{2} = rigidtform3d([-90 0 180], [-0.02 0 0.035]).A;
% % T{2} = rigidtform3d([-90 0 180], [-0.02 0 0.2]).A; % remove link1
% T{3} = rigidtform3d([90 0 90], [-0.001 0.17 0]).A;
% % T{3} = rigidtform3d([90 0 90], [-0.001 0.4 0]).A; % remove link2
% T{4} = rigidtform3d([-90 0 0], [0.015+0.0037 -0.035 0]).A;
% % T{4} = rigidtform3d([-90 0 0], [0.015 -0.035 0.2]).A; % remove link3
% T{5} = rigidtform3d([90 0 90], [0 -0.008+0.001 0.079+0.0012]).A;
% % T{5} = rigidtform3d([90 0 90], [0 -0.008 0.2]).A; % remove link4
% T{6} = rigidtform3d([0 0 90], [0 0 -0.015]).A;
% T{7} = rigidtform3d([0 0 0], [0 0 0]).A;
