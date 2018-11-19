classdef EOM6Attitude < EOMvector
% Attitude vector for 6-DOF equations of motion of the Cumulus aircraft.
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
    function obj = EOM6Attitude(varargin)
        % attitude vector [phi theta psi]
        obj@EOMvector(zeros(3,1),varargin{:});
    end
    
    function c = phi(Phi)
        c = index(Phi,1);
    end
    
    function c = theta(Phi)
        c = index(Phi,2);
    end
    
    function c = psi(Phi)
        c = index(Phi,3);
    end
    
    %% Transformation matrizes
    function M = g2f(Phi)
        % rotation from earth-fixed to body-fixed
        M = rot(phi(Phi),1)*rot(-theta(Phi),2)*rot(psi(Phi),3);
    end
    
    function M = b2g(Phi)
        % rotation from body-rates to attitude change
        M = [
        	1 	sin(phi(Phi))*tan(theta(Phi))   cos(phi(Phi))*tan(theta(Phi))
            0   cos(phi(Phi))                  -sin(phi(Phi))
            0   sin(phi(Phi))/cos(theta(Phi))   cos(phi(Phi))/cos(theta(Phi))
        ];
    end
end

end

function M = rot(a,k)
    % Creates rotation matrix for a around axis k.
    M = diag([1 cos(a) 1 cos(a) 1]);
    M(2,4) =  sin(a);
    M(4,2) = -sin(a);
    
    I = [k==1 true k==2 true k==3];
    M = M(I,I);
end
    