release(3,a,b) :- initially.

#external initially.

#show show(a).
#show show(b).

%% clingo --output=reify examples/release-head.lp | clingo - meta.lp -c horizon=3 0

%% Solving...
%% Answer: 1
%% (a,0) (b,0)
%% Answer: 2
%% (b,0) (b,1) (b,2)
%% Answer: 3
%% (a,1) (b,0) (b,1)
%% SATISFIABLE
