a :- initially.
next(1,a) :- initially.
next(2,b) :- initially.
c :- until(2,a,b).

#external initially.
#external until(2,a,b).

#show show(a).
#show show(b).
#show show(c).

%% clingo --output=reify examples/until-body.lp | clingo - meta.lp -c horizon=3 0

%% Solving...
%% Answer: 1
%% (a,0) (a,1) (b,2) (c,1) (c,2)
%% SATISFIABLE
