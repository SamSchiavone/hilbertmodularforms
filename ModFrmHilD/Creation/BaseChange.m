intrinsic BaseChange(M::ModFrmHilDGRng, f::ModFrmElt : psi:=false, N_force:=false) -> ModFrmHilDElt
  {
    inputs:
      M: Graded ring of HMFs into which to create the base change
      f: Modular form to base change, of level N and weight k
      psi: Nebentypus character of f. We need to specify this sometimes because
        Magma is dumb with DirichletCharacter of weight one forms.
        // TODO abhijitm should probably do error-handling here better
    returns:
      The base change of f into the space of HMFs of level N * Integers(F),
      weight (k, ..., k), and character given by precomposing psi with
      the norm of F/Q.
  }
  F := BaseField(M);
  ZF := Integers(F);
  prec := Precision(M);
  k := Weight(f);
  N := Level(f);

  if k eq 1 then
    require psi cmpne false : "Magma does not handle nebentypi of weight 1 modular forms properly, please include psi in the call to BaseChange";
  else
    psi := DirichletCharacter(f);
  end if;

  a_pps := AssociativeArray();
  for pp in PrimeIdeals(M) do
    d := InertiaDegree(pp);
    p := Integers()!Root(Norm(pp), d);
    a_p := Coefficient(f, p);
    a_pps[pp] := (d eq 1) select a_p else a_p^d - d * a_p^(d-2) * psi(p) * p^(k-1);
  end for;

  // TODO abhijitm - this is actually not optimal. It is possible for the ramification
  // in the modular form to disappear in the base change if it factors through a finite
  // quotient. The base change form does occur in the level (N) but it won't generally
  // be new at this level. I will fix it someday. 
  if N_force cmpeq false then
    N := Level(f) * Integers(F);
  else
    N := N_force;
  end if;

  H := HeckeCharacterGroup(N, [1 .. Degree(F)]);
  chi := Extend(NormInduction(F, psi), H);
  k_par := [k : _ in [1 .. Degree(F)]];
  Mk := HMFSpace(M, N, k_par, chi);

  return CuspFormFromEigenvalues(Mk, a_pps);
end intrinsic;
