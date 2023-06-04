until(2,a,b) :- initially.
a :- initially.
next(1,b) :- initially.

#external initially.

#show show(a).
#show show(b).

%% clingo --output=reify examples/until-head2.lp | clingo - meta.lp -c horizon=3 0

%% Solving...
%% Answer: 1
%% (a,0) (b,1)
%% SATISFIABLE
