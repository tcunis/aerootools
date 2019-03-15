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
    CX = Cx(alpha, varargin);
    CZ = Cz(alpha, varargin);
    CM = Cm(alpha, varargin);
    CY = Cy(alpha, varargin);
    CL = Cl(alpha, varargin);
    CN = Cn(alpha, varargin);
    
    Cl = Clift(alpha, varargin);
    Cd = Cdrag(alpha, varargin);
end

methods (Static, Access=protected)     
    function argin = extend(argin)
    % Extends input parameters to 6-DOF case.

        if length(argin) < 5
            % longitudinal case
            argin = [argin(1) {0} {0} argin(2) {0} argin(3:end)];
        end
    end
end    

end