classdef (Abstract) EOM6 < EOM3
% 6-degrees of freedom (6-DOF) equations of motion.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-01-17
% * Changed:    2018-11-16
%
%% Variables, constants, and their units
%
% * |alpha|    :  angle of attack,                              rad
% * |gamma|    :  flight-path inclination angle,                rad
% * |gammaAir| :  air-path inclination angle                    rad
% * |gammadot| :  change in inclination angle,                  rad/s
% * |zeta|     :  rudder deflection,                            rad
% * |eta|      :  elevator deflection,                          rad
% * |Theta|    :  pitch angle,                                  rad
% * |mu|       :  air-path bank angle,                          rad
% * |xi|       :  aileron deflection,                           rad
% * |rho|      :  air density,                                  kg/m^3
% * |Phi|      :  roll angle,                                   rad
% * |chi|      :  air-path/flight-path azimuth,                 rad
% * |Psi|      :  heading angle,                                rad
% * |b|        :  reference aerodynamic span,                   m
% * |c|        :  reference (mean) aerodynamic coord,           m
% * |Cl|       :  aerodynamic coefficient moment body x-axis,   -
% * |Cm|       :  aerodynamic coefficient moment body y-axis,   -
% * |Cn|       :  aerodynamic coefficient moment body z-axis,   -
% * |Cx|       :  aerodynamic coefficient force body x-axis,    -
% * |Cy|       :  aerodynamic coefficient force body y-axis,    -
% * |Cz|       :  aerodynamic coefficient force body z-axis,    -
% * |F|        :  thrust,                                       N
% * |g|        :  gravitational constant,                       m/s^2
% * |I*|       :  inertia *-axis,                               kg-m^2
% * |L|        :  roll moment, body x-axis,                     N-m
% * |m|        :  aircraft mass,                                kg
% * |M|        :  pitch moment, body y-axis,                    N-m
% * |N|        :  yaw moment, body z-axis,                      N-m
% * |p|        :  roll rate, body x-axis,                       rad/s
% * |q|        :  pitch rate, body y-axis,                      rad/s
% * |r|        :  yaw rate, body z-axis,                        rad/s
% * |*hat|     :  normalized * rate,                            rad
% * |S|        :  reference wing aera,                          m^2
% * |VA|       :  airspeed,   VA = |uA vA wA|                   m/s
% * |VK|       :  path speed, VK = |uK vK wK|                   m/s
% * |VW|       :  wind speed,                                   m/s
% * |Vdot|     :  change in speed,                              m/s^2
% * |x_cg|     :  center of gravity, body x-axis,               m
% * |x_cgref|  :  reference center of gravity, body x-axis,     m
% * |z_cg|     :  center of gravity, body z-axis,               m
% * |z_cgref|  :  reference center of gravity, body y-axis,     m
% * |Xf|       :  force body x-axis,                            N
% * |Yf|       :  force body y-axis,                            N
% * |Zf|       :  force body z-axis,                            N
%%

properties
    %AC     -- defined in EOM3
    
    %linear -- inherited from EOM3
end

methods
    function func = f(obj, varargin)
        % System's function of the ordinary differential equation
        %
        %   xdot = f(x,u,mu)
        %
        % Overriding EOM3.f
        varargin = {
            obj.X(varargin{1})
            obj.U(varargin{2})
            obj.mu(varargin{3:end})
        };
    
        func = [
            obj.Vfdot(varargin{:})
            obj.omegadot(varargin{:})
            obj.Phidot(varargin{:})
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
            obj.xgdot(varargin{:})
        ];
    end 
end

methods (Access=protected,Abstract)
    CR = Cr(obj, X, U, varargin); % aerodynamic force coefficients

    CQ = Cq(obj, X, U, varargin); % aerodynamic moment coefficients
end

