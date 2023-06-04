b :- eventually_after(2,a).
a :- initially.
next(a) :- initially.

#external initially.
#external eventually_after(2,a).
#show show(a).
#show show(b).

%% clingo --output=reify examples/eventually-after-body.lp | clingo - meta.lp -c horizon=3 0

%% Solving...
%% Answer: 1
%% (a,0) (a,1) (b,0) (b,1)
%% SATISFIABLE
