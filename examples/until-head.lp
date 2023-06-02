until(3,a,b) :- initially.

#external initially.

#show show(a).
#show show(b).

%% clingo --output=reify examples/until-head.lp | clingo - meta.lp -c horizon=3 0

%% Solving...
%% Answer: 1
%% (b,0)
%% Answer: 2
%% (b,1) (a,0)
%% Answer: 3
%% (b,2) (a,0) (a,1)
%% SATISFIABLE
