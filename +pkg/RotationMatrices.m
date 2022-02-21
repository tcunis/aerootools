classdef (Abstract) RotationMatrices < aerootools.pkg.RealFunctions
% Rotation matrices.

methods (Access=protected)
    function M = rot(obj,a,k)
        % Creates rotation matrix for a around axis k.
        M = diag([1 obj.cos(a) 1 obj.cos(a) 1]);
        M(2,4) =  obj.sin(a);
        M(4,2) = -obj.sin(a);

        I = [k==1 true k==2 true k==3];
        
        % multipoly does not support logical indexing...
        idx = 1:length(M);
        idx = idx(I);
        
        M = M(idx,idx);
    end
end

end
