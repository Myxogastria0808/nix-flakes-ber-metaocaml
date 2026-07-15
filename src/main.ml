(* int code を受け取り、「その値を足す関数」のコードを生成する *)
let make_adder (n : int code) : (int -> int) code =
  .< fun x -> x + .~n >.

let generated_code =
  make_adder .< 2 >.

let add_two =
  Runcode.run generated_code

let () =
  Printf.printf "%d\n" (add_two 40)

