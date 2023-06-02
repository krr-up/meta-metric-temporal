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


% define nullary initially
true(initially,0) :- formula(initially).
T=0 :- true(initially,T), formula(initially).


% define nullary finally.
true(finally,horizon) :- formula(finally).
T=horizon :- true(finally,T), formula(finally).


% define iterated prev.
formula(F) :- formula(prev(I,F)).

true(F,T-N) : time(T-N) :- formula(prev(N,F)), true(prev(N,F),T), time(T), time(T-N).
% T-N>=0 :- formula(prev(N,F)), true(prev(N,F),T), time(T).

true(prev(N,F),T) :- true(F,T), formula(prev(N,F)), time(T), time(T-N).


% define iterated next
formula(F) :- formula(next(I,F)).

true(F,T+N) : time(T+N) :- formula(next(N,F)), true(next(N,F),T), time(T).
% T+N<=horizon :- formula(next(N,F)), true(next(N,F),T), time(T).

true(next(N,F),T) :- formula(next(N,F)), true(F,T+N), time(T), time(T+N).


% define until
formula(L) :- formula(until(_,L,_)).
formula(R) :- formula(until(_,_,R)).

aux_true(until(N,L,R),T,T') : time(T'), T<=T', T'<T+N :-
		     formula(until(N,L,R)), true(until(N,L,R),T), time(T).
true(L,K) :- aux_true(until(N,L,R),T,T'), T<=K, K<T', time(K).
true(R,T') :- aux_true(until(N,L,R),_,T').

true(until(N,L,R),T) :- formula(until(N,L,R)), aux_true(until(N,L,R),T,_).
aux_true(until(N,L,R),T,T') :- formula(until(N,L,R)), time(T'), true(R,T'),
															 time(T), T<=T', T'<T+N, true(L,K) : T<=K, K<T', time(K). 


% define release
formula(L) :- formula(release(_,L,_)).
formula(R) :- formula(release(_,_,R)).

% T' is the timepoint within [T,T+N-1] before R is released by L, or T'=T+N-1
% and L does not release R.
aux_true(release(N,L,R),T,T') : time(T'), T<=T', T'<T+N :-
		formula(release(N,L,R)), true(release(N,L,R),T), time(T).
true(R,K) :- formula(release(N,L,R)), aux_true(release(N,L,R),T,T'), time(K), T<=K, K<=T'.
true(L,T') :- formula(release(N,L,R)), aux_true(release(N,L,R),T,T'), T'<T+N-1.

true(release(N,L,R),T) :- formula(release(N,L,R)), aux_true(release(N,L,R),T,_).
aux_true(release(N,L,R),T,T') :- formula(release(N,L,R)),
																 time(T), time(T'), T<=T', T'<T+N-1, true(L,T'),
																 true(R,K) : time(K), T<=K, K<=T'.
aux_true(release(N,L,R),T,T') :- formula(release(N,L,R)),
																 time(T), time(T'), T<=T', T'=T+N-1,
																 true(R,K) : time(K), T<=K, K<=T'.


% define eventually_after


% suppress warning messages for missing reified output atoms

#defined literal_tuple/1.
#defined literal_tuple/2.
#defined rule/2.
#defined atom_tuple/2.
#defined weighted_literal_tuple/3.
