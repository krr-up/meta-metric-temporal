b :- initially.
next(1,b) :- initially.
next(2,b) :- initially.
c :- release(2,a,b).

#external initially.
#external release(2,a,b).

#show show(a).
#show show(b).
#show show(c).

%% clingo --output=reify examples/release-body1.lp | clingo - meta.lp -c horizon=3 0

%% Solving...
%% Answer: 1
%% (b,0) (b,1) (b,2) (c,1) (c,0)
%% SATISFIABLE
