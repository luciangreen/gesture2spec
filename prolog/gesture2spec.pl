% gesture2spec: build specs from DanceStudio gestures. A gesture is a path of strokes (u, d, l,
% r); each command has a template path; a drawn gesture is read as the command whose template
% is nearest by edit distance (the first on ties), so a slightly wobbly gesture still works. A
% sequence of gestures becomes a sequence of spec steps.
%?- recognise([r, r, d], C).                 % C = sort
%?- recognise([r, d], C).                    % one stroke missing: still sort
%?- spec([[r, r, d], [l, l, r], [u, u, u]], S).     % S = [sort, reverse, run]
%?- distance([r, r, d], [r, d], D).          % D = 1
:- module(gesture2spec, [template/2, distance/3, recognise/2, spec/2, separation/1]).
:- use_module(library(lists)).
:- use_module(library(apply)).

template(sort, [r, r, d]).
template(run, [u, u, u]).
template(filter, [d, d, l]).
template(reverse, [l, l, r]).
template(map, [u, d, r, r]).
template(undo, [u, l, d, d]).
% (chosen so every two templates are at least 3 edits apart)

% distance(+A, +B, -D): Levenshtein edit distance (insert, delete or change one stroke), row by row.
distance(A, B, D) :- length(B, N), numlist(0, N, R0), rows(A, B, 1, R0, R), last(R, D).
rows([], _, _, R, R).
rows([X|Xs], B, I, Prev, R) :- Prev = [P0|Ps], cells(B, X, P0, Ps, I, Rest), I1 is I + 1, rows(Xs, B, I1, [I|Rest], R).
cells([], _, _, [], _, []).
cells([Y|Ys], X, Diag, [Up|Ups], Left, [V|Vs]) :- ( X == Y -> C = 0 ; C = 1 ), V is min(min(Up + 1, Left + 1), Diag + C), cells(Ys, X, Up, Ups, V, Vs).

recognise(G, C) :- findall(D-Cmd, ( template(Cmd, T), distance(G, T, D) ), Ds), keysort(Ds, [_-C|_]).
spec(Gs, S) :- maplist(recognise, Gs, S).

% separation(-D): the smallest distance between two templates (gestures within (D-1)/2 strokes of a template are read right).
separation(D) :- aggregate_all(min(X), ( template(A, Ta), template(B, Tb), A @< B, distance(Ta, Tb, X) ), D).
