open Utils

let fmt = Printf.sprintf

let solve_a input =
  let board =
    let lines = String.split_on_char '\n' input in
    let lines = List.filter (fun line -> not (String.is_empty line)) lines in
    Array.of_list (List.map (fun l -> Array.of_string l) lines)
  in
  let guard_i, guard_j =
    let rec find_start i =
      let lst = board.(i) in
      let opt_idx = Array.find_index (( == ) '^') lst in
      match opt_idx with Some idx -> (i, idx) | None -> find_start (i + 1)
    in
    let i, j = find_start 0 in
    (ref i, ref j)
  in
  let rotate ch =
    match ch with
    | '^' -> '>'
    | '>' -> 'v'
    | 'v' -> '<'
    | '<' -> '^'
    | _ -> failwith (fmt "Invalid guard represenation '%c'" ch)
  in
  let get i j =
    try board.(i).(j)
    with Invalid_argument _ ->
      let msg = fmt "Invalid board positions %d, %d" i j in
      raise (Invalid_argument msg)
  in
  let in_bounds i j =
    (0 <= i && i < Array.length board) && 0 <= j && j < Array.length board.(0)
  in
  let next_pos i j =
    let fail guard =
      let msg =
        fmt "Invalid guard representation '%c' at (%d, %d)" guard !i !j
      in
      failwith msg
    in
    let guard = get !i !j in
    let i, j =
      match guard with
      | '^' -> (!i - 1, !j)
      | '>' -> (!i, !j + 1)
      | 'v' -> (!i + 1, !j)
      | '<' -> (!i, !j - 1)
      | _ -> fail guard
    in
    if in_bounds i j then Some (i, j) else None
  in
  let finished = ref false in
  while not !finished do
    match next_pos guard_i guard_j with
    | Some (i, j) ->
        if get i j == '#' then
          board.(!guard_i).(!guard_j) <- rotate (get !guard_i !guard_j)
        else
          let guard = get !guard_i !guard_j in
          board.(!guard_i).(!guard_j) <- 'X';
          board.(i).(j) <- guard;
          guard_i := i;
          guard_j := j
    | None -> finished := true
  done;
  let result = Array.sum (Array.map (fun l -> Array.count l 'X') board) in
  string_of_int (result + 1)

let solve_b _ = assert false
