b :- always_after(2,a).

a :- initially.
next(a) :- initially.
next(2,a) :- initially.

#external initially.
#external always_after(2,a).
#show show(a).
#show show(b).

%% clingo --output=reify examples/always-after-body.lp | clingo - meta.lp -c horizon=5 0

%% Solving...
%% Answer: 1
%% (a,0) (a,2) (a,1) (b,0) (b,1)
%% SATISFIABLE
