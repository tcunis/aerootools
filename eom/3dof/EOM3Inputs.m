classdef EOM3Inputs < EOMvector
% Inputs of the longitudinal equations of motion of the Cumulus aircraft.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-10-08
% * Changed:    2018-10-09
%
%% See also
%
% See EOMLONG
%
%%

properties (Access=protected)
end

methods
    function obj = EOM3Inputs(varargin)
        % 3-DOF input vector [eta | F].
        obj@EOMvector([],varargin{:});
    end
    
    function in = eta(U)
        in = index(U,1);
    end
    
    function in = F(U)
        in = index(U,2);
    end
end

methods (Static, Access=protected)
    function [tf,default] = check(obj, ~, varargin)
        % Overriding EOMvector.check
        if isempty(obj)
            obj = EOM3Inputs;
        end
        
        [tf,default] = check@EOMvector(obj, zeros(2,1), varargin{:});
    end
end

end