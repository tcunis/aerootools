classdef EOM3States < aerootools.pkg.EOMvector
% States of the longitudinal equations.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-10-08
% * Changed:    2022-02-21
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
        obj@aerootools.pkg.EOMvector([],varargin{:});
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
            obj = aerootools.pkg.EOM3States;
        end
        
        [tf,default] = check@aerootools.pkg.EOMvector(obj, [1; zeros(3,1)], varargin{:});
    end
end

end