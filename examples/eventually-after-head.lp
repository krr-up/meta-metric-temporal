eventually_after(3,b) :- initially.

#external initially.
#show show(b).

%% clingo --output=reify examples/eventually-after-head.lp | clingo - meta.lp -c horizon=4 0

%% Solving...
%% Answer: 1
%% (b,0)
%% Answer: 2
%% (b,1)
%% Answer: 3
%% (b,2)
%% SATISFIABLE
