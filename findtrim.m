function [x, p] = findtrim(f, X0, P0, cond)
% Finds trim condition under constraints.
%
%% Usage and description
%
%   [x*, p*] = findtrim(f, x0, p0, cond)
%
% Finds trim condition (x*,p*) of the non-linear function |f(x,p)| under
% the constraint |cond(x,p) == 0| starting at the initial guess (x0,p0).
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2018-05-17
% * Changed:    2018-05-17
%
%%

if ~exist('cond', 'var')
    cond = @(X,P) P - P0;
end

% number of states
n = length(X0);
% number of parameters
m = length(P0);

% states
X = @(xp) xp(1:n);
% parameters
P = @(xp) xp(n+(1:m));

% problem structure
problem.objective = @(xp) [cond(X(xp), P(xp)); f(X(xp), P(xp))];
problem.x0 = [X0; P0];
problem.solver  = 'fsolve';
problem.options = optimoptions('fsolve', 'Algorithm', 'Levenberg-marquardt');

% find initial trim condition for f(x,p) == 0 & g(x,p) == 0
xp0 = fsolve(problem);

x = X(xp0);
p = P(xp0);