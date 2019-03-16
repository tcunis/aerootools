classdef (Abstract) AbstractAeroModel
% Abstract super-class of 6-dof aerodynamic models.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2019-03-15
% * Changed:    2019-03-15
%
%%    

methods (Abstract)
    CX = Cx(obj, alpha, varargin);
    CZ = Cz(obj, alpha, varargin);
    CM = Cm(obj, alpha, varargin);
    CY = Cy(obj, alpha, varargin);
    CL = Cl(obj, alpha, varargin);
    CN = Cn(obj, alpha, varargin);
    
    Cl = Clift(obj, alpha, varargin);
    Cd = Cdrag(obj, alpha, varargin);
    
    N = nargin(obj);
end

methods (Access=protected)     
    function argin = extend(obj, argin)
    % Extends input parameters to 6-DOF case.

        if length(argin) < nargin(obj)
            if length(argin) > 2
                % rates              p     q      r
                argin = [argin(1:2) {0} argin(3) {0} argin(4:end)];
            end
            
            % longitudinal case
            %           a      b   x     e      z  [ p  q  r ]
            argin = [argin(1) {0} {0} argin(2) {0} argin(3:end)];
        end
    end
end    

end