(* we shall implement ULC in OCaml with De Bruijn's approach to manage variables *)

type term =
  | Var of int
  | Abs of term
  | App of term * term 
  
let rec shift d c = function 
  | Var (k) -> if k < c then Var k else Var (k + d) 
  | Abs (t1) -> Abs (shift d (c+1) t1) 
  | App (t1,t2) -> App (shift d c t1, shift d c t2) 
  
(* wrapper to initialize the cutoff at 0, hence ease the term shifting *)
let term_shift d t = shift d 0 t 

(* substitution lying on shifting *)
let rec substitution j s = function 
  | Var (k) -> if k = j then s else Var k 
  | App (t1,t2) -> App (substitution j s t1, substitution j s t2)
  | Abs (t1) -> Abs(substitution (j+1) (term_shift 1 s) t1)

(* only abstraction are values *)
let is_a_value = function | Abs (t1) -> true | _ -> false 
exception NotaValue

(* beta reduction lying on down shift, with a call by value approach *)
let rec b_step t v = if is_a_value v then 
    term_shift (-1) (substitution 0 (term_shift 1 v) t)
  else raise NotaValue   

exception NoRuleApplies
let rec eval_one_step = function  
  | App (Abs t1, v1) when is_a_value v1 -> b_step t1 v1 
  | App (t1,t2) when not (is_a_value t1) -> App (eval_one_step t1,t2)
  | App (v1,t2) when is_a_value v1 -> App (v1, eval_one_step t2)
  | _ -> raise NoRuleApplies 

let rec eval_multi_step t = try eval_multi_step (eval_one_step t) with | NoRuleApplies -> t 

let rec big_step = function
  | Abs t1 ->
      Abs t1
  | App (t1, t2) ->
      let v1 = big_step t1 in
      let v2 = big_step t2 in
      (match v1 with
       | Abs t12 -> big_step (b_step t12 v2)
       | _ -> raise NoRuleApplies)
  | Var _ -> raise NoRuleApplies


