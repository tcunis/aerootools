classdef (Abstract) AeroXZModel
% Longitudinal aerodynamics model for an aircraft.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-03-12
% * Changed:    2018-03-12
%
%% Variables, constants, and their units
%
% * |alpha|  :  angle of attack,                                    rad
% * |Cx|     :  aerodynamic coefficient force body x-axis,          -
% * |Cz|     :  aerodynamic coefficient force body z-axis,          -
%% 

methods (Abstract)
    CX = Cx(alpha, varargin);
    CZ = Cz(alpha, varargin);
end

methods
    function CL = Clift(obj, alpha, varargin)
        CL = - obj.Cz(alpha, varargin{:}).*cos(alpha) ...
             + obj.Cx(alpha, varargin{:}).*sin(alpha);
    end

    function CD = Cdrag(obj, alpha, varargin)
        CD = - obj.Cz(alpha, varargin{:}).*sin(alpha) ...
             - obj.Cx(alpha, varargin{:}).*cos(alpha);
    end
end

end