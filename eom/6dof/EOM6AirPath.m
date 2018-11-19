classdef EOM6AirPath < EOMvector
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
        if size(Vf,2) > 1
            air = zeros(size(Vf));
            for i=1:length(Vf)
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
    
    function vel = norm(V)
        vel = sqrt(uA(V).^2 + vA(V).^2 + wA(V).^2);
    end
    
    function ang = gamma(V)
        ang = asin(-wA(V)./norm(V));
    end
    
    function ang = chi(V)
        ang = atan2(vA(V), uA(V));
    end
    
    function ang = mu(V)
        error('Air-path bank angle not implemented yet.')
    end
end

end