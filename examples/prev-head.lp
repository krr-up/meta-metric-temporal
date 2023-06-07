prev(3,a) :- finally.
prev(1,b) :- a.

#external finally.
#external a.

#show show(a).
#show show(b).

% clingo --output=reify examples/prev-head.lp | clingo - meta.lp -c horizon=4 0
%% Solving...
%% Answer: 1
%% (a,1) (b,0)
%% SATISFIABLE
