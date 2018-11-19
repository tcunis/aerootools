classdef (Abstract) EOMvector
% Vector for the longitudinal equations of motion.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-10-08
% * Changed:    2018-10-08
%
%% See also
%
% See EOMLONG
%
%%

properties (SetAccess=protected)
    v;
end

methods (Access=protected, Static)
    function [tf, default] = check(obj, default, varargin)
    % Check input argument(s); 
    % returns
    %
    %      -1 -- invalid arguments
    %       0 -- no arguments
    %       1 -- argument of matching class
    %       2 -- single column vector of matching length
    %       3 -- single row vector of matching length
    %       4 -- arguments of matching number
        
        if isempty(varargin)
            tf = 0;
        elseif length(varargin) == 1 && isa(varargin{1}, class(obj))
            tf = 1;
        elseif length(varargin) == 1 && size(varargin{1},1) == length(default)
            tf = 2;
        elseif length(varargin) == 1 && size(varargin{1},2) == length(default)
            tf = 3;
        elseif length(varargin) == length(default)
            tf = 4;
        else
            tf = -1;
        end
    end
end

methods
    function obj = EOMvector(default, varargin)
        % Vector of given format.
        
        [tf,default] = obj.check(obj, default, varargin{:});
        
        switch tf
            case 0
                obj.v = default;
            case 1
                obj.v = varargin{1}.v;
            case 2
                obj.v = varargin{1};
            case 3
                obj.v = varargin{1}';
            case 4
                obj.v = vertcat(varargin{:});
            otherwise
                error('Unexpected number of variables (%g, expected %g).', ...
                                max(length(varargin),length(varargin{1})), ...
                                                          length(default)  ...
                );
        end
    end
    
    function V = double(obj)
        % See DOUBLE
        V = obj.v;
    end
    
    function l = length(obj)
        % See LENGTH
        l = length(obj.v);
    end
    
    function varargout = size(obj,varargin)
        % See SIZE
        varargout = cell(1,max(1,nargout));
        [varargout{:}] = size(obj.v,varargin{:});
    end
    
    function E = index(obj,i)
        % Index function, E = obj(i).
        E = obj.v(i,:);
    end
    
    function E = subsref(obj,s)
        % See SUBSREF
        
        if length(s) == 1 && strcmp(s.type,'()')
            E = builtin('subsref',obj.v,s);
        else
            E = builtin('subsref',obj,s);
        end
    end
end

end