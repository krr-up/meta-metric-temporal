% Define one world for each time point.

conjunction(B,T) :- literal_tuple(B), time(T),
        hold(L,T) : literal_tuple(B, L), L > 0;
    not hold(L,T) : literal_tuple(B,-L), L > 0.

body(normal(B),T) :- rule(_,normal(B)), conjunction(B,T), time(T).
body(sum(B,G),T)  :- rule(_,sum(B,G)), time(T),
    #sum { W,L :     hold(L,T), weighted_literal_tuple(B, L,W), L > 0 ;
           W,L : not hold(L,T), weighted_literal_tuple(B,-L,W), L > 0 } >= G.

  hold(A,T) : atom_tuple(H,A)   :- rule(disjunction(H),B), body(B,T), time(T).
{ hold(A,T) : atom_tuple(H,A) } :- rule(     choice(H),B), body(B,T), time(T).

time(0..horizon).

% Only show formulas s for which we have a show statement #show show(s). in the input program

#show.
#show (S,T) : output(show(S),_), true(S,T).

%
% true(O,T) tells us that formula O holds at time point T.
%
% The implicit show statements (everything is shown unless #show. is
% in the program) give us one output(O,B) with literal tuple B
% containing 1 element L for each atom occurring in the input
% program. . Therefore, we can define the truth value of atom O at
% time point T as true(O,T) via hold(L,T). Note that O here is the
% symbolic representation of the atom, allowing us to also define the
% truth value of nested formulas.
% 

true(O,T) :- hold(L,T), output(O,B), literal_tuple(B,L).
hold(L,T) :- true(O,T), output(O,B), literal_tuple(B,L).

%
% The next rule is also needed to represent the facts O of the input
% logic program, for which clingo generates output(O,0) and no
% literal_tuple of the form literal_tuple(0,L)
%

true(O,T) :- time(T), output(O,B), not literal_tuple(B,_).


% top level formulas
formula(O) :- output(O,_).


% auxiliary formulas - true always holds, false never does.

true(true,T)  :- formula(true), time(T).

:- formula(false), time(T), true(false,T).


% define nullary initially
true(initially,0) :- formula(initially).

T=0 :- true(initially,T), formula(initially).


% define nullary finally.
true(finally,horizon) :- formula(finally).

T=horizon :- true(finally,T), formula(finally).


% define iterated abstract_next(N,F,D). It is a generalization of the previous and next operators.
% N gives the number of times we apply the operator, F the inner formula.
% D denotes the direction we're looking:
% D=1 means we're looking towards the future, and gives us the next operator.
% D=-1 means we're looking towards the past, and gives us the previous operator.

formula(F) :- formula(abstract_next(N,F,D)).

true(F,T+D*N) : time(T+D*N) :- formula(abstract_next(N,F,D)), true(abstract_next(N,F,D),T), time(T).

true(abstract_next(N,F,D),T) :- true(F,T+D*N), formula(abstract_next(N,F,D)), time(T), time(T+D*N).

% define iterated prev. prev(N,F) is equivalent to abstract_next(N,F,-1).
formula(abstract_next(N,F,-1)) :- formula(prev(N,F)).
true(abstract_next(N,F,-1),T) :- formula(prev(N,F)), time(T), true(prev(N,F),T).
true(prev(N,F),T) :- formula(prev(N,F)), time(T), true(abstract_next(N,F,-1),T).

% define non-iterated prev - special case of iterated prev.
formula(prev(1,F)) :- formula(prev(F)).
true(prev(1,F),T) :- formula(prev(F)), true(prev(F),T), time(T).
true(prev(F),T) :- formula(prev(F)), true(prev(1,F),T), time(T).

% define iterated next. next(N,F) is equivalent to abstract_next(N,F,1).
formula(abstract_next(N,F,1)) :- formula(next(N,F)).
true(abstract_next(N,F,1),T) :- formula(next(N,F)), time(T), true(next(N,F),T).
true(next(N,F),T) :- formula(next(N,F)), time(T), true(abstract_next(N,F,1),T).


% define non-iterated next - special case of iterated next
formula(next(1,F)) :- formula(next(F)).
true(next(1,F),T) :- formula(next(F)), true(next(F),T), time(T).
true(next(F),T) :- formula(next(F)), true(next(1,F),T), time(T).


% define abstract_until(N,L,R,D). It is a generalization of the until and since operators
% D denotes the direction we're looking:
% D=1 means we're looking towards the future, and gives us until.
% D=-1 means we're looking towards the past, and gives us since.

formula(L) :- formula(abstract_until(_,L,_,_)).
formula(R) :- formula(abstract_until(_,_,R,_)).

aux_true(abstract_until(N,L,R,D),T,J) : J=0..N-1, time(J) :-
		formula(abstract_until(N,L,R,D)), true(abstract_until(N,L,R,D),T), time(T).
true(L,K) :- aux_true(abstract_until(N,L,R,D),T,J), I=0..J-1, K=T+D*I, time(K).
true(R,T+D*J) :- aux_true(abstract_until(N,L,R,D),T,J).

true(abstract_until(N,L,R,D),T) :- formula(abstract_until(N,L,R,D)), aux_true(abstract_until(N,L,R,D),T,_).
aux_true(abstract_until(N,L,R,D),T,J) :- formula(abstract_until(N,L,R,D)), time(T),
																				  J=0..N-1, true(R,T+D*J), true(L,K) : I=0..J-1, K=T+D*I, time(K).

