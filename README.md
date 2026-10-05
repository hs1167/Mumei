# Mumei / 無名

De Bruijn can essentially be viewed as quotienting away binder names through alpha-equivalence.

$$
t \sim_{\alpha} t'
$$

Conceptually,

$$
\mathcal{T}_{\mathrm{named}} / {\sim_{\alpha}}
\simeq
\mathcal{T}_{\mathrm{DeBruijn}}.
$$


This representation removes alpha-renaming from the operational surface of the language: binders become positions rather than names, and substitution reduces to local index arithmetic through shifting and cutoffs.

todo: use this tiny evaluator to explore how expressive pure LC already is, especially through Church-style encodings where data is represented by its eliminator / fold: naturals, booleans, lists, trees, and more generally many inductive data structures encoded using only abstraction and application.
Come back and read this when I'm at a better level : https://okmij.org/ftp/tagless-final/course/Boehm-Berarducci.html
