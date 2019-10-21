classdef SimpleActuator6
% Actuator dynamics with integrator (surfaces) and feed-through (thrust).
%
% These simple actuator dynamics can be modeled as linear system
%
%          | 1 0 0 0 |
%   xdot = | 0 1 0 0 |*u
%          | 0 0 1 0 |
%
%          | I |     | 0 |
%      y = |---|*x + |---|*u
%          | 0 |     | 1 |
%
% where x = [xi, eta, zeta], u = [dxi, deta, dzeta, F], and y = [x, F].
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:tcunis@umich.edu>
% * Created:    2018-11-30
% * Changed:    2019-10-21
%
%% Variables, constants, and their units
%
% * |xi|       :  aileron deflections,                          rad
% * |eta|      :  elevator deflection,                          rad
% * |zeta|     :  rudder deflection,                            rad
% * |dxi|      :  (commanded) change of aileron deflection,     rad/s
% * |deta|     :  (commanded) change of elevator deflection,    rad/s
% * |dzeta|    :  (commanded) change of rudder deflection,      rad/s
% * |F|        :  thrust,                                       N
%
%%

properties (Access=protected)
end

methods
    function xdot = f(obj, varargin)
        % Actuator dynamic ODE
        %
        %   xdot = f(x,u)
        %
        varargin = {
            obj.X(varargin{1})
            obj.U(varargin{2})
        };
    
        xdot = [
            obj.surfacesdot(varargin{:})
            obj.Fdot(varargin{:})
        ];
    end
    
    function yout = g(obj, varargin)
        % Actuator output function
        %
        %   xdot = f(x,u)
        %   yout = g(x,u)
        %
        % See F
        varargin = {
            obj.X(varargin{1})
            obj.U(varargin{2})
        };
    
        yout = [
            obj.surfaces(varargin{:})
            obj.F(varargin{:})
        ];
    end
end

methods (Static)
    function states = X(varargin)
        % Actuator states
        states = aerootools.actuator.Actuator6States(varargin{:});
    end
    
    function inputs = U(varargin)
        % Actuator inputs
        inputs = aerootools.actuator.Actuator6Inputs(varargin{:});
    end
    
    function output = Y(varargin)
        % Actuator output
        output = aerootools.actuator.Actuator6Output(varargin{:});
    end
end

methods 
    function rate = surfacesdot(~,~,U,varargin)
        % Change of elevator
        rate = [
             dxi(U)
            deta(U)
           dzeta(U)
        ];
    end
    
    function jerk = Fdot(~,varargin)
        % Change of thrust force
        jerk = [];
    end
    
    function ang = surfaces(~,X,varargin)
        % Elevator deflection
        ang = [
             xi(X)
            eta(X)
           zeta(X)
        ];
    end
    
    function acc = F(~,~,U,varargin)
        % Thrust force
        acc = F(U);
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
end

end