classdef EOM6Velocity < EOMvector
% Velocity vector for 6-DOF equations of motion of the Cumulus aircraft.
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
% See EOM6States
%
%%

properties (Access=protected)
end

methods
    function obj = EOM6Velocity(varargin)
        % velocity vector [uA vA wA]
        obj@EOMvector([1; zeros(2,1)],varargin{:});
    end
    
    function c = u(V)
        c = index(V,1);
    end
    
    function c = v(V)
        c = index(V,2);
    end
    
    function c = w(V)
        c = index(V,3);
    end
    
    function vel = norm(V)
        vel = sqrt(u(V).^2 + v(V).^2 + w(V).^2);
    end
    
    function ang = alpha(V)
        ang = atan2(w(V), u(V));
    end
    
    function ang = beta(V)
        ang = asin(v(V)./norm(V));
    end
end

end