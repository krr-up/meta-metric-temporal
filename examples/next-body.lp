a :- finally.
b :- next(2,a).

#external finally.
#external next(2,a).

#show show(a).
#show show(b).

% clingo --output=reify examples/next-body.lp | clingo - meta.lp -c horizon=2 0
%
%% Solving...
%% Answer: 1
%% (a,2) (b,0)
%% SATISFIABLE
