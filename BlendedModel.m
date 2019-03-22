classdef (Abstract) BlendedModel < AbstractAeroModel & AeroXZModel
% Abstract super-class of blended aerodynamic models.
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

properties (Access=protected)
    mu;
end

methods
    function obj = BlendedModel(epsilon)
        % Blended model with blending paramter epsilon.
        
        if nargin < 1
            obj.mu = 0;
        else
            obj.mu = epsilon;
        end
    end
    
    function CX = Cx(obj, varargin)
        varargin = obj.extend(varargin);
        
        CX = obj.blended(@Cx,varargin{:});
    end
    
    function CZ = Cz(obj, varargin)
        varargin = obj.extend(varargin);
        
        CZ = obj.blended(@Cz,varargin{:});
    end
    
    function CM = Cm(obj, varargin)
        varargin = obj.extend(varargin);
        
        CM = obj.blended(@Cm,varargin{:});
    end
    
    function CY = Cy(obj, varargin)
        varargin = obj.extend(varargin);
        
        CY = obj.blended(@Cy,varargin{:});
    end
    
    function CL = Cl(obj, varargin)
        varargin = obj.extend(varargin);
        
        CL = obj.blended(@Cl,varargin{:});
    end
    
    function CN = Cn(obj, varargin)
        varargin = obj.extend(varargin);
        
        CN = obj.blended(@Cn,varargin{:});
    end
    
    function N = nargin(obj)
        % number of inputs
        % sub-models + blending parameter
        N = nargin(obj.pre) + 1;
    end
end

methods (Access=protected)
    function argin = extend(obj, argin)
        % Override AbstractAeroModel.extend
        eps = {0};
        
        if length(argin) == nargin(obj)
            return; %nothing to do
        elseif length(argin) > 2 && length(argin) < nargin(obj.pre)
            eps = argin(end);
            argin = extend@AbstractAeroModel(obj,argin(1:end-1));
        else
            argin = extend@AbstractAeroModel(obj,argin);
        end
        
        % if length(argin) < 6
        argin = [argin eps];
    end
end

methods (Access=private)
    function coeff = blended(obj, Chan, alpha, varargin)
        % Evaluate blended coefficient.
                
        eps = varargin{end};

        h = 1./(1 + exp(-4*(alpha-obj.alpha0)/(obj.mu+eps)));
        
        p1 = Chan(obj.pre, alpha, varargin{1:4});
        p2 = Chan(obj.post,alpha, varargin{1:4});
        coeff = (1-h).*p1 + h.*p2;
    end
end

end