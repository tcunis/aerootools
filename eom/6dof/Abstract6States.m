classdef (Abstract) Abstract6States < EOMvector & EOM3States
% Abstract 6-DOF states.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-10-09
% * Changed:    2018-03-20
%
%% See also
%
% See EOM6DOF
%
%%

properties (Abstract,Access=protected)
    vel;
    rate;
    att;
    
    air;
end

methods (Static)
    function X = wind2body(V, alpha, beta, varargin)
        % convert wind axis to (V,alpha,beta) to body axis (u,v,w) system.
        
        X = [
            V*cos(alpha)*cos(beta)
            V*sin(beta)
            V*sin(alpha)*cos(beta)
            vertcat(varargin{:})
        ];
    end
end

methods
    function obj = Abstract6States(varargin)
        if nargin == 1 && isa(varargin{1},'Abstract6States')
            % nothing to do
        elseif EOM3States.check([],[],varargin{:}) > 0
            % [VA gamma q alpha]
            X3 = EOM3States(varargin{:});

            varargin = {[[V(X3)*cos(alpha(X3)); 0; V(X3)*sin(alpha(X3))]; [0; q(X3); 0]; [0; theta(X3); 0]]};
        end
        
        % 6-DOF state vector [vA | omega | Phi]
        obj@EOMvector([], varargin{:});        
    end
    
    %% States
    function st = Vf(X)
        % Velocity vector in body axis system
        %
        %   Vf = [xAf yAf zAf]^T
        %
        st = double(X.vel);
    end
        
    function st = omega(X)
        % Body rate vector
        %
        %   omega = [p q r]^T
        %
        st = double(X.rate);
    end
    
    function st = Phi(X)
        % Attitude vector
        %
        %   Phi = [phi theta psi]^T
        %
        st = double(X.att);
    end
    
    %% Auxiliaries
    function aux = VA(X)
        % Air speed
        aux = norm(X.vel);
    end
    
    function aux = VA2(X)
        % Squared air speed
        aux = norm2(X.vel);
    end
    
    function aux = invVA(X)
        % Inverse air speed
        aux = invnorm(X.vel);
    end
    
    function aux = alpha(X)
        % Angle of attack -- overriding EOM3States.alpha
        aux = alpha(X.vel);
    end
    
    function aux = beta(X)
        % Side-slip angle
        aux = beta(X.vel);
    end
    
    function aux = gamma(X)
        % Path inclination angle -- overriding EOM3States.theta
        aux = gamma(X.air);
    end
    
    function aux = chi(X)
        % Path azimuth angle
        aux = chi(X.air);
    end
    
    function aux = VAg(X)
        % Velocity vector in earth-fixed axis system
        aux = double(X.air);
    end
    
    %% Transformation matrizes
    function M = g2f(X)
        M = g2f(X.att);
    end
    
    function M = b2g(X)
        M = b2g(X.att);
    end
    
    %% Implement inherited EOM3 interface
    function st = V(X)
        % Overriding EOM3States.V
        st = VA(X);
    end
    
    function st = q(X)
        % Overriding EOM3States.q
        st = q(X.rate);
    end
    
    function aux = theta(X)
        % Overriding EOM3States.theta
        aux = theta(X.att);
    end
    
    %% Extended EOM6 interface
    function st = phi(X)
        % Bank angle.
        st = phi(X.att);
    end
    
    function st = p(X)
        % Roll rate.
        st = p(X.rate);
    end
    
    function st = r(X)
        % Yaw rate.
        st = r(X.rate);
    end
end

methods (Static, Access=protected)
    function [tf,default] = check(obj, ~, varargin)
        % Overriding EOM3States.check
        if isempty(obj)
            obj = EOM6States;
        end
        
        [tf,default] = check@EOMvector(obj,[1; zeros(8,1)],varargin{:});
    end
end

end