classdef EOM3Output < EOMvector
% Outputs of the 3-DOF equations of motion of the Cumulus aircraft.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-11-16
% * Changed:    2018-11-16
%
%% See also
%
% See EOM6DOF
%
%%

methods
    function obj = EOM3Output(varargin)
        obj@EOMvector([], varargin{:});
    end
    
    function c = lon(Y)
        c = index(Y,1);
    end
    
    function c = alt(Y)
        c = index(Y,2);
    end
end

methods (Static, Access=protected)
    function [tf,default] = check(obj, ~, varargin)
        % Overriding EOMvector.check
        if isempty(obj)
            obj = EOM3Output;
        end
        
        [tf,default] = check@EOMvector(obj, zeros(2,1), varargin{:});
    end
end

end