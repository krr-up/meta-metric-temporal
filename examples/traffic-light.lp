:- red, green.
red :- not green.
eventually_after(3,always_after(4,green)) :- push.
next(1,push) :- initially.

#external initially.
#external push.
#external green.
#show show(X) : X=(green;red;push).

%% clingo --output=reify examples/traffic-light.lp | clingo - meta.lp -c horizon=7 0

%% Solving...
%% Answer: 1
%% (push,1) (red,0) (red,5) (red,6) (red,7) (green,3) (green,4) (green,2) (green,1)
%% Answer: 2
%% (push,1) (red,0) (red,1) (red,6) (red,7) (green,3) (green,4) (green,5) (green,2)
%% Answer: 3
%% (push,1) (red,0) (red,1) (red,2) (red,7) (green,3) (green,4) (green,5) (green,6)
%% SATISFIABLE
