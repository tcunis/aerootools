classdef (Abstract) PiecewiseModel < AbstractAeroModel & AeroXZModel
% Abstract super-class of piece-wise defined aerodynamic models.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-03-14
% * Changed:    2019-03-15
%
%%    

properties (Abstract)
    alpha0;
    pre;    % < AbstractAeroModel
    post;   % < AbstractAeroModel
end

methods
    function CX = Cx(obj, varargin)
        varargin = obj.extend(varargin);
        
        CX = obj.piecewise(@Cx,varargin{:});
    end
    
    function CZ = Cz(obj, varargin)
        varargin = obj.extend(varargin);
        
        CZ = obj.piecewise(@Cz,varargin{:});
    end
    
    function CM = Cm(obj, varargin)
        varargin = obj.extend(varargin);
        
        CM = obj.piecewise(@Cm,varargin{:});
    end
    
    function CY = Cy(obj, varargin)
        varargin = obj.extend(varargin);
        
        CY = obj.piecewise(@Cy,varargin{:});
    end
    
    function CL = Cl(obj, varargin)
        varargin = obj.extend(varargin);
        
        CL = obj.piecewise(@Cl,varargin{:});
    end
    
    function CN = Cn(obj, varargin)
        varargin = obj.extend(varargin);
        
        CN = obj.piecewise(@Cn,varargin{:});
    end
    
    function N = nargin(obj)
        % number of inputs
        % piecewise sub-models
        N = nargin(obj.pre);
    end
end

methods (Access=private)
    function coeff = piecewise(obj, Chan, alpha, varargin)
        % Evaluate piecewise defined coefficient.
        
        c = (alpha <= obj.alpha0);
        p1 = Chan(obj.pre, alpha, varargin{:});
        p2 = Chan(obj.post,alpha, varargin{:});
        
        coeff = c.*p1 + (1-c).*p2;
    end
end

end