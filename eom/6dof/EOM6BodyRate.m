classdef EOM6BodyRate < EOMvector
% Body rate vector for 6-DOF equations of motion of the Cumulus aircraft.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-10-09
% * Changed:    2018-10-09
%
%% See also
%
% See EOM6States
%
%%

properties (Access=protected)
end

methods
    function obj = EOM6BodyRate(varargin)
        % body rate vector [p q r]
        obj@EOMvector(zeros(3,1),varargin{:});
    end
    
    function c = p(omega)
        c = index(omega,1);
    end
    
    function c = q(omega)
        c = index(omega,2);
    end
    
    function c = r(omega)
        c = index(omega,3);
    end
end

end