open In_channel

let () =
  let args = Sys.argv in
  if Array.length args != 3 then
    Printf.printf "Expected 2 arguments, got %d\n" (Array.length args)
  else
    let day, part =
      (Array.get args 1, String.lowercase_ascii (Array.get args 2))
    in
    let input = input_all (open_in ("inputs/" ^ day)) in
    let out =
      match (day, part) with
      | "4", "a" -> Solutions.Day4.solve_a input
      | "4", "b" -> Solutions.Day4.solve_b input
      | _ -> Printf.sprintf "Day %s part %s was not solved in OCaml\n" day part
    in
    print_endline ("Solution was " ^ out)
