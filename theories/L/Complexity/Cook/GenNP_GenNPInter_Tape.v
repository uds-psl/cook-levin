(* -*- company-coq-local-symbols: (("|_|" .?␣)); -*- *)
From PslBase Require Import FiniteTypes. 
From Undecidability.TM Require Import TM.
Require Import Lia. 
From Undecidability.L.Complexity.Cook Require Import GenNP TCSR Prelim GenNP_GenNPInter_Basics.

Module tape (sig : TMSig).
  Module basics' := basics sig.
  Export basics'.

(* Section tape.  *)
(*   Context {inst : GenNPInstance}.  *)

(*   Definition inst' := Build_GenNPInstance (@trans inst) (@halt inst) (@start inst) (@t inst) (@k inst). *)

(*   Canonical Structure inst'. *)

(*   (* Notation states := (states inst).  *) *)
(*   (* Notation Sigma := (Sigma inst).  *) *)
(*   (* Notation trans := (@trans inst). *) *)

(*   (* Notation t := (t inst). *) *)
(*   (* Notation k := (k inst).  *) *)

(*   Notation sconfig := (sconfig states Sigma).  *)
(*   Notation sstep := (sstep trans). *)

(*   Notation polarity := move.  *)
(*   Notation positive := R.  *)
(*   Notation negative := L.  *)
(*   Notation neutral := N.  *)

(*   Notation "'↓' σ" := ((negative, σ)) (at level 30).  *)
(*   Notation "'↑' σ" := ((positive, σ)) (at level 30). *)
(*   Notation "'∘' σ" := ((neutral, σ)) (at level 30).  *)

(*   Notation "$" := (inl delimC).  *)
(*   Notation "'|_|'" := (None).  *)


(*   Notation "p ! a" := (withPolarity p a) (at level 5).  *)
(*   Notation "p !! a" := (withPolaritySigma p a) (at level 5).  *)


  (** *inductive rewriteHead predicates *)
Inductive shiftRightWindow : Gamma -> Gamma -> Gamma -> Gamma -> Gamma -> Gamma -> Prop :=
  | shiftRightSSSS σ1 σ2 σ3 σ4 p : shiftRightWindow (inr (inr (p, Some σ1))) (inr (inr (p, Some σ2))) (inr (inr (p, Some σ3))) (inr (inr (positive, Some σ4))) (inr (inr (positive, Some σ1))) (inr (inr (positive, Some σ2))) 
  | shiftRightBBBS p σ1 : shiftRightWindow (inr (inr (p, |_|))) (inr (inr (p, |_|))) (inr (inr (p, |_|))) (inr (inr (positive, Some σ1))) (inr (inr (positive, |_|))) (inr (inr (positive, |_|)))
  | shiftRightBBBB p : shiftRightWindow (inr (inr (p, |_|))) (inr (inr (p, |_|))) (inr (inr (p, |_|))) (inr (inr (positive, |_|))) (inr (inr (positive, |_|))) (inr (inr (positive, |_|)))
  | shiftRightSBB σ1 σ2 p : shiftRightWindow (inr (inr (p, Some σ1))) (inr (inr (p, |_|))) (inr (inr (p, |_|))) (inr (inr (positive, Some σ2))) (inr (inr (positive, Some σ1))) (inr (inr (positive, |_|)))
  | shiftRightSSB σ1 σ2 σ3 p : shiftRightWindow (inr (inr (p, Some σ1))) (inr (inr (p, Some σ2))) (inr (inr (p, |_|))) (inr (inr (positive, Some σ3))) (inr (inr (positive, Some σ1))) (inr (inr (positive, Some σ2))) 
  | shiftRightBBS σ1 p : shiftRightWindow (inr (inr (p, |_|))) (inr (inr (p, |_|))) (inr (inr (p, Some σ1))) (inr (inr (positive, |_|))) (inr (inr (positive, |_|))) (inr (inr (positive, |_|)))
  | shiftRightBSS σ1 σ2 p : shiftRightWindow (inr (inr (p, |_|))) (inr (inr (p, Some σ1))) (inr (inr (p, Some σ2))) (inr (inr (positive, |_|))) (inr (inr (positive, |_|))) (inr (inr (positive, Some σ1)))
  | shiftRightSSSB σ1 σ2 σ3 p : shiftRightWindow (inr (inr (p, Some σ1))) (inr (inr (p, Some σ2))) (inr (inr (p, Some σ3))) (inr (inr (positive, |_|))) (inr (inr (positive, Some σ1))) (inr (inr (positive, Some σ2))).

  Hint Constructors shiftRightWindow. 

  Inductive identityWindow : Gamma -> Gamma -> Gamma -> Gamma -> Gamma -> Gamma -> Prop :=
    | identityC (m1 m2 m3 : stateSigma) p : identityWindow (inr (inr (p, m1))) (inr (inr (p, m2))) (inr (inr (p, m3))) (inr (inr (neutral, m1))) (inr (inr (neutral, m2))) (inr (inr (neutral, m3)))
  | identityDBB p p' : identityWindow (inr #) (inr (inr (p, |_|))) (inr (inr (p, |_|))) (inr #) (inr (inr (p', |_|))) (inr (inr (p', |_|)))
  | identityBBD p p' : identityWindow (inr (inr (p, |_|))) (inr (inr (p, |_|))) (inr #) (inr (inr (p', |_|))) (inr (inr (p', |_|))) (inr #). 

  Hint Constructors identityWindow.

  Inductive rewHeadTape : list Gamma -> list Gamma -> Prop :=
  | rewShiftLeftTapeC (σ1 σ2 σ3 σ4 σ5 σ6 : Gamma) h1 h2: shiftRightWindow (~σ3) (~σ2) (~σ1) (~σ6) (~σ5) (~σ4) -> rewHeadTape (σ1 :: σ2 :: σ3 :: h1) (σ4 :: σ5 :: σ6 :: h2)
  | rewShiftRightTapeC  (σ1 σ2 σ3 σ4 σ5 σ6 : Gamma) h1 h2 : shiftRightWindow σ1 σ2 σ3 σ4 σ5 σ6 -> rewHeadTape (σ1 :: σ2 :: σ3 :: h1) (σ4 :: σ5 :: σ6 :: h2)
  | rewIdentityTapeC (σ1 σ2 σ3 σ4 σ5 σ6 : Gamma) h1 h2: identityWindow σ1 σ2 σ3 σ4 σ5 σ6 -> rewHeadTape (σ1 :: σ2 :: σ3 :: h1) (σ4 :: σ5 :: σ6 :: h2).

  Hint Constructors rewHeadTape. 


  Lemma rewHeadTape_tail_invariant γ1 γ2 γ3 γ4 γ5 γ6 h1 h2 h1' h2' :
    rewHeadTape (γ1 :: γ2 :: γ3 :: h1) (γ4 :: γ5 :: γ6 :: h2) <-> rewHeadTape (γ1 :: γ2 :: γ3 :: h1') (γ4 :: γ5 :: γ6 :: h2').
  Proof. split; intros; inv H; eauto. Qed. 

  Corollary rewHeadTape_rem_tail γ1 γ2 γ3 γ4 γ5 γ6 h1 h2 :
    rewHeadTape [γ1; γ2; γ3] [γ4; γ5; γ6] <-> rewHeadTape (γ1 :: γ2 :: γ3 :: h1) (γ4 :: γ5 :: γ6 :: h2).
  Proof. now apply rewHeadTape_tail_invariant. Qed. 

  Lemma rewHeadTape_append_invariant γ1 γ2 γ3 γ4 γ5 γ6 h1 h2 h1' h2' :
    rewHeadTape (γ1 :: γ2 :: γ3 :: h1) (γ4 :: γ5 :: γ6 :: h2) <-> rewHeadTape (γ1 :: γ2 :: γ3 :: h1 ++ h1') (γ4 :: γ5 :: γ6 :: h2 ++ h2').
  Proof. now apply rewHeadTape_tail_invariant. Qed. 

  Lemma identityWindow_revp (γ1 γ2 γ3 γ4 γ5 γ6 : Gamma) : identityWindow γ1 γ2 γ3 γ4 γ5 γ6 <-> identityWindow (~γ3) (~γ2) (~γ1) (~γ6) (~γ5) (~γ4).
  Proof.
    split; intros; inv H; cbn.
    all: repeat match goal with
           | [H : delim |- _] => destruct H
           | [H : inr _ = (~ _) |- _] => symmetry in H
           | [H : inr _ = inr _ |- _] => inv H
           | [H : inl _ = inl _ |- _] => inv H
           | [H : (~ ?a) = inr (#) |- _ ] => is_var a; destruct a; cbn in H; [congruence | ]
           | [H : % ?a = # |- _] => is_var a; destruct a; cbn in H; try congruence
           | [H : (~ _)= inr(inr ((_, _))) |- _] => apply polarityFlipGammaInv1 in H as ->
                end; try congruence.
    all: eauto. 
  Qed. 

  Lemma rewHeadTape_revp' γ1 γ2 γ3 γ4 γ5 γ6 : rewHeadTape [γ1; γ2; γ3] [γ4; γ5; γ6] -> rewHeadTape [~γ3; ~γ2; ~γ1] [~γ6; ~γ5; ~γ4]. 
  Proof. 
    intros. inv H. 
    - apply rewShiftRightTapeC. apply H1.
    - apply rewShiftLeftTapeC. now repeat rewrite polarityFlipGamma_involution.
    - apply identityWindow_revp in H1. now apply rewIdentityTapeC. 
  Qed. 

  Lemma rewHeadTape_revp γ1 γ2 γ3 γ4 γ5 γ6 : rewHeadTape [γ1; γ2; γ3] [γ4; γ5; γ6] <-> rewHeadTape [~γ3; ~γ2; ~γ1] [~γ6; ~γ5; ~γ4].
  Proof. 
    split. apply rewHeadTape_revp'. intros H%rewHeadTape_revp'. specialize polarityFlipGamma_involution as H1. unfold involution in H1.
    now repeat rewrite H1 in H.
  Qed.

  Lemma rewritesAt_rewHeadTape_add_at_end i a b h1 h2 : rewritesAt rewHeadTape i a b -> rewritesAt rewHeadTape i (a ++ h1) (b ++ h2).  
  Proof. 
    intros. unfold rewritesAt in *. inv H; symmetry in H0; symmetry in H1; repeat erewrite skipn_app2; eauto; try congruence; cbn; eauto. 
  Qed. 

  (** *basic facts about tape rewriting and automation *)
  Lemma tape_repr_step u h a b p w : (a :: u) ≃t(p, S w) (b :: h) -> u ≃t(p, w) h. 
  Proof. 
    intros (H1 & H2 & H3). cbn [length] in *; repeat split.
    - lia. 
    - lia. 
    - cbn [mapPolarity map] in H3. replace (wo + S w - S (|u|)) with (wo + w - (|u|)) in H3 by lia. 
      replace (map (fun e => inr (inr (p, Some e))) u) with (mapPolarity p u) in H3 by now cbn.  
      cbn [app] in H3. congruence. 
  Qed. 

  Lemma tape_repr_inv w u p (x : States) a : u ≃t(p, w) (@inl States tapeSigma x) :: a -> False. 
  Proof. 
    intros []. destruct H0. destruct u; now cbn in H1. 
  Qed. 

  Lemma tape_repr_inv2 w p p' (σ : Sigma) a : [] ≃t(p, w) (@inr States tapeSigma (inr (p', Some σ)))::a -> False. 
  Proof. 
    intros (H1 & H2 & H3).
    cbn in H3. congruence. 
  Qed. 

  Lemma tape_repr_inv3 w p p' (u : Sigma) (us : list Sigma) h : u :: us ≃t(p, w) (inr (inr (p', |_|)) :: h) -> False. 
  Proof. intros (H1 & H2 & H3). cbn in H3. congruence. Qed. 

  Lemma tape_repr_inv4 w p (u : list Sigma) h : u ≃t(p, w) (inr #) :: h -> False. 
  Proof. intros (H1 & H2 & H3). cbn in H3. destruct u; cbn in H3;  congruence. Qed. 

  Lemma tape_repr_inv5 w p u h e : u ≃t(p, w) (inr #) :: e:: h -> False. 
  Proof. intros (H1 & H2 & H3). destruct u; cbn in H3; congruence. Qed. 

  Lemma tape_repr_inv6 w p u us h : us :: u ≃t(p, w) h -> exists h' n, h = (inr (inr (p, Some us))):: h' ++ E p (wo + n) /\ w = n + S (|h'|) /\ |h'| = |u| /\ u ≃t(p, w -1) h' ++ E p (wo + n). 
  Proof.
    intros.
    destruct h. { destruct H. cbn in H; lia. }
    destruct H as (H1 & H2 & H3). 
    cbn [mapPolarity length map] in H3. exists (mapPolarity p u), (w - S (|u|)). 
    repeat split. 
    - cbn in H2, H1. replace (wo + (w - S (|u|))) with (wo + w - S (|u|)) by lia. apply H3. 
    - unfold mapPolarity. rewrite map_length. cbn in H2. lia. 
    - unfold mapPolarity. now rewrite map_length. 
    - unfold mapPolarity. rewrite app_length, map_length. cbn in H1, H2. rewrite E_length. lia. 
    - cbn in H2; lia. 
    - cbn in H2. easy.
  Qed.

  Lemma tape_repr_inv7 w p p' u us n : us :: u ≃t(p, w) E p' n -> False. 
  Proof. intros (H1 & H2 & H3). destruct n; cbn in H3; congruence. Qed.

  Lemma tape_repr_inv8 u us p w e rs : us :: u ≃t(p, w) inr(inr e) :: rs -> e = (p, Some us). 
  Proof. intros (H1 & H2 & H3). cbn in H3. congruence. Qed. 

  Lemma tape_repr_inv9 us1 p w e1 rs : [us1] ≃t(p, S w) e1 :: rs -> rs = E p (wo + w). 
  Proof. 
    intros (H1 & H2 & H3). cbn in H3. inv H3. easy. 
  Qed. 

  Lemma tape_repr_inv10 u p w rs : u ≃t(p, w) rs -> w >= |u|. 
  Proof. 
    intros (H1 & H2 & H3). now cbn in H2. 
  Qed. 

  Lemma tape_repr_inv11 u p w rs : u ≃t(p, w) rs -> |rs| >= S wo. 
  Proof. intros (H1 & H2 & H3). rewrite H1. lia. Qed. 

  Lemma tape_repr_inv12 u p w rs : u ≃t(p, w) rs -> forall x, x el rs -> exists y, x = inr y. 
  Proof. 
    intros (_ & _ & ->) x H1. 
    apply in_app_or  in H1 as [H1 | H1]. 
    + unfold mapPolarity in H1. apply in_map_iff in H1 as (? & <- & H2). eauto. 
    + revert H1. generalize (wo + w - |u|). induction n; intros [H | H]; eauto. 
  Qed. 

  Lemma tape_repr_inv13 u p p' w rs σ: u ≃t(p, w) (inr (inr (p', Some σ)) :: rs) -> p' = p /\ exists u', u = σ :: u'. 
  Proof. 
    intros (H1 & H2 & H3). destruct u; cbn in *. 
    + congruence. 
    + split; [ | exists u];  congruence. 
  Qed. 

  Lemma tape_repr_inv14 u p w rs e: u ≃t(p, w) e :: inr (#) :: rs -> False. 
  Proof. 
    intros (H1 & H2 & H3). destruct u; unfold wo in H3; cbn in H3; try congruence.
    destruct u; cbn in H3; try congruence.
  Qed. 

  Lemma tape_repr_inv15 u p w : u ≃t(p, w) [] -> False. 
  Proof.
    intros (H1 & H2 & H3). now cbn in H1.
  Qed. 

  Ltac destruct_tape1 := repeat match goal with [H : delim |- _ ] => destruct H end.
  Ltac discr_tape := destruct_tape1; match goal with
                     | [H : ?u ≃t(?p, ?w) [] |- _] => now apply tape_repr_inv15 in H
                     | [ H : ?u ≃t(?p, ?w) (inl ?e) :: ?a |- _] => now apply tape_repr_inv in H
                     
                     | [ H : [] ≃t(?p, ?w) (inr (inr (_, Some ?e))) :: ?a |- _] => now apply tape_repr_inv2 in H
                     | [ H : ?u :: ?us ≃t(?p, ?w) inr (inr (_, |_|)):: ?a |- _] => now apply tape_repr_inv3 in H
                     | [H : _ ≃t(_, _) _ :: inr # :: _ |- _ ] => now apply tape_repr_inv14 in H
                     | [ H : ?us ≃t(?p, ?w) inr # :: ?a |- _] => now apply tape_repr_inv4 in H
                     | [H : _ ≃t(?p, ?w) inr # :: ?e :: ?a |- _] => now apply tape_repr_inv5 in H
                     | [H : ?u :: ?us ≃t(?p, 0) _ |- _] => destruct H; cbn in *; lia
                     | [H : ?u :: ?us ≃t(?p, ?w) E _ ?n |- _] => now apply tape_repr_inv7 in H
                     | [H : ?us ≃t(?p, ?w) ?a |- _] => let H1 := fresh in apply tape_repr_inv11 in H as H1; unfold wo in H1; cbn [length] in H1; lia (*this is really expensive, but in some cases desirable to have *)
                     (* | [H : ?us ≃t(?p, ?w) _ |- _] => try (apply tape_repr_inv10 in H; cbn in H; lia) *)
                      end. 

  Ltac inv_tape' H := repeat match type of H with
                        | _ ≃t(?p, ?w) ?x :: ?h => is_var x; destruct x; [discr_tape | ]     
                        | _ ≃t(?p, ?w) (inr ?e) :: ?h => is_var e; destruct e; [discr_tape | ]
                        | [] ≃t(?p, ?w) (inr (inr ?e)) :: ?h => is_var e; destruct e
                        | ?u ≃t(?p, ?w) inr (inr (_, |_|)) :: ?h => is_var u; destruct u; [ | discr_tape] 
                        | ?u :: ?us ≃t(?p, ?w) ?h => is_var h; destruct h; [ discr_tape | ]
                        | ?u :: ?us ≃t(?p, ?w) ?h' ++ ?h'' => is_var h'; destruct h'; cbn in H; try discr_tape
                        | ?u :: ?us ≃t(?p, ?w) inr(inr ?e) :: _ => is_var e; specialize (tape_repr_inv8 H) as ->  
                        | ?u1 :: _ ≃t(?p, ?w) _  => is_var w; destruct w; [ discr_tape | ]
                        | ?u1 :: [] ≃t(_, S ?w) _ :: ?h  => specialize (tape_repr_inv9 H) as ->
                        | ?u ≃t(_, _) inr (inr (_, Some _)) :: _ => is_var u;
                                                                  let Heqn := fresh "Hpeqn" in
                                                                  specialize (tape_repr_inv13 H) as (Heqn & (? & ->)); inv Heqn
                        end;
                        (*if we can, we go into recursion after applying tape_repr_step *)
                        match type of H with
                        |  ?u1 :: _ ≃t(?p, S ?w) ?e :: _  => let H' := fresh in specialize (tape_repr_step H) as H'; inv_tape' H'; clear H' 
                         | _ => idtac
                        end.

  (*the destruct_tape_in tactic generates equations for subtapes which are equal to E _. *)
  (*We do not want to call inv on those equations since they might contain non-trivial equalities which cannot be resolved with a rewrite and would thus be lost with inv*)
  Ltac clear_trivial_niltape H := cbn in H; match type of H with
        | inr (inr (?p, |_|)) :: ?h = inr (inr (?p, |_|)) :: ?h' => let H' := fresh in assert (h = h') as H' by congruence; tryif clear_trivial_niltape H' then clear H else clear H'
        | ?h = inr (inr _) :: _ => is_var h; rewrite H in *; clear H
        | ?h = E _ _ => is_var h; rewrite H in *; clear H
  end.

  Ltac destruct_tape_in H := unfold reprTape in H;
                             inv_tape' H;
                             try match type of H with
                                 | [] ≃t(_, _) ?h => let H' := fresh in specialize (proj2 (niltape_repr _ _ ) _ H) as H'; clear_trivial_niltape H'
                                 | ?u ≃t(?p, ?w) inr _ :: ?h  => is_var u; destruct u; try discr_tape
                                 end;
                             inv_tape' H;
                             repeat match goal with [H : ?h = ?h |- _] => clear H end.

  Ltac destruct_tape_in_tidy H := unfold reprTape in H;
                             try match type of H with
                                 | _ ≃t(_, z') _ => let H' := fresh "n" in let H'' := fresh H' "Zeqn" in
                                                    remember z' as H' eqn:H'' in H; destruct_tape_in H;
                                                    repeat match goal with [H2 : context[wo + H'] |- _]=> cbn [wo Nat.add] in H2 end; rewrite !H'' in *; try clear H' H'' 
                                 | _ => destruct_tape_in H
                             end. 
 
  Ltac inv_tape := match goal with
                        | [H : _ ≃t(_, _) _ |- _] => inv_tape' H
                   end. 

  Ltac unfold_tape := unfold reprTape in *. 
                        
  Ltac destruct_tape := unfold_tape; inv_tape;
                        try match goal with
                        | [H: ?u ≃t(?p, ?w) inr _ :: ?h |- _] => is_var u; destruct u; try discr_tape
                            end;
                        inv_tape;
                        repeat match goal with [H : ?h = ?h |- _] => clear H end.


  (** rewHeadTape specific automation *)
  Ltac rewHeadTape_inv := repeat match goal with 
                                   | [H : rewHeadTape  ?a _ |- _] => is_var a; destruct a; try (inv H; fail)
                                   | [H : rewHeadTape  (_ :: ?a) _ |- _] => is_var a; destruct a; try (inv H; fail)
                                   | [H : rewHeadTape  (_ :: _ :: ?a) _ |- _] => is_var a; destruct a; try (inv H; fail)
                                   | [H : rewHeadTape  _ ?a |- _ ] => is_var a; destruct a; try (inv H; fail)
                                   | [H : rewHeadTape  _ (_ :: ?a) |-_ ] => is_var a; destruct a; try (inv H; fail)
                                   | [H : rewHeadTape  _ (_ :: _ :: ?a) |- _] => is_var a; destruct a; try (inv H; fail)
                                                             
                               end; cbn.

  (* Lemma polarityFlip_push_in (σ : tapeSigma') : inr (inr (polarityFlipTapeSigma' σ)) = polarityFlipGamma (inr (inr σ)).  *)
  (* Proof. now cbn. Qed.  *)

  Ltac rewHeadTape_inv2 := repeat match goal with
                                  | [H : rewHeadTape _ _ |- _] => inv H
                                  | [H : shiftRightWindow _ _ _ _ _ _ |- _ ] => inv H
                                  | [H : identityWindow _ _ _ _ _ _ |- _] => inv H
                                  | [d : delim |- _] => destruct d
                                  (* | [H : |_| = # ?σ |- _] => is_var σ; destruct σ; cbn in H; try congruence *)
                                  (* | [H : # ?σ = |_| |- _] => is_var σ; destruct σ; cbn in H; try congruence *)
                                  (* | [H : Some (_, _) = % ?e |- _] => symmetry in H; apply polarityFlipTapeSigmaInv1 in H; rewrite H in *; clear H *)
                                  (* | [H : % ?e = Some (_, _) |- _] => apply polarityFlipTapeSigmaInv1 in H; rewrite H in *; clear H *)
                                  (* | [H : Some (_, _) = # ?e |- _] => symmetry in H; apply polarityFlipTapeSigma'Inv1 in H; rewrite H in *; clear H *)
                                  (* | [H : # ?e = Some (_, _) |- _] => apply polarityFlipTapeSigma'Inv1 in H; rewrite H in *; clear H *)
                                  (* | [H : inr _ = (~ _) |- _] => symmetry in H *)
                                  (* | [H : (~ ?a) = inr (inr |_|) |- _] => is_var a; destruct a; cbn in H; [ congruence | ] *)
                                  | [H : (~?e) = inr (inr (_, _)) |- _] => apply polarityFlipGammaInv1 in H; try rewrite H in *; clear H
                                  | [H : inr (inr (_, _)) = (~?e) |- _] => symmetry in H; apply polarityFlipGammaInv1 in H; try rewrite H in *; clear H
                                  (* | [H : % ?a = inr |_| |- _] => is_var a; destruct a; cbn in H; try congruence  *)
                                  (* | [H : $ = $ |- _] => clear H *)
                                  | [H : inr _ = inr _ |- _] => inv H
                                  | [H : inl _ = inl _ |- _] => inv H
                                  (* | [H : |_| = |_| |- _] => clear H *)
                                  (* | [ |- context [inr (inr (# ?e))]] => rewrite polarityFlip_push_in *)
                           end; try congruence. 
 
  (*Lemma 15 *)
  Lemma tape_rewrite_symm1 h h' : valid rewHeadTape h h' -> valid rewHeadTape (polarityRev h) (polarityRev h'). 
  Proof.
    intros.  
    induction H; intros. 
    - cbn; constructor. 
    - apply valid_length_inv in H.
      destruct a, b; try destruct a; try destruct b; cbn in *; try lia. all: repeat constructor. 
    - rewHeadTape_inv. 
      rewrite valid_iff. unfold validExplicit. cbn [polarityRev map rev]. repeat rewrite app_length.
      repeat rewrite rev_length, map_length. cbn [length]. split.
      1: apply valid_length_inv in H; now cbn [length] in H. 
      replace ((|a|) + 1 + 1 + 1 - 2) with (S (|a|)) by lia. intros. destruct (nat_eq_dec i (|a|)) as [-> | F]. 
      * (*rewrite at the new position, cannot apply IH *)
        unfold rewritesAt. 
        apply rewHeadTape_rem_tail in H0.
        apply rewHeadTape_revp' in H0. 
        cbn [rev map].
        repeat rewrite <- app_assoc.
        rewrite skipn_app with (xs := rev (map polarityFlipGamma a)).
        rewrite skipn_app with (xs := rev (map polarityFlipGamma b)).
        2, 3: rewrite rev_length, map_length. 3: reflexivity. 
        2: { apply valid_length_inv in H; cbn [length] in H. lia. }
        cbn. apply H0. 
      * (*this follows by IH *)
        cbn [polarityRev map rev] in IHvalid. 
        apply valid_iff in IHvalid as (IH1 & IH2). 
        assert (0 <= i < |a|) by lia. 
        repeat rewrite app_length in IH2. rewrite rev_length, map_length in IH2. cbn [length] in IH2.
        replace ((|a|) + 1 + 1 - 2) with (|a|) in IH2 by lia. 
        specialize (IH2 i H2).
        apply rewritesAt_rewHeadTape_add_at_end. apply IH2. 
  Qed. 


  Lemma tape_rewrite_symm2 h h' : valid rewHeadTape (polarityRev h) (polarityRev h') -> valid rewHeadTape h h'.
  Proof.
    intros. specialize (tape_rewrite_symm1 H) as H1. now repeat rewrite polarityRev_involution in H1.
  Qed. 


  Hint Extern 4 (rewHeadTape _ _) => apply rewShiftLeftTapeC; cbn [polarityFlipGamma polarityFlipTapeSigma polarityFlipSigma polarityFlip]. 

  Lemma tape_rewrite_symm3 h h' :valid rewHeadTape h h' -> valid rewHeadTape (map polarityFlipGamma h) h'. 
  Proof. 
    intros. unfold reprTape in H. induction H; intros. 
    - cbn; constructor. 
    - cbn [map polarityFlipGamma]. constructor. 2: now rewrite map_length. apply IHvalid.  
    - cbn [map polarityFlipGamma]. rewHeadTape_inv. constructor 3. 
      + (* want to apply the IH *)
        apply IHvalid. 
      + cbn [map polarityFlipGamma]. apply rewHeadTape_rem_tail.
        rewHeadTape_inv2; cbn; eauto 100.
  Qed.

  (*Lemma 16 *)
  Lemma E_rewrite_blank p p' n: valid rewHeadTape (E p (S (S n))) (E p' (S (S n))). 
  Proof. 
    intros. induction n. 
    + apply valid_base. eauto. 
    + constructor 3. 
      - cbn [E] in IHn. now apply IHn. 
      - destruct p'; eauto. 
  Qed. 

  Lemma E_rewrite_blank_unique' p p' n : n >= 1 -> forall s, valid rewHeadTape (E p' (S n)) (inr (inr (p, |_|)) :: s) -> s = E p n. 
  Proof. 
    intros H. induction n; intros; [lia | ]. 
    destruct n; cbn [E] in *. 
    + inv_valid. rewHeadTape_inv2. 
      apply valid_length_inv in H4. inv H4. now (destruct h2; cbn in H1).
    + inv_valid. rewHeadTape_inv2.
      1-2: cbn in *; destruct p; cbn in H5; try congruence; clear H5.
      all: apply IHn in H4; [congruence | lia]. 
  Qed. 

  Corollary E_rewrite_blank_unique p p' n : forall s, valid rewHeadTape (E p (S (S n))) (inr (inr (p', |_|)) :: s) -> s = E p' (S n).  
  Proof. intros; now eapply E_rewrite_blank_unique'. Qed.

  Lemma E_rewrite_blank_rev p p' w : valid rewHeadTape (rev (E p (S (S w)))) (rev (E p' (S (S w)))).  
  Proof. 
    rewrite <- polarityFlip_involution with (x := p). rewrite <- polarityFlip_involution with (x := p'). 
    rewrite <- !E_polarityFlip. apply tape_rewrite_symm1. rewrite !E_polarityFlip. apply E_rewrite_blank.
  Qed. 

  Lemma E_rewrite_blank_rev_unique p p' w s : valid rewHeadTape (rev (E p (S (S w)))) (rev (inr (inr (p', |_|)) :: s)) -> s = (E p' (S (w))). 
  Proof. 
    intros.
    assert (valid rewHeadTape (polarityRev (E (polarityFlip p) (S (S w)))) (polarityRev (map polarityFlipGamma (inr (inr (p', |_|)) :: s)))). 
    { unfold polarityRev. rewrite E_polarityFlip. rewrite map_involution. 2: involution_simpl. rewrite polarityFlip_involution. apply H.  }
    apply tape_rewrite_symm2 in H0.
    cbn in H0. apply E_rewrite_blank_unique in H0. apply involution_invert_eqn2 with (a := s) (f:= (map polarityFlipGamma))  (b := E (polarityFlip p') (S w)) in H0.
    2: involution_simpl. now rewrite H0, E_polarityFlip, polarityFlip_involution. 
  Qed. 

  (*Lemma 17 *)
  Lemma E_rewrite_sym p σ n: valid rewHeadTape (E p (S (S (S n)))) (inr (inr (positive, Some σ)) :: E positive (S (S n))). 
  Proof. 
    cbn [E].
    constructor 3. 
    - apply E_rewrite_blank. 
    - eauto. 
  Qed. 

  Lemma E_rewrite_sym_unique p σ n : forall (s : string Gamma), valid rewHeadTape (E p (S (S (S n)))) (inr (inr (positive, σ)) :: s) -> s = E positive (S (S n)). 
  Proof. 
    intros. inv_valid. rewHeadTape_inv2.
    all: cbn [E]; f_equal; apply E_rewrite_blank_unique in H3; auto. 
  Qed. 

  Lemma E_rewrite_sym_rev p σ n : valid rewHeadTape (rev (E p (S (S (S n))))) (rev (inr (inr (negative, Some σ)) :: E negative (S (S n)))). 
  Proof. 
    (*follows using tape_rewrite_symm1, tape_rewrite_symm3 and E_rewrite_sym *)
    specialize (E_rewrite_sym p σ n) as H1. 
    eapply tape_rewrite_symm1 in H1. 
    eapply tape_rewrite_symm3 in H1.
    unfold polarityRev in H1. rewrite map_rev, map_map in H1. setoid_rewrite polarityFlipGamma_involution in H1. rewrite map_id in H1. 
    cbn [map polarityFlipGamma polarityFlipTapeSigma polarityFlipSigma polarityFlip] in H1. 
    now rewrite E_polarityFlip in H1. 
  Qed. 

  Lemma E_rewrite_sym_rev_unique p σ n : forall s, valid rewHeadTape (rev (E p (S (S (S n))))) (rev (inr (inr (negative, Some σ)) :: s)) -> s = E negative (S (S n)). 
  Proof. 
    intros.
    assert (valid rewHeadTape (polarityRev (E (polarityFlip p) (S (S (S n))))) (polarityRev (inr (inr (positive, Some σ)) :: map polarityFlipGamma s))). 
    {
      unfold polarityRev. rewrite E_polarityFlip. cbn. rewrite map_involution. 2: involution_simpl.
      specialize (polarityFlip_involution p) as H1. rewrite H1. apply H. 
    }
    eapply tape_rewrite_symm2 in H0.
    apply E_rewrite_sym_unique in H0. 
    enough (map polarityFlipGamma (E negative (S (S n))) = E positive (S (S n))).
    { rewrite <- H1 in H0. apply involution_invert_eqn in H0. assumption. apply map_involution, polarityFlipGamma_involution. }
    apply E_polarityFlip. 
  Qed. 

  Lemma E_rewrite_sym_rem p σ n : valid rewHeadTape (inr (inr (p, Some σ)) :: E p (S (S n))) (E negative (S (S (S n)))). 
  Proof. 
    cbn. constructor 3.  
    - apply E_rewrite_blank.
    - eauto. 
  Qed. 

  Lemma  E_rewrite_sym_rem_unique p p' σ n : forall s, valid rewHeadTape (inr (inr (p, Some σ)) :: E p (S (S n))) (inr (inr (p', |_|)):: s) -> p' = negative /\ s = E negative (S (S n)). 
  Proof. 
    intros. inv_valid. rewHeadTape_inv2.
    destruct p'; cbn in H5; try congruence; clear H5.
    split; [reflexivity | ]. 
    inv_valid. 1: destruct n; cbn in H5; lia.
    rewHeadTape_inv2.
    3: { destruct n; cbn in *; inv H3. apply valid_length_inv in H2; destruct h0; cbn in H2; congruence.   }
    all: destruct n; cbn in H3; [congruence | ];
      apply E_rewrite_blank_unique in H2;
      rewrite H2; easy.   
  Qed. 

  Lemma E_rewrite_sym_rem_rev p σ n : valid rewHeadTape (rev (inr (inr (p, Some σ)) :: E p (S (S n)))) (rev (E positive (S (S (S n))))). 
  Proof. 
    specialize (E_rewrite_sym_rem p σ n) as H1. 
    eapply tape_rewrite_symm1 in H1. 
    eapply tape_rewrite_symm3 in H1.
    unfold polarityRev in H1. rewrite map_rev, map_map in H1. setoid_rewrite polarityFlipGamma_involution in H1. rewrite map_id in H1. 
    cbn [map polarityFlipGamma polarityFlipTapeSigma polarityFlipSigma polarityFlip] in H1. 
    now rewrite E_polarityFlip in H1. 
  Qed. 

  Lemma E_rewrite_sym_rem_rev_unique p p' σ n : forall s, valid rewHeadTape (rev (inr (inr (p, Some σ)) :: E p (S (S n)))) (rev (inr (inr (p', |_|)) :: s)) -> p' = positive /\ s = E p' (S (S n)). 
  Proof. 
    intros.
    assert (valid rewHeadTape (polarityRev (inr (inr (polarityFlip p, Some σ)) :: E (polarityFlip p) (S (S n)))) (polarityRev (inr (inr (polarityFlip p', |_|)) :: map polarityFlipGamma s))). 
    {
      unfold polarityRev. cbn [map]. rewrite E_polarityFlip. cbn. rewrite map_involution. 2: apply polarityFlipGamma_involution.
      specialize (polarityFlip_involution) as H1. unfold involution in H1. 
      rewrite !H1. apply H. 
    }
    eapply tape_rewrite_symm2 in H0.
    apply E_rewrite_sym_rem_unique in H0 as (H0 & H1). 
    destruct p'; cbn in H0; try congruence; clear H0. 
    split; [reflexivity | ]. 
    enough (map polarityFlipGamma (E negative (S (S n))) = E positive (S (S n))).
    { rewrite <- H1 in H0. rewrite map_involution in H0; [apply H0 | involution_simpl]. }
    apply E_polarityFlip. 
  Qed. 

  (*Lemma 18 *)
  Lemma tape_repr_add_right rs σ h p w: rs ≃t(p, w) h -> length rs < w -> exists h', valid rewHeadTape h (inr (inr (↑ (Some σ))) :: h')  /\ (forall h0, valid rewHeadTape h (inr (inr (↑ (Some σ))) :: h0) -> h0 = h') /\ σ :: rs ≃t(positive, w)  (inr (inr (↑ (Some σ))) :: h'). 
  Proof. 
    intros. revert w h σ H H0. 
    induction rs.
    - intros. destruct_tape_in_tidy H.  exists (E positive (wo + w - 1)). rewrite <- and_assoc; split. 
      + cbn in H0. destruct w; [lia | ]. unfold wo. replace (2 + S w) with (S (S (S w))) by lia. cbn [Nat.sub]. split.
        * (*existence*) apply E_rewrite_sym.
        * (*uniqueness*) intros. eapply E_rewrite_sym_unique with (σ := Some σ). apply H1. 
      + repeat split. 
        * cbn. rewrite E_length. lia. 
        * now cbn. 
    - intros. apply tape_repr_inv6 in H as (h' & n & -> & -> & H2 & H3).
      replace (n + S (|h'|) - 1) with (n + |h'|) in H3 by lia.
      destruct rs; [ | destruct rs].
      + (*at the end of the used tape region *)
        destruct h'; [clear H2 | now cbn in H2]. clear H3. destruct n; [cbn in H0; cbn in H0; lia | ].
        exists (inr (inr ((↑ (Some a)))):: E positive (wo + n)). rewrite <- and_assoc; split.
        * cbn [app]. cbn [Nat.add Nat.sub]. split.
          ++ (*existence*) constructor 3. 
             -- apply E_rewrite_sym. 
             -- cbn [E]. apply rewHeadTape_rem_tail. eauto. 
          ++ (*uniqueness *) intros. inv_valid.
             rewHeadTape_inv2. apply E_rewrite_sym_unique with (σ := Some a) in H4. now inv H4. 
        * repeat split. 
          -- cbn. rewrite E_length. cbn in H0. lia. 
          -- cbn; cbn in H0; lia. 
          -- cbn. now rewrite Nat.add_comm.
      + (* rs has length 1*)
        destruct_tape. cbn [app] in H3. 
        destruct h'; [ | now cbn in H2]. clear H2.
        cbn [app] in H3. destruct_tape. cbn [length] in *.
        destruct n; [lia | ]. clear H0. 
        exists (inr(inr (↑ (Some a))) :: inr (inr (↑ (Some e))) :: E positive (wo + n)). 
        cbn [app]; rewrite <- and_assoc; split. 
        * split.
          ** (*existence*) constructor 3. 
              -- replace (2 + S n) with (S(S (S n))) by lia. constructor 3. 
                ++ apply E_rewrite_sym. 
                ++ cbn [E]. apply rewHeadTape_rem_tail; eauto. 
              -- cbn[E]. apply rewHeadTape_rem_tail. eauto. 
          ** (*uniqueness*)
            intros. inv_valid. rewHeadTape_inv2. 
            inv_valid. rewHeadTape_inv2. 
            apply E_rewrite_sym_unique in H2. 
            cbn [E] in H2. inv H2. inv H3. reflexivity.  
        * repeat split.
          -- cbn. rewrite E_length. lia. 
          -- cbn; lia. 
          -- cbn[mapPolarity map length app]. now replace (wo + (S n + 2) - 3) with (wo + n) by lia. 
     + (*rs has at least two elements. this is the interesting case as it needs the IH *) 
       destruct_tape. cbn [app] in H3. cbn [length app] in H3. rewrite Nat.add_succ_r in H3. 
       apply tape_repr_step in H3 as H4. destruct_tape. cbn [app] in H4. 
       cbn [app length] in *. destruct_tape. 

       (*we use the IH with h := inr (...e) :: inr (...e0) :: h' ++ E(n + wo); w := S (S (n + |h'|)); σ := a *)
       rewrite Nat.add_succ_r in H3. specialize (IHrs _ _ a H3). 
       edestruct (IHrs) as (h'' & F1 & F3 & F2). lia. 
       exists (inr (inr (↑(Some a))) :: h'').
       (*we need to know one more symbol at the head of h'' for the proof *)
       destruct_tape_in F2. 
       rewrite <- and_assoc; split; [split | ].
       * (*existence*)constructor 3.  
         -- apply F1. 
         -- apply rewHeadTape_rem_tail; eauto. 
       * (*uniqueness*)
         intros. clear IHrs. inv_valid. rewHeadTape_inv2. apply F3 in H7. inv H7. reflexivity. 
       * repeat split.
         -- cbn. destruct F2 as (F2 & _ & _). cbn in F2. lia.  
         -- cbn. destruct F2 as (_ & F2 & _). cbn in F2. lia. 
         -- destruct F2 as (_ & _ & ->). cbn[app length Nat.add Nat.sub].
            replace (wo + (n + S (S (S (|h'|)))) - (S (S (S (S(|rs|)))))) with (wo + S (S (n + (|h'|))) - S (S (S(|rs|)))) by lia.
            easy. 
  Qed. 


  Corollary tape_repr_add_left ls σ h p w: ls ≃t(p, w) h -> length ls < w -> exists h', valid rewHeadTape (rev h) (rev (inr (inr (↓ (Some σ))) :: h'))  /\ (forall h0, valid rewHeadTape (rev h) (rev (inr (inr (↓ (Some σ))) :: h0)) -> h0 = h') /\ σ :: ls ≃t(negative, w)  (inr (inr (↓ (Some σ))) :: h').
  Proof. 
    intros. specialize (@tape_repr_add_right ls σ h p w H H0) as (h' & H1 & H3 & H2). 
    exists (map polarityFlipGamma h'). rewrite <- and_assoc. split. 
    - eapply tape_rewrite_symm1 in H1.  
      apply tape_rewrite_symm3 in H1. split. 
      + cbn [rev].
        cbn[polarityRev map rev polarityFlipGamma polarityFlipTapeSigma polarityFlipSigma polarityFlip] in H1.
        unfold polarityRev in H1. rewrite map_rev in H1. rewrite map_involution in H1. 2: apply polarityFlipGamma_involution. 
        apply H1. 
      + intros. specialize (H3 (map polarityFlipGamma h0)).
        rewrite <- involution_invert_eqn2 with (f := map polarityFlipGamma) (a := h0) (b := h'); [reflexivity | apply map_involution, polarityFlipGamma_involution | ]. 
        apply H3. eapply tape_rewrite_symm2. 
        unfold polarityRev. rewrite <- map_rev. apply tape_rewrite_symm3. 
        cbn. rewrite map_involution; [now apply H4 | apply polarityFlipGamma_involution]. 
   - apply tape_repr_polarityFlip in H2. cbn in H2. easy. 
  Qed. 

  (*Lemma 19*)
  Lemma tape_repr_rem_right' rs σ1 σ2 (h : list Gamma) p w : σ1 :: σ2 :: rs ≃t(p, w) inr (inr (p, Some σ1)) :: inr (inr (p, Some σ2)) :: h -> exists (h' : list Gamma), valid rewHeadTape (inr (inr (p, Some σ1)) :: inr (inr (p, Some σ2)) :: h) (inr (inr (↓ (Some σ2))) :: h') /\ (forall h0, valid rewHeadTape (inr (inr (p, Some σ1)) :: inr (inr (p, Some σ2)) :: h) (inr (inr (↓ (Some σ2))) :: h0) -> h0 = h') /\ σ2 :: rs ≃t(negative, w) (inr (inr (↓ (Some σ2))) :: h').   
  Proof. 
    revert w h σ1 σ2. 
    induction rs. 
    - intros. destruct_tape. exists (E negative (S wo + w)). rewrite <- and_assoc; split. 
      + (* existence*) split.
        * constructor 3.
          -- constructor 3.
             ++ apply E_rewrite_blank. 
             ++ apply rewHeadTape_rem_tail. eauto. 
          -- apply rewHeadTape_rem_tail. eauto. 
        * (*uniqueness *) intros. do 2 (inv_valid; rewHeadTape_inv2).  
           apply E_rewrite_blank_unique in H3. inv H3. now cbn. 
      + (*correctness*)
        repeat split.
        * cbn. rewrite E_length. lia. 
        * now cbn.
  - intros. destruct_tape_in H. 
    destruct rs. 
    + destruct_tape_in H. 
      exists (inr (inr (↓ (Some a))) :: E negative (S wo + w)). rewrite <- and_assoc; split. 
      * split. 
        -- constructor 3.
           ++ constructor 3. { apply E_rewrite_sym_rem. }
              apply rewHeadTape_rem_tail. eauto.  
           ++ apply rewHeadTape_rem_tail. eauto.
        -- (* uniqueness*) intros.  
           inv_valid. rewHeadTape_inv2; [inv_valid; rewHeadTape_inv2 | ].
           do 2 inv_valid; rewHeadTape_inv2. 
           apply E_rewrite_blank_unique in H4. inv H4. cbn [E]; easy. 
      * (*correctness *)
        repeat split. 
        -- cbn [length]. rewrite E_length. lia. 
        -- now cbn.
    + destruct_tape.
      (*need IH *)
      apply tape_repr_step in H. 
      specialize (IHrs _ _ σ2 a H) as (h0 & F1 & F2 & F3). destruct_tape. 
      exists (inr (inr (↓ (Some a))) :: (inr (inr (↓ (Some e)))) :: h0). 
      rewrite <- and_assoc; split; [split | ]. 
      * constructor 3.
        -- apply F1. 
        -- apply rewHeadTape_rem_tail. eauto. 
      * (*uniqueness *)intros. inv_valid. rewHeadTape_inv2; apply F2 in H4; now inv H4. 
      * clear F2 F1 H. destruct F3 as (H1 & H2 & H3). repeat split.
        -- cbn in *. lia. 
        -- cbn in *; lia. 
        -- inv H3. easy. 
  Qed.      

  Lemma tape_repr_rem_right rs σ1 (σ2 : stateSigma) h p w : σ1 :: rs ≃t(p, w) inr (inr (p, Some σ1)) :: inr (inr (p, σ2)) :: h -> exists h', valid rewHeadTape (inr (inr (p, Some σ1)) :: inr (inr (p, σ2)) :: h) (inr (inr (negative, σ2)) :: h') /\ (forall h0, valid rewHeadTape (inr (inr (p, Some σ1)) :: inr (inr (p, σ2)) :: h) (inr (inr (negative, σ2)) :: h0) -> h0 = h' ) /\ rs ≃t(negative, w) (inr (inr (negative, σ2)) :: h'). 
  Proof. 
    intros. destruct σ2 as [σ2 | ].
    + inv_tape' H.
      now apply tape_repr_rem_right'.
    + destruct_tape_in_tidy H.
      apply tape_repr_step in H as H'. destruct_tape_in_tidy H'. clear H'.
      exists (E negative (wo + w)). repeat split. 
      * constructor 3; [apply E_rewrite_blank | eauto ].
      * intros. inv_valid. rewHeadTape_inv2. 
        apply E_rewrite_blank_unique in H4. now inv H4.  
      * cbn; now rewrite E_length. 
      * now cbn. 
  Qed.

  Corollary tape_repr_rem_left ls σ1 (σ2 : stateSigma) h p w : σ1 :: ls ≃t(p, w) inr (inr (p, Some σ1)) :: inr (inr (p, σ2)) :: h -> exists h', valid rewHeadTape (rev (inr (inr (p, Some σ1)) :: inr (inr (p, σ2)) :: h)) (rev (inr (inr (positive, σ2)) :: h')) /\ (forall h0, valid rewHeadTape (rev (inr (inr (p, Some σ1)) :: inr (inr (p, σ2)) :: h)) (rev (inr (inr (positive, σ2)) :: h0)) -> h0 = h') /\ ls ≃t(positive, w) (inr (inr (positive, σ2)) :: h').
  Proof. 
    intros. specialize (@tape_repr_rem_right ls σ1 σ2 h p w H) as (h' & H1 & H3 & H2). 
    exists (map polarityFlipGamma h'). rewrite <- and_assoc. split. 
    - eapply tape_rewrite_symm1 in H1. apply tape_rewrite_symm3 in H1.
      split. 
      + unfold polarityRev in H1. rewrite map_rev in H1. rewrite map_involution in H1. 2: apply polarityFlipGamma_involution.  destruct σ2; cbn in H1; cbn; apply H1.
      + intros. specialize (H3 (map polarityFlipGamma h0)).
        rewrite <- involution_invert_eqn2 with (f := map polarityFlipGamma) (a := h0) (b := h'); [reflexivity | apply map_involution, polarityFlipGamma_involution | ]. 
        apply H3. eapply tape_rewrite_symm2. 
        unfold polarityRev. rewrite <- map_rev. apply tape_rewrite_symm3. 
        cbn in *. rewrite map_involution; [destruct σ2; cbn in *; now apply H0 | apply polarityFlipGamma_involution]. 
   - apply tape_repr_polarityFlip in H2. destruct σ2; cbn in H2; easy. 
  Qed. 


  (*Lemma 20*)
  Lemma E_rewrite_sym_stay p σ n : valid rewHeadTape (inr (inr (p, Some σ)) :: E p (S (S n))) (inr (inr (∘ (Some σ))) :: E neutral (S (S n))).  
  Proof. 
    constructor 3. 
    - apply E_rewrite_blank. 
    - cbn[E]. apply rewHeadTape_rem_tail. eauto. 
  Qed. 

  Lemma tape_repr_stay_right' rs σ h p w : σ :: rs ≃t(p, w) inr(inr (p, Some σ)) :: h -> exists h', valid rewHeadTape (inr (inr (p, Some σ)) :: h) (inr (inr (neutral, Some σ)) :: h') /\ (forall h0, valid rewHeadTape (inr (inr (p, Some σ)) :: h) (inr (inr (∘ (Some σ))) :: h0) -> h0 = h') /\ σ :: rs ≃t(neutral, w) (inr (inr (∘ (Some σ)))) :: h'. 
  Proof. 
    revert w h σ.  
    induction rs. 
    - intros. destruct_tape. exists (E neutral (wo + w)). 
      rewrite <- and_assoc. split. 
      + split.
        * constructor 3. apply E_rewrite_blank.
          apply rewHeadTape_rem_tail. eauto. 
        * intros. inv_valid.  
          rewHeadTape_inv2. apply E_rewrite_blank_unique in H4. inv H4. easy. 
      + repeat split; cbn in *; try rewrite E_length; cbn in *; easy. 
    - intros. destruct_tape_in H. destruct rs; destruct_tape_in H. 
      + exists (inr (inr (∘ (Some a))) :: E neutral (wo + w)). rewrite <- and_assoc; split. 
        * split.
          -- constructor 3. 2: { apply rewHeadTape_rem_tail. eauto. }
             apply E_rewrite_sym_stay. 
          -- intros. do 2 (inv_valid; rewHeadTape_inv2). 
             apply E_rewrite_blank_unique in H3. inv H3. easy. 
        * repeat split; cbn in *; try rewrite E_length; cbn in *; easy.  
     + apply tape_repr_step in H. specialize (IHrs _ _ a H) as (h0 & F1 & F2 & F3). destruct_tape_in F3. 
       exists (inr (inr (∘ (Some a))) :: inr (inr (∘ (Some e))) :: h0). rewrite <- and_assoc; split.
       * split.
         -- constructor 3.
            ++ apply F1. 
            ++ apply rewHeadTape_rem_tail; eauto. 
         -- intros. inv_valid. rewHeadTape_inv2. apply F2 in H4. inv H4. easy. 
       * clear F2 F1 H. destruct F3 as (H1 & H2 & H3). cbn in H1, H2. repeat split; cbn. 1-2: lia. inv H3. easy. 
  Qed. 

  Lemma tape_repr_stay_right rs e h p w : rs ≃t(p, w) inr (inr (p, e)) :: h -> exists h', valid rewHeadTape (inr (inr (p, e)) :: h) (inr (inr (neutral, e)) :: h') /\ (forall h0, valid rewHeadTape (inr (inr (p, e)) :: h) (inr (inr (neutral, e)) :: h0) -> h0 = h') /\ rs ≃t(neutral, w) (inr (inr (neutral, e)) :: h').  
  Proof.
    intros. destruct e. 
    - cbn in H. destruct_tape_in H. now apply tape_repr_stay_right'. 
    - cbn in H. destruct_tape_in_tidy H. exists (inr (inr (neutral, |_|)) :: E neutral w). split; [ | split]. 
      + apply E_rewrite_blank.
      + intros. apply E_rewrite_blank_unique in H0. now inv H0. 
      + repeat split; cbn; [rewrite E_length | ]; lia.
  Qed. 

  Corollary tape_repr_stay_left ls e h p w : ls ≃t(p, w) inr(inr (p, e)) :: h -> exists h', valid rewHeadTape (rev (inr (inr (p, e)) :: h)) (rev (inr (inr (neutral, e)) :: h')) /\ (forall h0, valid rewHeadTape (rev (inr (inr (p, e)) :: h)) (rev (inr (inr (neutral, e)) :: h0)) -> h0 = h') /\ ls ≃t(neutral, w) (inr (inr (neutral, e))) :: h'. 
  Proof. 
    intros. specialize (@tape_repr_stay_right ls e h p w H) as (h' & H1 & H3 & H2). 
    exists (map polarityFlipGamma h'). rewrite <- and_assoc. split. 
    - eapply tape_rewrite_symm1 in H1.
      apply tape_rewrite_symm3 in H1.
      split. 
      + cbn [rev].
        unfold polarityRev in H1. rewrite map_rev in H1. rewrite map_involution in H1. 2: apply polarityFlipGamma_involution. 
        destruct e; cbn in H1; apply H1. 
      + intros. specialize (H3 (map polarityFlipGamma h0)).
        rewrite <- involution_invert_eqn2 with (f := map polarityFlipGamma) (a := h0) (b := h'); [reflexivity | apply map_involution, polarityFlipGamma_involution | ]. 
        apply H3. eapply tape_rewrite_symm2. 
        unfold polarityRev. rewrite <- map_rev. apply tape_rewrite_symm3. 
        cbn. rewrite map_involution; [destruct e; cbn; now apply H0 | apply polarityFlipGamma_involution]. 
   - apply tape_repr_polarityFlip in H2. destruct e; cbn in H2; easy. 
  Qed. 

End tape.
