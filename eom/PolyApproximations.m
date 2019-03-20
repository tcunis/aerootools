classdef (Abstract) PolyApproximations < RealFunctions
% Trigonometric functions.

methods (Static,Access=protected)
    %% Trigonometric functions
    function y = sin(x)
        % Sine partial sum in radians
        % overriding RealFunctions.sin
        y = x - x.^3/6 + x.^5/120;
    end
    
    function y = cos(x)
        % Cosine partial sum in radians
        % overriding RealFunctions.cos
        y = 1 - x.^2/2 + x.^4/24;
    end
    
    function y = tan(x)
        % Tangens partial sum in radians
        % overriding RealFunctions.tan
        y = x + x.^3/3 + 2*x.^5/15;
    end
    
    function y = sec(x)
        % Secant partial sum in radians
        % overriding RealFunctions.sec
        y = 1 + x.^2/2 + 5*x.^4/24;
    end
    
    %% Trigonometric inverses
    function x = asin(y)
        % Inverse sine partial sum in radians
        % overriding RealFunctions.asin
        x = y + y.^3/6 + 3*y.^5/40;
    end
    
    function x = acos(y)
        % Inverse cosine partial sum in radians
        % overriding RealFunctions.acos
        x = pi/2 - PolyApproximations.asin(y);
    end
    
    function x = atan(y)
        % Inverse tangens partial sum in radians
        % overriding RealFunctions.atan
        warning('Utilities:Aero:polyatan', 'Use of polynomial atan is not recommended.');
        
        x = y - y.^3/3 + y.^5/5;
    end
    
    function p = atan2(y,x)
        % Four-quadrant inverse tangens in radians
        % override for polynomial EOM
        error('Utilities:Aero:polyatan2', 'Polynomial atan2 is not implemented.');
    end
    
    %% Square root & Inversion
    function y = inv(x,x0)
        % Inverse partial sum
        % overriding RealFunctions.inv
        y = 1./x0 - 1./x0.^2.*(x-x0) + 2./x0.^3.*(x-x0).^2 - 6./x0.^4.*(x-x0).^3;
    end
    
    function y = sqrt(x,x0)
        % Square root
        % override for polynomial EOM
        y = sqrt(x0) + sqrt(x0).^-1/2.*(x-x0) - sqrt(x0).^-3/4.*(x-x0).^2 + 3*sqrt(x0).^-5/8.*(x-x0).^3;
    end
    
    function y = invsqrt(x,x0)
        % Square root inverse
        % override for polynomial EOM
        y = 1./sqrt(x0) - 1./sqrt(x0).^3/2.*(x-x0) + 3./sqrt(x0).^5/4.*(x-x0).^2 - 15./sqrt(x0).^7/8.*(x-x0).^3;
    end
end
   
end