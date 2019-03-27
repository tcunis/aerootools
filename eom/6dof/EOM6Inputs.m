classdef EOM6Inputs < EOMvector & EOM3Inputs
% Inputs of the 6-DOF equations of motion of the Cumulus aircraft.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-10-09
% * Changed:    2018-10-09
%
%% See also
%
% See EOM6DOF
%
%%

properties (Access=protected)
end

methods
    function obj = EOM6Inputs(varargin)
        if nargin == 1 && isa(varargin{1},'EOM6Inputs')
            % nothing to do
        elseif any(EOM3Inputs.check([],[],varargin{:}) == [1,2])
            % [eta T]
            U3 = EOM3Inputs(varargin{:});
            
            varargin = {[[0; eta(U3); 0]; F(U3)]};
        end
        
        % 6-DOF input vector [xi eta zi | F].
        obj@EOMvector([],varargin{:});
    end
    
    function in = xi(U)
        % Aileron deflection
        in = index(U,1);
    end
    
    function in = eta(U)
        % Elevator deflection -- overriding EOM3Inputs.eta
        in = index(U,2);
    end
    
    function in = zeta(U)
        % Rudder deflection
        in = index(U,3);
    end
    
    function in = F(U)
        % Thrust input -- overriding EOM3Inputs.F
        in = index(U,4);
    end
end

methods (Static, Access=protected)
    function [tf,default] = check(obj, ~, varargin)
        % Overriding EOM3Inputs.check
        
        [tf,default] = check@EOMvector(obj,zeros(4,1),varargin{:});
    end
end

end