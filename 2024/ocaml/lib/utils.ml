let int_of_bool b = if b then 1 else 0

module String = struct
  include String

  let is_empty s = length s == 0
end

module Array = struct
  include Array

  let of_string s = Array.of_seq (String.to_seq s)
  let sum x = Array.fold_left ( + ) 0 x

  let count arr e =
    let bools = Array.map (( == ) e) arr in
    sum (Array.map int_of_bool bools)
end
