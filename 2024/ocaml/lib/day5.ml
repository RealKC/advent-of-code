let parse input =
  let lines = String.split_on_char '\n' input in
  let raw_rules, raw_updates =
    List.partition
      (fun x -> String.contains x '|')
      (List.filter (fun x -> String.length x > 0) lines)
  in
  let updates =
    List.map
      (fun u -> List.map int_of_string (String.split_on_char ',' u))
      raw_updates
  in
  let rules = Hashtbl.create (List.length raw_rules) in
  let process_rule rule =
    match String.split_on_char '|' rule with
    | [ x; y ] -> Hashtbl.add rules (int_of_string x) (int_of_string y)
    | _ -> failwith ("Invalid rule line '" ^ rule ^ "'")
  in
  let () = List.iter process_rule raw_rules in
  let compare a b =
    if a == b then 0
    else
      let after_a = Hashtbl.find_all rules a in
      let a_comes_before = List.exists (( == ) b) after_a in
      if a_comes_before then -1 else 1
  in
  let sort lst = List.sort compare lst in
  (updates, sort)

let middle lst = List.nth lst (List.length lst / 2)

let solve_a input =
  let updates, sort_update = parse input in
  let correct_updates =
    List.filter (fun lst -> List.equal ( == ) lst (sort_update lst)) updates
  in
  let middles = List.map middle correct_updates in
  let result = List.fold_left ( + ) 0 middles in
  string_of_int result

let solve_b input =
  let updates, sort_update = parse input in
  let incorrect_updates =
    List.filter
      (fun lst -> not (List.equal ( == ) lst (sort_update lst)))
      updates
  in
  let corrected_updates = List.map sort_update incorrect_updates in
  let middles = List.map middle corrected_updates in
  let result = List.fold_left ( + ) 0 middles in
  string_of_int result
