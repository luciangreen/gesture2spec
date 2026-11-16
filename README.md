# gesture2spec

build specs from DanceStudio gestures. A gesture is a path of strokes (u, d, l, r); each command has a template path; a drawn gesture is read as the command whose template is nearest by edit distance (the first on ties), so a slightly wobbly gesture still works. A sequence of gestures becomes a sequence of spec steps.

## Use

```prolog
?- use_module(prolog/gesture2spec).
?- recognise([r, r, d], C).                 % C = sort
?- recognise([r, d], C).                    % one stroke missing: still sort
?- spec([[r, r, d], [l, l, u, u], [u, u, u]], S).  % S = [sort, reverse, run]
?- distance([r, r, d], [r, d], D).          % D = 1
```

## Proofs

`proofs/theorems.pl` proves 4 theorems by exhaustion: each one is checked for every case in a finite domain that covers every branch of the definitions. every path of up to 4 strokes; every template with every single-stroke change.

1. Edit distance is a metric: zero exactly on equal paths, symmetric, and obeys the triangle inequality.
2. Each template is read as its own command.
3. The templates are at least 3 apart, so any one-stroke slip is still read right.
4. Distance is at most the longer length (change every stroke) and at least the difference in lengths.

```sh
swipl -g main -t halt proofs/theorems.pl
```

## 200 inputs and outputs

`io/ios.txt` lists 200 inputs and outputs from real runs, and `io/ios.pl` has the same as Prolog facts. The inputs come from a fixed seed (`io/cases.pl`). `swipl -g check -t halt io/run.pl` runs them again. It fails if any output changes, or if a predicate doesn't confirm its own recorded output, which checks steadfastness. GitHub Actions runs the proofs and the examples on every push, and records the examples on the first push.

Licence: BSD-3-Clause.
