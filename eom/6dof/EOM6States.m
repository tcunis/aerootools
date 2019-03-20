classdef EOM6States < Abstract6States
% States of the 6-DOF equations of motion of the Cumulus aircraft.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-10-09
% * Changed:    2019-03-20
%
%% See also
%
% See EOM6DOF
%
%%

properties (Access=protected)
    vel;
    rate;
    att;
    
    air;
end

methods
    function obj = EOM6States(varargin)
        % 6-DOF state vector [vA | omega | Phi]
        obj@Abstract6States(varargin{:});
        
        obj.vel  = EOM6Velocity(obj.v(1:3,:));
        obj.rate = EOM6BodyRate(obj.v(4:6,:));
        obj.att  = EOM6Attitude(obj.v(7:end,:));
        
        obj.air = EOM6AirPath(obj.vel, obj.att);
    end
end

end