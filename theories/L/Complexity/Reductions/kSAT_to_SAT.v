From Undecidability.L.Complexity Require Import NP Synthetic Problems.SAT Problems.Clique. 
From Undecidability.L Require Import Tactics.LTactics.
From Undecidability.L.Complexity Require Import Problems.kSAT PolyBounds Tactics NP. 
From Undecidability.L.Datatypes Require Import LBool LNat Lists LProd. 

Lemma evalCnf_inv_true (c : cnf) (cl :clause) (a : assgn) : (evalCnf a (cl::c) = Some true) -> (evalCnf a c = Some true). 
Admitted. 

Lemma ksat_to_sat (k : nat): reducesPolyMO (kSAT k) SAT. 
Proof. 
  (*check if it is a kCNF. if so, the reduction the SAT instance is the identity. otherwise, return a negative SAT instance*)
  exists (fun x => if kCNF_decb k x then x else [[(true, 0)]; [(false, 0)]] ). 
  split.
  - pose (predT := (fun (cl : list (bool * nat)) (_ : unit) => (11 * (| cl |) + 17 * Init.Nat.min k (| cl |) + 23, tt))). 
    assert (exists (fPred : nat -> nat), (forall (a : list (bool * nat)), fst(predT a tt) <= fPred (size(enc a))) /\ inOPoly fPred /\ monotonic fPred). 
    * evar (fPred : nat -> nat). exists fPred. split; try split. 
        1: {
          intros a. unfold predT. cbn [fst]. instantiate (fPred := fun n => 28 * n + 23). subst fPred. 
          induction a. 
          + cbn; lia. 
          + cbn -[Nat.mul]. solverec. rewrite Nat.le_min_r. solverec. rewrite list_size_cons. rewrite list_size_length. 
            solverec. 
        }
      all: subst fPred; smpl_inO.
    * specialize (forallb_time_bound H) as (f' & H1 & H2 & H3).
      evar (f : nat -> nat). exists f.
      + constructor.  extract. solverec.
        2: { fold predT. rewrite H1. instantiate (f := fun n => f' n + 53). subst f. lia. }
        fold predT. rewrite H1. subst f; lia.
      + subst f; smpl_inO. 
      + subst f; smpl_inO. 
      + (* now we need to prove that the output of the reduction is polynomial *)
        evar (tf : nat -> nat). exists tf. split. 
        1 : {
          intros x. destruct (kCNF_decb k x).
          Compute (size(enc [[(true, 0)]; [(false, 0)]])).
          instantiate (tf := fun n => n + 55).
          all: subst tf. 2 : replace (size(enc [[(true, 0)]; [(false, 0)]])) with 55. 1-2: lia. 
          now cbv. 
        }
        split; subst tf; smpl_inO. 
  - intros x. split.
    + intros ( H1 & a & H2). destruct (kCNF_decb k x) eqn:H3. now exists a. clear H2. 
      induction H1. 
      * unfold kCNF_decb in H3; simp_bool. rewrite Nat.leb_nle in H3. lia. cbn in H3; congruence.
      * specialize (kCNF_decb_correct k c) as H4.
        cbn in H3. simp_bool.
        -- unfold kCNF_decb_pred in H3. unfold kCNF_decb in H3. simp_bool. rewrite Nat.leb_nle in H3.
           apply kCNF_kge in H1; lia. cbn in H3; simp_bool. unfold kCNF_decb_pred in H3. 
           now apply beq_nat_false in H3. apply IHkCNF. unfold kCNF_decb. simp_bool; right; apply H3. 
    + intros (a & H). destruct (kCNF_decb k x) eqn:H1. split. rewrite kCNF_decb_correct in H1. 
      induction x; constructor.
      * tauto. 
      * symmetry. apply H1. now left. 
      * apply IHx. split; try tauto. intros cl H2. apply H1. now right. now apply evalCnf_inv_true with (cl:= a0). 
      * now exists a. 
      * destruct a. now cbn in H. destruct b; cbn in H; congruence.
Qed. 

Lemma inNP_kSAT (k : nat) : inNP (kSAT k). 
Proof.
  apply red_inNP with (regY := @registered_list_enc (list (bool * nat)) (@registered_list_enc (bool * nat)(@registered_prod_enc bool nat  registered_bool_enc registered_nat_enc) ))(Q := SAT). 
  apply ksat_to_sat. apply sat_NP. 
Qed. 