methods (Static)
    function states = X(varargin)
        % 6-DOF state vector
        % X = [uA vA wA | p q r | Phi Theta Psi]
        %
        % Overriding EOM3.X
        states = EOM6States(varargin{:});
    end
    
    function inputs = U(varargin)
        % 6-DOF input vector
        % U = [xi eta zeta | F]
        %
        % Overriding EOM3.U
        inputs = EOM6Inputs(varargin{:});
    end
    
    function output = Y(varargin)
        % 6-DOF outputs
        % Y = d[xg yg zg]/dt
        output = EOM6Output(varargin{:});
    end
end
            
methods (Access=protected)
    function ang = omegahat(obj, X, varargin)
        % normalized body rates
        b = obj.AC.b;
        c = obj.AC.c;
        
        ang = diag([b c b])*omega(X)/VA(X);
    end
    
    function RF = Rf(obj, X, varargin)
        % aerodynamic/thrust forces body axis system
        rho = obj.AC.rho;
        S   = obj.AC.S;
    
        F = obj.thrust(X,varargin{:});
        
        RF = 0.5*rho*S*VA(X)^2*obj.Cr(X,varargin{:}) + [F; 0; 0];
    end

    function QF = Qf(obj, X, varargin)
        % aerodynamic moments body axis system
        rho = obj.AC.rho;
        S   = obj.AC.S;
        b   = obj.AC.b;
        c   = obj.AC.c;
        
        QF = 0.5*rho*S*VA(X)^2*diag([b c b])*obj.Cq(X,varargin{:});
    end
    
    function RA = Ra(obj, X, varargin)
        % resulting aerodynamic/thrust forces air-path axis system
        % (corresponds to effective lift, drag, and side-force)
        
        RA = f2a(X)*obj.Rf(X,varargin{:});
    end
    
    function QR = Qr(obj, X, varargin)
        % resulting moments
        I = obj.AC.I;
        
        QF = obj.Qf(X,varargin{:});
        QR = QF - cross(omega(X), I*omega(X));
    end
end
   
methods
    function acc = Vfdot(obj, X, varargin)
        % change in speed
        % in body-fixed axis system
        %
        %   dVf/dt = d[u v w]/dt
        %
        m = obj.AC.m;
        g = obj.AC.g;
    
        RF = obj.Rf(X,varargin{:});
        acc = RF/m + g2f(X)*[0; 0; g] - cross(omega(X), Vf(X));
    end

    function ang = omegadot(obj, varargin)
        % change of rates
        %
        %   domega/dt = d[p q r]/dt
        %
        I = obj.AC.I;
        
        ang = I\obj.Qr(varargin{:});
    end

    function ang = Phidot(~, X, varargin)
        % change of attitude
        %
        %   dPhi'/dt = d[phi theta]/dt
        %    psidot  = dpsi/dt
        %
        ang = b2g(X)*omega(X);
    end
    
    function ang = psidot(obj, varargin)
        % change of heading
        
        ang = Phidot(obj, varargin{:});
        ang = ang(3,:);
    end
    
    function vel = xgdot(~, X, varargin)
        % change of position
        % in earth-fixed axis system
        %
        %   dxg/dt = d[x y z]g/dt
        %
        vel = VAg(X);
    end
end

methods (Access=protected)
    %% Implement inherited EOM3 interface
    function CD = Cdrag(obj, X, varargin)
        % Drag coefficient -- implementing EOM3.Cdrag
        CR = obj.Cr(X,varargin{:});
        
        CD = -CR(3,:).*sin(alpha(X)) - CR(1,:).*cosa(alpha(X));
    end
    
    function CL = Clift(obj, X, varargin)
        % Lift coefficient -- implementing EOM3.Clift
        CR = obj.Cr(X, varargin{:});
        
        CL = -CR(3,:).*cos(alpha(X)) + CR(1,:).*sin(X(alpha));
    end
    
    function CM = Cm(obj, varargin)
        % Pitch-moment coefficient -- implementing EOM3.Cm
        CQ = obj.Cq(varargin{:});
        
        CM = CQ(2,:);
    end
end

end
