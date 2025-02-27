function q_current = coppelia_get_joint_positions(coppelia)
    joint_handles = coppelia.robot.j_handles;

    q_current = [];
    for i=1:length(joint_handles)
        [error, value]=coppelia.sim.simxGetJointPosition(coppelia.clientID, joint_handles(i), coppelia.sim.simx_opmode_buffer);
        q_current = [q_current value];
    end
    q_current = q_current(:);
end