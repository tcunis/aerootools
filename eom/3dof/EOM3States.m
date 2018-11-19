classdef EOM3States < EOMvector
% States of the longitudinal equations of motion of the Cumulus aircraft.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-10-08
% * Changed:    2018-10-08
%
%% See also
%
% See EOMLONG
%
%%

properties (Access=protected)
end

methods
    function obj = EOM3States(varargin)
        % 3-DOF state vector [V alpha q Theta].
        obj@EOMvector([],varargin{:});
    end
    
    function st = V(X)
        st = index(X,1);
    end
    
    function st = gamma(X)
        st = index(X,2);
    end
    
    function st = q(X)
        st = index(X,3);
    end
    
    function st = alpha(X)
        st = index(X,4);
    end
    
    function aux = theta(X)
        aux = gamma(X) + alpha(X);
    end
end

methods (Static, Access=protected)
    function [tf,default] = check(obj, ~, varargin)
        % Overriding EOMvector.check
        if isempty(obj)
            obj = EOM3States;
        end
        
        [tf,default] = check@EOMvector(obj, [1; zeros(3,1)], varargin{:});
    end
end

end