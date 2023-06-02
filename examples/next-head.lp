next(3,a) :- initially.
next(1,b) :- a.

#external initially.
#external a.

#show show(a).
#show show(b).

% clingo --output=reify examples/next-head.lp | clingo - meta.lp -c horizon=5 0
%
%% Solving...
%% Answer: 1
%% (a,3) (b,4)
%% SATISFIABLE
