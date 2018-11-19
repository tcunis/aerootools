classdef BasicParameters < EOMvector
% Basic parameters for equations of motion.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-11-16
% * Changed:    2018-11-16
%
%%

properties (Access=protected)
end

methods
    function obj = BasicParameters(varargin)
        % Default parameters.
        obj@EOMvector([],varargin{:});
    end
end

methods (Access=protected, Static)
    function [tf,default] = check(obj, default, varargin)
        % Overriding EOMvector.check
        if length(varargin) == 1 && isa(varargin{1}, class(obj))
            tf = 1;
        else
            tf = 4;
        end
    end
end

end
        