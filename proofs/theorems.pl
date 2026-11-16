% Theorems, proved by exhaustion. Run: swipl -g main -t halt proofs/theorems.pl
:- module(theorems, [main/0]).
:- use_module(prove).
:- discontiguous theorem/1.
:- use_module(library(lists)).
:- use_module(library(apply)).
main :- prove_all(theorems).
:- use_module('../prolog/gesture2spec').

% Domain: every path of up to 4 strokes; every template with every single-stroke change.
stroke(S) :- member(S, [u, d, l, r]).
path(P) :- between(0, 4, N), length(P, N), maplist(stroke, P).
one_edit(T, E) :- ( append(A, [_|B], T), stroke(S), append(A, [S|B], E) ; append(A, [_|B], T), append(A, B, E) ; append(A, B, T), stroke(S), append(A, [S|B], E) ).

% 1. Edit distance is a metric: zero exactly on equal paths, symmetric, and obeys the triangle inequality.
theorem(distance_is_a_metric) :- forall(( path(A), length(A, LA), LA =< 3, path(B), length(B, LB), LB =< 3 ), ( distance(A, B, D1), distance(B, A, D2), D1 == D2, iff(D1 =:= 0, A == B) )),
    forall(( member(A, [[u], [u, d], [l, l, r]]), member(B, [[], [d], [u, d, d]]), member(C, [[r], [u, u], [l, r, l]]) ), ( distance(A, B, X), distance(B, C, Y), distance(A, C, Z), Z =< X + Y )).

% 2. Each template is read as its own command.
theorem(templates_recognised) :- forall(template(C, T), recognise(T, C)).

% 3. The templates are at least 3 apart, so any one-stroke slip is still read right.
theorem(one_slip_tolerated) :- separation(D), D >= 3, forall(( template(C, T), one_edit(T, E) ), recognise(E, C)).

% 4. Distance is at most the longer length (change every stroke) and at least the difference in lengths.
theorem(distance_bounds) :- forall(( path(A), path(B) ), ( distance(A, B, D), length(A, LA), length(B, LB), D =< max(LA, LB), D >= abs(LA - LB) )).
