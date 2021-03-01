classdef (Abstract) EOM3 < aerootools.pkg.RealFunctions
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
        varargin = obj.parse(varargin);

        func = obj.sysfun(varargin{:});
    end
    
    function out = g(obj, varargin)
        % System's output function, i.e.
        %
        %   xdot = f(x,u,mu)
        %   yout = g(x,u,mu)
        %
        % See F
        varargin = obj.parse(varargin);

        out = obj.outfun(varargin{:});
    end    
end

methods (Access=protected,Abstract)
    CD = Cdrag(obj, X, U, varargin);
    
    CL = Clift(obj, X, U, varargin);
    
    CM = Cm(obj, X, U, varargin);
end

methods (Access=protected)
    function func = sysfun(obj, varargin)
        % System function.
        func = [
            obj.Vdot(varargin{:})
            obj.gammadot(varargin{:})
            obj.qdot(varargin{:})
            obj.Thetadot(varargin{:}) - obj.gammadot(varargin{:})
        ];
    end
    
    function out = outfun(obj, varargin)
        % Output function.
        out = [
            obj.londot(varargin{:})
            obj.altdot(varargin{:})
        ];
    end
    
    function argout = parse(obj,argin)
        % Parse arguments.
        argout = {
            obj.X(argin{1})
            obj.U(argin{2})
            obj.mu(argin{3:end})
        };
    end
end

methods (Static)
    function states = X(varargin)
        % Longitudinal state vector
        % X = [V gamma q alpha]
        states = aerootools.pkg.EOM3States(varargin{:});
    end
    
    function inputs = U(varargin)
        % Longitudinal input vector
        % U = [eta F]
        inputs = aerootools.pkg.EOM3Inputs(varargin{:});
    end
    
    function par = mu(varargin)
        % Basic parameters
        par = aerootools.pkg.BasicParameters(varargin{:});
    end
    
    function output = Y(varargin)
        % Longitudinal outputs
        % Y = d[lon alt]/dt
        output = aerootools.pkg.EOM3Output(varargin{:});
    end
end

methods (Access=protected)
    function acc = Vdot(obj, varargin)
    % change in speed
        m   = obj.AC.m;
        g   = obj.AC.g;
    
        acc = ( ...
            obj.thrust(varargin{:}).*obj.cos(obj.attack(varargin{:})) ...
            - obj.drag(varargin{:}) ...
            - m*g*obj.sin(obj.inclination(varargin{:})) ...
        )/m;
    end
    
    function ang = gammadot(obj, varargin)
    % change in flight-path angle
        m   = obj.AC.m;
        g   = obj.AC.g;
    
        ang = ( ...
            obj.thrust(varargin{:}).*obj.sin(obj.attack(varargin{:})) ...
            + obj.lift(varargin{:}) ...
            - m*g*obj.cos(obj.inclination(varargin{:})) ...
        ).*obj.Vinv(varargin{1})/m;
    end

    function ang = qdot(obj, varargin)
    % change in pitch rate
        Iy = obj.AC.I(2,2);
        
        ang = obj.M(varargin{:})/Iy;
    end
                           
    function ang = Thetadot(~, X, varargin)
    % change in pitch angle
        ang = q(X);
    end
end

methods
    function vel = londot(obj, X, U, varargin)
        % change of longitudinal position
        % in earth-fixed axis system
        vel = V(X).*obj.cos(gamma(X)).*ones(1,size(U,2));
    end
    
    function vel = altdot(obj, X, U, varargin)
        % change of altitude
        vel = V(X).*obj.sin(gamma(X)).*ones(1,size(U,2));
    end
    
    function nz = loadfactor(obj, varargin)
        % load factor
        w = obj.AC.w;
        
        nz = ( ...
            obj.lift(varargin{:}).*obj.cos(obj.attack(varargin{:})) ...
            + obj.drag(varargin{:}).*obj.sin(obj.attack(varargin{:})) ...
        )/w;
    end
    
    function force = thrust(~, ~, U, varargin)
        % thrust force
        force = F(U);
    end
    
    function speed = airspeed(~, X, varargin)
        % Speed with respective to air.
        speed = V(X);
    end
    
    function ang = inclination(~, X, varargin)
        % Path inclination angle with respective to air.
        ang = gamma(X);
    end
    
    function ang = attack(~, X, varargin)
        % Angle of attack.
        ang = alpha(X);
    end
    
    function ang = qhat(obj, X, varargin)
    % normalized pitch rate
        c   = obj.AC.c;
        
        ang = c*q(X).*obj.inv(obj.airspeed(X,varargin{:}))/2;
    end
end

methods (Access=protected)
    function force = lift(obj, varargin)
        % lift force
        rho = obj.AC.rho;
        S = obj.AC.S;
        
        force = 0.5*rho*S*obj.airspeed(varargin{:}).^2.*obj.Clift(varargin{:});
    end
    
    function force = drag(obj, varargin)
        % drag force
        rho = obj.AC.rho;
        S = obj.AC.S;
        
        force = 0.5*rho*S*obj.airspeed(varargin{:}).^2.*obj.Cdrag(varargin{:});
    end
    
    function moment = M(obj, varargin)
        % Pitch moment
        rho = obj.AC.rho;
        S   = obj.AC.S;
        c   = obj.AC.c;
        
        moment = 0.5*rho*S*c*obj.airspeed(varargin{:}).^2.*obj.Cm(varargin{:});
    end
        
    function iv = Vinv(obj, X, varargin)
    % inverse air speed
        iv = obj.inv(V(X));
    end
end

methods
    function obj = linearize(obj, varargin)
        % Create linearized system model.
        
        obj.linear = linss.linearize(@obj.f, varargin{:});
    end
    
    function J = jacobian(obj, varargin)
        if isempty(obj.linear)
            warning('Linearized system model not created yet. Call EOM3.linearize first for increased speed.');
            obj = linearize(obj, varargin{:});
            
            J = obj.linear.A;
        else
        
            J = obj.linear.Alin(varargin{:});
        end
    end
    
    function rQ = ctrrank(obj, v, varargin)
        if isempty(obj.linear)
            obj = linearize(obj, varargin{:});
        else
            obj.linear = obj.linear(varargin{:});
        end

        rQ = controllable(obj.linear,v);
    end
    
    function rQ = obsrank(obj, v, varargin)
        if isempty(obj.linear)
            obj = linearize(obj, varargin{:});
        else
            obj.linear = obj.linear(varargin{:});
        end

        rQ = observable(obj.linear,v);
    end
end

methods (Static,Access=protected)
end

end