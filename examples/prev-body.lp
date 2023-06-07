a :- initially.
b :- prev(2,a).

#external initially.
#external prev(2,a).

#show show(a).
#show show(b).

% clingo --output=reify examples/prev-body.lp | clingo - meta.lp -c horizon=2 0
%
%% Solving...
%% Answer: 1
%% (a,0) (b,2)
%% SATISFIABLE
