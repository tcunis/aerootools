classdef (Abstract) RealFunctions
% Trigonometric functions.

methods (Static,Access=protected)
    %% Trigonometric functions
    function y = sin(x)
        % Sine of argument in radians
        % override for polynomial EOM
        y = sin(x);
    end
    
    function y = cos(x)
        % Cosine of argument in radians
        % override for polynomial EOM
        y = cos(x);
    end
    
    function y = tan(x)
        % Tangens of argument in radians
        % override for polynomial EOM
        y = tan(x);
    end
    
    function y = sec(x)
        % Secant of argument in radians
        % override for polynomial EOM
        y = 1./cos(x);
    end
    
    %% Trigonometric inverses
    function x = asin(y)
        % Inverse sine in radians
        % override for polynomial EOM
        x = asin(y);
    end
    
    function x = acos(y)
        % Inverse cosine in radians
        % override for polynomial EOM
        x = acos(y);
    end
    
    function x = atan(y)
        % Inverse tangens in radians
        % override for polynomial EOM
        x = atan(y);
    end
    
    function p = atan2(y,x)
        % Four-quadrant inverse tangens in radians
        % override for polynomial EOM
        p = atan2(y,x);
    end
    
    %% Square root & Inversion
    function y = inv(x,~)
        % Array inverse
        % override for polynomial EOM
        y = 1./x;
    end
    
    function y = sqrt(x,~)
        % Square root
        % override for polynomial EOM
        y = sqrt(x);
    end
    
    function y = invsqrt(x,~)
        % Square root inverse
        % override for polynomial EOM
        y = 1./sqrt(x);
    end
end
   
end