classdef EOM6AirPath < EOMvector & RealFunctions
% Air path vector for 6-DOF equations of motion of the Cumulus aircraft.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-11-02
% * Changed:    2018-11-02
%
%% See also
%
% See EOM6States
%
%%

properties
end

methods
    function obj = EOM6AirPath(Vf, Phi)
        if nargin == 1
            % copy
            air = Vf;
            
        elseif size(Vf,2) > 1
            air = zeros(size(Vf));
            for i=1:size(Vf,2)
                air(:,i) = g2f(EOM6Attitude(Phi(:,i)))'*Vf(:,i);
            end
        else
            air = g2f(Phi)'*double(Vf);
        end
        
        obj@EOMvector(zeros(3,1), air);
    end
    
    function c = uA(V)
        c = index(V,1);
    end
    
    function c = vA(V)
        c = index(V,2);
    end
    
    function c = wA(V)
        c = index(V,3);
    end
    
    function vel2 = norm2(V)
        vel2 = uA(V).^2 + vA(V).^2 + wA(V).^2;
    end
    
    function ang = gamma(obj)
        ang = obj.asin(-wA(obj).*invnorm(obj));
    end
    
    function ang = chi(obj)
        ang = obj.atan2(vA(obj), uA(obj));
    end
    
    function vel = norm(obj)
        vel = obj.sqrt(norm2(obj));
    end
    
    function ivel = invnorm(obj)
        ivel = obj.invsqrt(norm2(obj));
    end
    
    function ang = mu(V)
        error('Air-path bank angle not implemented yet.')
    end
end

end