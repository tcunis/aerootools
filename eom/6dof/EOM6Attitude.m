classdef EOM6Attitude < EOMvector & RealFunctions
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
    function M = g2f(obj)
        % rotation from earth-fixed to body-fixed
        M = obj.rot(phi(obj),1)*obj.rot(-theta(obj),2)*obj.rot(psi(obj),3);
    end
    
    function M = b2g(obj)
        % rotation from body-rates to attitude change
        M = [
        	1 	obj.sin(phi(obj))*obj.tan(theta(obj))   obj.cos(phi(obj))*obj.tan(theta(obj))
            0   obj.cos(phi(obj))                      -obj.sin(phi(obj))
            0   obj.sin(phi(obj))*obj.sec(theta(obj))   obj.cos(phi(obj))*obj.sec(theta(obj))
        ];
    end
end

methods (Access=private)
    function M = rot(obj,a,k)
        % Creates rotation matrix for a around axis k.
        M = diag([1 obj.cos(a) 1 obj.cos(a) 1]);
        M(2,4) =  obj.sin(a);
        M(4,2) = -obj.sin(a);

        I = [k==1 true k==2 true k==3];
        M = M(I,I);
    end
end
    
end
