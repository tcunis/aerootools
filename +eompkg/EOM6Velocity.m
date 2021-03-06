classdef EOM6Velocity < eompkg.EOMvector & eompkg.RealFunctions
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
        obj@eompkg.EOMvector([1; zeros(2,1)],varargin{:});
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
    
    function vel2 = norm2(V,proj)
        if nargin > 1 && proj
            % Projection onto longitudinal plane
            vel2 = u(V).^2 + w(V).^2;
        else
            % 3D vector norm
            vel2 = u(V).^2 + v(V).^2 + w(V).^2;
        end
    end
        
    function ang = alpha(obj)
        ang = obj.atan2(w(obj), u(obj));
    end
    
    function ang = beta(obj)
        ang = obj.asin(v(obj).*invnorm(obj));
    end
    
    function vel = norm(obj,varargin)
        vel = obj.sqrt(norm2(obj,varargin{:}));
    end
    
    function ivel = invnorm(obj,varargin)
        ivel = obj.invsqrt(norm2(obj,varargin{:}));
    end
end

end