% define until. until(N,L,R) is equivalent to abstract_until(N,L,R,1).
formula(abstract_until(N,L,R,1)) :- formula(until(N,L,R)).
true(abstract_until(N,L,R,1),T) :- formula(until(N,L,R)), true(until(N,L,R),T), time(T).
true(until(N,L,R),T) :- formula(until(N,L,R)), true(abstract_until(N,L,R,1),T), time(T).

% define eventually_after. eventually_after(N,F) is equivalent to until(N,true,F).
formula(until(N,true,F))  :- formula(eventually_after(N,F)).
true(until(N,true,F),T) :- formula(eventually_after(N,F)),
												 true(eventually_after(N,F),T), time(T).
true(eventually_after(N,F),T) :- formula(eventually_after(N,F)),
																 true(until(N,true,F),T), time(T).

% define since. since(N,L,R) is equivalent to abstract_until(N,L,R,-1).
formula(abstract_until(N,L,R,-1)) :- formula(since(N,L,R)).
true(abstract_until(N,L,R,-1),T) :- formula(since(N,L,R)), true(since(N,L,R),T), time(T).
true(since(N,L,R),T) :- formula(since(N,L,R)), true(abstract_until(N,L,R,-1),T), time(T).

% define eventually_before. eventually_before is equivalent to since(N,true,F).
formula(since(N,true,F))  :- formula(eventually_before(N,F)).
true(since(N,true,F),T) :- formula(eventually_before(N,F)),
												 true(eventually_before(N,F),T), time(T).
true(eventually_before(N,F),T) :- formula(eventually_before(N,F)),
																	true(since(N,true,F),T), time(T).


% define abstract_release(N,L,R,D). It is a generalization of release and trigger.
% D denotes the direction we're looking:
% D=1 means we're looking towards the future, and gives us release.
% D=-1 means we're looking towards the past, and gives us trigger.

formula(L) :- formula(abstract_release(_,L,_,_)).
formula(R) :- formula(abstract_release(_,_,R,_)).

% if J<N=1, aux_true(abstract_release(N,L,R,D),T,J) indicates that L releases R at time step T+D*(J+1)
% if J=N=1, aux_true(abstract_release(N,L,R,D),T,J) indicates that L doesn't release R, and thus R holds in the for all
% time points T..T+D*J
aux_true(abstract_release(N,L,R,D),T,J) : J=0..N-1, time(J) :-
		formula(abstract_release(N,L,R,D)), true(abstract_release(N,L,R,D),T), time(T).
true(R,K) :- formula(abstract_release(N,L,R,D)), aux_true(abstract_release(N,L,R,D),T,J),
						 I=0..J, K=T+D*I, time(K).
true(L,T+D*J) :- formula(abstract_release(N,L,R,D)), aux_true(abstract_release(N,L,R,D),T,J), J<N-1.

true(abstract_release(N,L,R,D),T) :- formula(abstract_release(N,L,R,D)), aux_true(abstract_release(N,L,R,D),T,_).
aux_true(abstract_release(N,L,R,D),T,J) :- formula(abstract_release(N,L,R,D)),
																					 time(T), J=0..N-2, true(L,T+D*J),
																					 true(R,K) : I=0..J, K=T+D*I, time(K).
aux_true(abstract_release(N,L,R,D),T,N-1) :- formula(abstract_release(N,L,R,D)),
																						 time(T), time(T+D*(N-1)), true(R,K) : J=0..N-1, K=T+D*J, time(K).

% define release. release(N,L,R) is equivalent to abstract_release(N,L,R,1).
formula(abstract_release(N,L,R,1)) :- formula(release(N,L,R)).
true(abstract_release(N,L,R,1),T) :- formula(release(N,L,R)), true(release(N,L,R),T), time(T).
true(release(N,L,R),T) :- formula(release(N,L,R)), true(abstract_release(N,L,R,1),T), time(T).

% define always_after. always_after(N,F) is equivalent to release(N,false,F).
formula(release(N,false,F))  :- formula(always_after(N,F)).
true(release(N,false,F),T) :- formula(always_after(N,F)),
															true(always_after(N,F),T), time(T).
true(always_after(N,F),T) :- formula(always_after(N,F)),
														 true(release(N,false,F),T), time(T).

% define trigger. trigger(N,L,R) is equivalent to abstract_release(N,L,R,-1).
formula(abstract_release(N,L,R,-1)) :- formula(trigger(N,L,R)).
true(abstract_release(N,L,R,-1),T) :- formula(trigger(N,L,R)), true(trigger(N,L,R),T), time(T).
true(trigger(N,L,R),T) :- formula(trigger(N,L,R)), true(abstract_release(N,L,R,-1),T), time(T).

% define always_before. always_before(N,F) is equivalent to trigger(N,false,F).
formula(trigger(N,false,F))  :- formula(always_before(N,F)).
true(trigger(N,false,F),T) :- formula(always_before(N,F)),
															true(always_before(N,F),T), time(T).
true(always_before(N,F),T) :- formula(always_before(N,F)),
														 true(trigger(N,false,F),T), time(T).

% suppress warning messages for missing reified output atoms

#defined literal_tuple/1.
#defined literal_tuple/2.
#defined rule/2.
#defined atom_tuple/2.
#defined weighted_literal_tuple/3.
