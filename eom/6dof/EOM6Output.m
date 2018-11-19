classdef EOM6Output < EOMvector & EOM3Output
% Outputs of the 6-DOF equations of motion of the Cumulus aircraft.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-11-12
% * Changed:    2018-11-12
%
%% See also
%
% See EOM6DOF
%
%%

methods
    function obj = EOM6Output(varargin)
        if nargin == 1 && isa(varargin{1},'EOM6Output')
            % nothing to do
        elseif EOM3Output.check([],[],varargin{:}) > 0
            % [lon alt]
            Y3 = EOM3Output(varargin{:});
            
            varargin = {[lon(Y3); 0; -alt(Y3)]};
        end
        
        obj@EOMvector([], varargin{:});
    end
    
    function c = xg(Y)
        c = index(Y,1);
    end
    
    function c = yg(Y)
        c = index(Y,2);
    end
    
    function c = zg(Y)
        c = index(Y,3);
    end
    
    %% Implement inherited EOM3 interface
    function out = lon(Y)
        % Overriding EOM3Output.lon
        out = sqrt(xg(Y).^2 + yg(Y).^2);
    end
    
    function out = alt(Y)
        % Overriding EOM3Output.alt
        out = -zg(Y);
    end
end

methods (Static, Access=protected)
    function [tf,default] = check(obj, ~, varargin)
        % Overriding EOM3Output.check
        if isempty(obj)
            obj = EOM6Output;
        end
        
        [tf,default] = check@EOMvector(obj,zeros(3,1),varargin{:});
    end
end

end