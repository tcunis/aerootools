classdef EOM3
% 3 degrees of freedom (longitudinal) equations of motion.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-05-27
% * Changed:    2018-05-27
%
%% Variables, constants, and their units
%
% * |alpha|    :  angle of attack,                              rad
% * |gamma|    :  flight-path angle,                            rad
% * |gammadot| :  change in flight-path angle,                  rad/s
% * |eta|      :  elevator deflection,                          rad
% * |rho|      :  air density,                                  kg/m^3
% * |b|        :  reference aerodynamic span,                   m
% * |c|        :  reference (mean) aerodynamic coord,           m
% * |Cdrag|    :  aerodynamic drag coefficient,                 -
% * |Clift|    :  aerodynamic lift coefficient,                 -
% * |Cm|       :  aerodynamic coefficient moment body y-axis,   -
% * |Cx|       :  aerodynamic coefficient force body x-axis,    -
% * |Cz|       :  aerodynamic coefficient force body z-axis,    -
% * |g|        :  gravitational constant,                       m/s^2
% * |m|        :  aircraft mass,                                kg
% * |M|        :  pitch moment, body y-axis,                    N-m
% * |q|        :  pitch rate, body y-axis,                      rad/s
% * |qhat|     :  normalized pitch rate, body y-axis            rad
% * |S|        :  reference wing aera,                          m^2
% * |T|        :  thrust,                                       N
% * |V|        :  airspeed,                                     m/s
% * |Vdot|     :  change in airspeed,                           m/s^2
% * |w|        :  aircraft weight,                              N
%%

properties (Access=protected,Abstract)
    AC;
end
   
properties (Access=private)
    linear = {};
end

methods
    function obj = EOM3
        obj.linear = @(varargin) linss.linearize(@obj.f, varargin{:});
    end
    
    function func = f(obj, varargin)
        if nargin < 3
            func = @obj.f;
            return
        end
        
        %else
        func = [
            obj.Vdot(varargin{:});
            obj.gammadot(varargin{:});
            obj.qdot(varargin{:});
            obj.Thetadot(varargin{:}) - obj.gammadot(varargin{:});
        ];
    end
    
    function J = jacobian(obj, varargin)
        obj.linear = obj.linear(varargin{:});
        
        J = jacobian(obj.linear);
    end
end

methods (Access=protected,Abstract)
    CD = Cdrag(obj, X, U, varargin);
    
    CL = Clift(obj, X, U, varargin);
    
    CM = Cm(obj, X, U, varargin);
end

methods (Static)
    function states = X(V, gamma, q, alpha)
        if nargin == 0
            states = [1; zeros(3,1)];
        else
            states = [V; gamma; q; alpha];
        end
    end
    
    function inputs = U(eta, T)
        if nargin == 0
            inputs = zeros(2,1);
        else
            inputs = [eta; T];
        end
    end
    
    function st = V(X)
        st = X(1,:);
    end
    
    function st = gamma(X)
        st = X(2,:);
    end
    
    function st = q(X)
        st = X(3,:);
    end
    
    function st = alpha(X)
        st = X(4,:);
    end
    
    function in = eta(U)
        in = U(1,:);
    end
    
    function in = F(U)
        in = U(2,:);
    end
end

methods (Access=protected)
    function F = thrust(obj, ~, U, varargin)
    % thrust force
        F = obj.F(U);
    end
    
    function moment = M(obj, X, U, varargin)
    % pitch moment
        rho = obj.AC.rho;
        S   = obj.AC.S;
        c   = obj.AC.c;
        
        moment = 0.5*rho*obj.V(X).^2*S*c.*obj.Cm(X,U,varargin{:});
    end
    
    function acc = Vdot(obj, X, U, varargin)
    % change in speed
        rho = obj.AC.rho;
        S   = obj.AC.S;
        m   = obj.AC.m;
        g   = obj.AC.g;
    
        acc =                                                           ...
        (                                                               ...
            obj.thrust(X,U,varargin{:}).*cos(obj.alpha(X))                                          ...
            - 0.5*rho*obj.V(X).^2*S.*obj.Cdrag(X,U,varargin{:})                           ...
            - m*g*sin(obj.gamma(X))                                         ...
        )/m;    
    end
    
    function ang = gammadot(obj, X, U, varargin)
    % change in flight-path angle
        rho = obj.AC.rho;
        S   = obj.AC.S;
        m   = obj.AC.m;
        g   = obj.AC.g;
    
        ang =                                                           ...
        (                                                               ...
            obj.thrust(X,U,varargin{:}).*sin(obj.alpha(X))                                          ...
            + 0.5*rho*obj.V(X).^2*S.*obj.Clift(X,U,varargin{:})                           ...
            - m*g*cos(obj.gamma(X))                                         ...
        )./(obj.V(X)*m);
    end

    function ang = qdot(obj, X, U, varargin)
    % change in pitch rate
        Iy = obj.AC.I(2,2);
        
        ang = obj.M(X, U, varargin{:})/Iy;
    end
                           
    function ang = Thetadot(obj, X, varargin)
    % change in pitch angle
        ang = obj.q(X);
    end
    
    function ang = qhat(obj, X, varargin)
    % normalized pitch rate
        c   = obj.AC.c;
        
        ang = obj.q(X)*c./obj.V(X);
    end
end
   
end
