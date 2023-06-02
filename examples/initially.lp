a.
b :- initially.

#show show(a).
#show show(b).

#external initially.

% clingo --output=reify examples/initially.lp | clingo - meta.lp -c horizon=3 0
%
%% Solving...
%% Answer: 1
%% (b,0) (a,0) (a,1) (a,2) (a,3)
%% SATISFIABLE
