let parse input =
  let lines = String.split_on_char '\n' input in
  let to_array s = Array.init (String.length s) (fun idx -> String.get s idx) in
  let parsed =
    Array.init (List.length lines) (fun idx -> to_array (List.nth lines idx))
  in
  let at i j pred =
    if i >= Array.length parsed || i < 0 then false
    else
      let line = parsed.(i) in
      if j >= Array.length line || j < 0 then false else pred line.(j)
  in
  (parsed, at)

let eq = ( == )

let solve_a input =
  let parsed, at = parse input in
  let total = ref 0 in
  let i = ref 0 in
  while !i < Array.length parsed do
    let j = ref 0 in
    while !j < Array.length (Array.get parsed !i) do
      let line_right =
        at !i !j (eq 'X')
        && at !i (!j + 1) (eq 'M')
        && at !i (!j + 2) (eq 'A')
        && at !i (!j + 3) (eq 'S')
      in
      let line_left =
        at !i !j (eq 'X')
        && at !i (!j - 1) (eq 'M')
        && at !i (!j - 2) (eq 'A')
        && at !i (!j - 3) (eq 'S')
      in
      let line_up =
        at !i !j (eq 'X')
        && at (!i - 1) !j (eq 'M')
        && at (!i - 2) !j (eq 'A')
        && at (!i - 3) !j (eq 'S')
      in
      let line_down =
        at !i !j (eq 'X')
        && at (!i + 1) !j (eq 'M')
        && at (!i + 2) !j (eq 'A')
        && at (!i + 3) !j (eq 'S')
      in
      let up_left =
        at !i !j (eq 'X')
        && at (!i - 1) (!j - 1) (eq 'M')
        && at (!i - 2) (!j - 2) (eq 'A')
        && at (!i - 3) (!j - 3) (eq 'S')
      in
      let up_right =
        at !i !j (eq 'X')
        && at (!i - 1) (!j + 1) (eq 'M')
        && at (!i - 2) (!j + 2) (eq 'A')
        && at (!i - 3) (!j + 3) (eq 'S')
      in
      let down_left =
        at !i !j (eq 'X')
        && at (!i + 1) (!j - 1) (eq 'M')
        && at (!i + 2) (!j - 2) (eq 'A')
        && at (!i + 3) (!j - 3) (eq 'S')
      in
      let down_right =
        at !i !j (eq 'X')
        && at (!i + 1) (!j + 1) (eq 'M')
        && at (!i + 2) (!j + 2) (eq 'A')
        && at (!i + 3) (!j + 3) (eq 'S')
      in
      let conds =
        [
          line_right;
          line_left;
          line_up;
          line_down;
          up_left;
          up_right;
          down_left;
          down_right;
        ]
      in
      let count =
        let int_of_bool b = if b then 1 else 0 in
        List.fold_left (fun e acc -> e + acc) 0 (List.map int_of_bool conds)
      in
      total := !total + count;
      j := !j + 1
    done;
    i := !i + 1
  done;
  string_of_int !total

let solve_b input =
  let parsed, at = parse input in
  let total = ref 0 in
  let i = ref 0 in
  while !i < Array.length parsed do
    let j = ref 0 in
    while !j < Array.length (Array.get parsed !i) do
      if at !i !j (eq 'A') then
        let main_diagonal ch1 ch2 =
          at (!i - 1) (!j - 1) (eq ch1) && at (!i + 1) (!j + 1) (eq ch2)
        in
        let anti_diagonal ch1 ch2 =
          at (!i - 1) (!j + 1) (eq ch1) && at (!i + 1) (!j - 1) (eq ch2)
        in
        let msms = main_diagonal 'M' 'S' && anti_diagonal 'S' 'M' in
        let ssmm = main_diagonal 'S' 'M' && anti_diagonal 'S' 'M' in
        let smsm = main_diagonal 'S' 'M' && anti_diagonal 'M' 'S' in
        let mmss = main_diagonal 'M' 'S' && anti_diagonal 'M' 'S' in
        if msms || ssmm || smsm || mmss then total := !total + 1 else ()
      else ();
      j := !j + 1
    done;
    i := !i + 1
  done;
  string_of_int !total
