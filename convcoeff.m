function varargout = convcoeff(Cx_drag, Cz_lift, varargin)
% Convert between (Cx, Cz) and (Cdrag, Clift).
%
%% Usage and description
%
%   [Cx, Cz] = convcoeff(Cdrag, Clift, 'xz')
%   [Cdrag, Clift] = convcoeff(Cx, Cz, 'draglift')
%   [...] = convcoeff(..., alphas)
%   [...] = convcoeff(..., sin, cos)
%   [Cx, Cz, Cdrag, Clift] = convcoeff(...)
%
% Converts (Cx, Cz) to (Cdrag, Clift) and vice-versa. Input coefficients
% must be functions of alpha and, facultatively, eta and/or q; output 
% coefficients will be same-wise. Trigonometric functions |sin|, |cos| can
% be given; otherwise, built-in trigonometric functions are used.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2017-02-24
% * Changed:    2017-02-24
%
%% Variables, constants, and their units
%
% * |alpha|    :  angle of attack,                              rad
% * |eta|      :  elevator deflection,                          rad
% * |Cdrag|    :  aerodynamic drag coefficient,                 -
% * |Clift|    :  aerodynamic lift coefficient,                 -
% * |Cx|       :  aerodynamic coefficient force body x-axis,    -
% * |Cz|       :  aerodynamic coefficient force body z-axis,    -
%
%%

for i=1:length(varargin)
    arg = varargin{i};
    if ~exist('type', 'var') && ischar(arg), type = arg;
    elseif ~exist('alphas', 'var') && isnumeric(arg) || isa(arg, 'Angle')
                                                               alphas = arg;
    elseif ~exist('alpha', 'var') && isa(arg,'polynomial'),     alpha = arg;
    elseif ~exist('sina', 'var') && isa(arg, 'function_handle'), sina = arg;
    elseif ~exist('cosa', 'var') && isa(arg, 'function_handle'), cosa = arg;
    end
end
if ~exist('type', 'var'),   type = 'draglift';                          end % default is (Cx, Cz) to (Cdrag, Clift)


if ~exist('sina', 'var') && ~exist('cosa', 'var')
    sina = @sin;
    cosa = @cos;
else
    assert(exist('sina', 'var') && exist('cosa', 'var'), 'Both sine and cosine functions must be provided, or neither.');
end

if isa(Cx_drag, 'function_handle')
    output = 'function';
elseif isa(Cx_drag, 'polynomial') || isa(Cx_drag, 'splinemodel')
    output = 'polynomial';
    
    if ~exist('alpha','var')
        alpha = pvar('alpha');
    end
else
    output = 'array';
    
    assert(exist('alphas', 'var') > 0, 'Conversion of coefficient matrizes: missing vector of angles of attack.');
    assert(length(alphas) == length(Cx_drag), 'Conversion of coefficient matrizes: dimension mismatch.');
    assert(length(alphas) == length(Cz_lift), 'Conversion of coefficient matrizes: dimension mismatch.');
end

switch type
    case 'draglift'
        %% Lift, drag coefficients
        % functions of alpha, eta, and optionally q
        Cz = Cz_lift;
        Cx = Cx_drag;
    
        switch output
            case 'array'
                Clift = - Cz.*cosa(alphas) ...
                        + Cx.*sina(alphas);
                    
                Cdrag = - Cz.*sina(alphas) ...
                        - Cx.*cosa(alphas);
            
            case 'polynomial'
                Clift = - Cz*cosa(alpha) ...
                        + Cx*sina(alpha);
                    
                Cdrag = - Cz*sina(alpha) ...
                        - Cx*cosa(alpha);

            %case 'function'
            otherwise
                % aerodynamic lift coefficient, force negative air z-axis
                % coefficient is dimensionless by definition
                Clift = @(alpha, varargin) - Cz(alpha, varargin{:}).*cosa(alpha) ...
                                           + Cx(alpha, varargin{:}).*sina(alpha);

                % Aerodynamic drag coefficient, force negative air x-axis
                % coefficient is dimensionless by definition
                Cdrag = @(alpha, varargin) - Cz(alpha, varargin{:}).*sina(alpha) ...
                                           - Cx(alpha, varargin{:}).*cosa(alpha);
        end
                              
        % return Cdrag, Clift if two outputs requested
        varargout = {Cdrag, Clift};
    case 'xz'
        %% Coefficients body x-, z-axis
        % functions of alpha, eta, and optionally q 
        Clift = Cz_lift;
        Cdrag = Cx_drag;

        switch output
            case 'array'
                Cz = - Clift.*cosa(alphas) ...
                     - Cdrag.*sina(alphas);
                    
                Cx = + Clift.*sina(alphas) ...
                     - Cdrag.*cosa(alphas);
            
            case 'polynomial'
                Cz = - Clift*cosa(alpha) ...
                     - Cdrag*sina(alpha);
                    
                Cx = + Clift*sina(alpha) ...
                     - Cdrag*cosa(alpha);
            
            %case 'function'
            otherwise
                % aerodynamic coefficient force body z-axis
                % coefficient is dimensionless by definition
                Cz = @(alpha, varargin) - Clift(alpha, varargin{:}).*cosa(alpha) ...
                                        - Cdrag(alpha, varargin{:}).*sina(alpha);

                Cx = @(alpha, varargin) + Clift(alpha, varargin{:}).*sina(alpha) ...
                                        - Cdrag(alpha, varargin{:}).*cosa(alpha);
        end
        
        % return Cx, Cz if two outputs requested
        varargout = {Cx, Cz};
    otherwise
        error(['Unknown type ''%s''; ' ...
               'type needs to be either ''liftdrag'' or ''xz''.'], type);
end

%% Return
% return all four Cx, Cz, Cdrag, Clift
% if four outputs requested
if nargout > 2
    varargout = {Cx, Cz, Cdrag, Clift};
end

end