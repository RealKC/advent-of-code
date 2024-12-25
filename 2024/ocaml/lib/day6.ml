open Utils

let fmt = Printf.sprintf

type move_result = Rotated | Moved | LeftBounds | Looped [@@deriving show]

module type Room = sig
  type room

  val parse : string -> room
  val with_obstacle : room -> int -> int -> room
  val clone : room -> room
  val dimensions : room -> int * int
  val board : room -> char array array
  val move_guard : room -> move_result
  val get_cell : room -> int -> int -> char
  val visited : char
end

module Room : Room = struct
  type visited = (int * int * char, unit) Hashtbl.t
  type room = char array array * int ref * int ref * visited

  let parse input =
    let lines = String.split_on_char '\n' input in
    let lines = List.filter (fun line -> not (String.is_empty line)) lines in
    let board = Array.of_list (List.map (fun l -> Array.of_string l) lines) in
    let i, j =
      let rec find_start i =
        let lst = board.(i) in
        let opt_idx = Array.find_index (( == ) '^') lst in
        match opt_idx with Some idx -> (i, idx) | None -> find_start (i + 1)
      in
      let i, j = find_start 0 in
      (i, j)
    in
    let visited = Hashtbl.create 100 in
    Hashtbl.add visited (i, j, board.(i).(j)) ();
    (board, ref i, ref j, visited)

  let visited' = 'X'
  let visited = visited'

  let with_obstacle (board, gi, gj, _) i j =
    let board = Array.map Array.copy board in
    board.(i).(j) <- '#';
    let visited = Hashtbl.create 100 in
    (* Hashtbl.add visited (!gi, !gj, board.(!gi).(!gj)) (); *)
    (board, ref !gi, ref !gj, visited)

  let clone (board, gi, gj, visited) =
    let board = Array.map Array.copy board in
    (board, ref !gi, ref !gj, Hashtbl.copy visited)

  let dimensions' board = (Array.length board, Array.length board.(0))
  let dimensions (board, _, _, _) = dimensions' board
  let board (board, _, _, _) = board

  let get_cell' board i j =
    try board.(i).(j)
    with Invalid_argument _ ->
      let msg = fmt "Invalid board positions %d, %d" i j in
      raise (Invalid_argument msg)

  let get_cell (board, _, _, _) i j = get_cell' board i j

  let move_guard (board, guard_i, guard_j, visited) =
    let get i j = get_cell' board i j in

    let rotate ch =
      match ch with
      | '^' -> '>'
      | '>' -> 'v'
      | 'v' -> '<'
      | '<' -> '^'
      | _ -> failwith (fmt "Invalid guard represenation '%c'" ch)
    in

    let in_bounds i j =
      let height, width = dimensions' board in
      (0 <= i && i < height) && 0 <= j && j < width
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

    match next_pos guard_i guard_j with
    | Some (i, j) ->
        if get i j == '#' then
          let () =
            board.(!guard_i).(!guard_j) <- rotate (get !guard_i !guard_j)
          in
          Rotated
        else
          let guard = get !guard_i !guard_j in
          board.(!guard_i).(!guard_j) <- visited';
          board.(i).(j) <- guard;
          guard_i := i;
          guard_j := j;
          Hashtbl.add visited (i, j, guard) ();
          let count = List.length (Hashtbl.find_all visited (i, j, guard)) in
          if count > 1 then Looped else Moved
    | None ->
        board.(!guard_i).(!guard_j) <- visited';
        LeftBounds
end

let count_matrix mat ch = Array.sum (Array.map (fun l -> Array.count l ch) mat)

let solve_a input =
  let room = Room.parse input in
  let finished = ref false in
  while not !finished do
    let move_result = Room.move_guard room in
    if move_result == LeftBounds then finished := true
  done;
  let board = Room.board room in
  let result = count_matrix board Room.visited in
  string_of_int (result + 1)

let solve_b input =
  let room = Room.parse input in
  let template = Room.clone room in
  let height, width = Room.dimensions room in
  let finished = ref false in
  while not !finished do
    let move_result = Room.move_guard room in
    if move_result == LeftBounds then finished := true
  done;
  let i = ref 0 in
  let result = ref 0 in
  while !i < height do
    let j = ref 0 in
    while !j < width do
      let cell = Room.get_cell room !i !j in
      let is_start = Room.get_cell template !i !j == '^' in
      (if cell != Room.visited || is_start then ()
       else
         let room = Room.with_obstacle template !i !j in
         let finished = ref false in
         while not !finished do
           let move_result = Room.move_guard room in
           if move_result == LeftBounds then finished := true
           else if move_result == Looped then (
             finished := true;
             result := !result + 1)
         done);
      j := !j + 1
    done;
    i := !i + 1
  done;
  string_of_int !result
