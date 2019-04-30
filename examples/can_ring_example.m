// takes about 1min
SetDebugOnError(true);
load "config.m";

F := QuadraticField(13);
ZF<w> := Integers(F);
N := ideal<ZF | {1}>;
k := [2, 2];
K := Rationals();
prec := 30;
M := GradedRingOfHMFs(F, prec);

time g, r := ConstructGeneratorsAndRelations(M, N, 8);
time g1, r1 := Relations(g, r, 20);

X := MakeScheme(g1, r1);

print X;
