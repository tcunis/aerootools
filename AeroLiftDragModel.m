classdef (Abstract) AeroLiftDragModel
% Longitudinal aerodynamics model for an aircraft.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-01-24
% * Changed:    2018-01-24
%
%% Variables, constants, and their units
%
% * |alpha|  :  angle of attack,                                    rad
% * |Clift|  :  aerodynamic lift coefficient,                       -
% * |Cdrag|  :  aerodynamic drag coefficient,                       -
%% 

methods (Abstract)
    CL = Clift(alpha, varargin);
    CD = Cdrag(alpha, varargin);
end

methods
    function CZ = Cz(obj, alpha, varargin)
        CZ = - obj.Clift(alpha, varargin{:}).*cos(alpha) ...
             - obj.Cdrag(alpha, varargin{:}).*sin(alpha);
    end

    function CX = Cx(obj, alpha, varargin)
        CX = + obj.Clift(alpha, varargin{:}).*sin(alpha) ...
             - obj.Cdrag(alpha, varargin{:}).*cos(alpha);
    end
end

end