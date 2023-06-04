always_after(3,a) :- initially.

#external initially.
#show show(a).

%% clingo --output=reify examples/always-after-head.lp | clingo - meta.lp -c horizon=3 0

%% Reading from - ...
%% Solving...
%% Answer: 1
%% (a,0) (a,1) (a,2)
%% SATISFIABLE
