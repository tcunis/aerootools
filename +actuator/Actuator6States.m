classdef Actuator6States < eompkg.EOM6Inputs
% States of 6-DOF actuator dynamics.

methods
    function obj = Actuator6States(varargin)
        % 6-DOF state vector [eta | (F)]
        obj@eompkg.EOM6Inputs(varargin{:});
    end
end

methods (Static, Access=protected)
    function [tf, default] = check(obj, default, varargin)
    % Overriding EOM6Inputs.check
    
        [~,default] = check@eompkg.EOM6Inputs(obj,default);
        
        if isempty(varargin)
            tf = 0;
        elseif length(varargin) == 1 && isa(varargin{1}, 'eompkg.EOM6Inputs')
            tf = 1;
        elseif length(varargin) == 1 && size(varargin{1},1) <= length(default)
            tf = 2;
        elseif length(varargin) == 1 && size(varargin{1},2) <= length(default)
            tf = 3;
        elseif length(varargin) <= length(default)
            tf = 4;
        else
            tf = -1;
        end
    end
end

end