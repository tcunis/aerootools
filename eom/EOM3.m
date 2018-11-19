classdef (Abstract) EOM3 < handle
% 3-degrees-of-freedom (longitudinal) equations of motion.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-05-27
% * Changed:    2018-11-16
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
   
properties (Access=protected)
    linear = {};
end

methods
    function func = f(obj, varargin)
        % System's function of the ordinary differential equation
        %
        %   xdot = f(x,u,mu)
        %
        varargin = {
            obj.X(varargin{1})
            obj.U(varargin{2})
            obj.mu(varargin{3:end})
        };
        
        func = [
            obj.Vdot(varargin{:})
            obj.gammadot(varargin{:})
            obj.qdot(varargin{:})
            obj.Thetadot(varargin{:}) - obj.gammadot(varargin{:})
        ];
    end
    
    function out = g(obj, varargin)
        % System's output function, i.e.
        %
        %   xdot = f(x,u,mu)
        %   yout = g(x,u,mu)
        %
        % See F
        varargin = {
            obj.X(varargin{1})
            obj.U(varargin{2})
            obj.mu(varargin{3:end})
        };

        out = [
            obj.londot(varargin{:})
            obj.altdot(varargin{:})
        ];
    end    
end

methods (Access=protected,Abstract)
    CD = Cdrag(obj, X, U, varargin);
    
    CL = Clift(obj, X, U, varargin);
    
    CM = Cm(obj, X, U, varargin);
end

methods (Static)
    function states = X(varargin)
        % Longitudinal state vector
        % X = [V gamma q alpha]
        states = EOM3States(varargin{:});
    end
    
    function inputs = U(varargin)
        % Longitudinal input vector
        % U = [eta F]
        inputs = EOM3Inputs(varargin{:});
    end
    
    function par = mu(varargin)
        % Basic parameters
        par = BasicParameters(varargin{:});
    end
    
    function output = Y(varargin)
        % Longitudinal outputs
        % Y = d[lon alt]/dt
        output = EOM3Output(varargin{:});
    end
end

methods
    function acc = Vdot(obj, X, U, varargin)
    % change in speed
        rho = obj.AC.rho;
        S   = obj.AC.S;
        m   = obj.AC.m;
        g   = obj.AC.g;
    
        acc =                                                           ...
        (                                                               ...
            obj.thrust(X,U,varargin{:}).*cos(alpha(X))                                          ...
            - 0.5*rho*V(X).^2*S.*obj.Cdrag(X,U,varargin{:})                           ...
            - m*g*sin(gamma(X))                                         ...
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
            obj.thrust(X,U,varargin{:}).*sin(alpha(X))                                          ...
            + 0.5*rho*V(X).^2*S.*obj.Clift(X,U,varargin{:})                           ...
            - m*g*cos(gamma(X))                                         ...
        )./(V(X)*m);
    end

    function ang = qdot(obj, X, U, varargin)
    % change in pitch rate
        Iy = obj.AC.I(2,2);
        
        ang = obj.M(X, U, varargin{:})/Iy;
    end
                           
    function ang = Thetadot(~, X, varargin)
    % change in pitch angle
        ang = q(X);
    end
    
    function vel = londot(~, X, varargin)
        % change of longitudinal position
        % in earth-fixed axis system
        vel = V(X)*cos(gamma(X));
    end
    
    function vel = altdot(~, X, varargin)
        % change of altitude
        vel = V(X)*sin(gamma(X));
    end
end
    
methods (Access=protected)
    function force = thrust(~, ~, U, varargin)
    % thrust force
        force = F(U);
    end
    
    function moment = M(obj, X, U, varargin)
    % Pitch moment
        rho = obj.AC.rho;
        S   = obj.AC.S;
        c   = obj.AC.c;
        
        moment = 0.5*rho*V(X).^2*S*c.*obj.Cm(X,U,varargin{:});
    end
    
    function ang = qhat(obj, X, varargin)
    % normalized pitch rate
        c   = obj.AC.c;
        
        ang = q(X)*c/V(X);
    end
end

methods
    function J = jacobian(obj, varargin)
        if isempty(obj.linear)
            obj.linear = linss.linearize(@obj.f, varargin{:});
            
            J = obj.linear.A;
        else
        
            J = obj.linear.Alin(varargin{:});
        end
    end
    
    function rQ = ctrrank(obj, v, varargin)
        if isempty(obj.linear)
            obj.linear = linss.linearize(@obj.f, varargin{:});
        else
            obj.linear = obj.linear(varargin{:});
        end

        rQ = controllable(obj.linear,v);
    end
    
    function rQ = obsrank(obj, v, varargin)
        if isempty(obj.linear)
            obj.linear = linss.linearize(@obj.f, varargin{:});
        else
            obj.linear = obj.linear(varargin{:});
        end

        rQ = observable(obj.linear,v);
    end
end
   
end
