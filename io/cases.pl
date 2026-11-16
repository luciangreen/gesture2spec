:- module(cases, [title/1, case/3]).
:- use_module('../prolog/gesture2spec').
:- use_module(engine).
title('gesture2spec').
path_g(P) :- rnd_int(0, 6, N), length(P, N), maplist([S]>>rnd_pick([u, d, l, r], S), P).
noisy_g(P) :- findall(T, template(_, T), Ts), rnd_pick(Ts, T), ( rnd_chance(50) -> P = T ; maplist([S, S2]>>( rnd_chance(20) -> rnd_pick([u, d, l, r], S2) ; S2 = S ), T, P) ).
case(recognise, [P], recognise) :- noisy_g(P).
case(distance, [A, B], distance) :- path_g(A), path_g(B).
case(spec, [Gs], spec) :- rnd_int(1, 4, N), length(Gs, N), maplist(noisy_g, Gs).
case(recognise_any, [P], recognise) :- path_g(P).
