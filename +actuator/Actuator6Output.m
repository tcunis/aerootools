classdef Actuator6Output < eompkg.EOM6Inputs
% Output of 6-DOF actuator dynamics.

methods
    function obj = Actuator6Output(varargin)
        % 6-DOF output vector [eta | F]
        obj@eompkg.EOM6Inputs(varargin{:});
    end
end

end