open Base

type 'a t = {
  unvisible_left: 'a list;
  visible: 'a list;
  selected: int;
  unvisible_right: 'a list;
  split: 'a list -> 'a list * 'a list
}


let empty = {
  unvisible_left = []; visible = []; selected = 0;
  unvisible_right = []; split = (fun l -> l, [])
}
let all l = List.rev l.unvisible_left @ l.visible @ l.unvisible_right

let from_list split = function
  | [] -> { empty with split }
  | t :: q ->
    let visible, unvisible = split (t :: q) in
    { empty with
      selected = 0; split;
      visible; unvisible_right = unvisible;
    }


let page_left p =
  let visible, unvisible = p.split p.unvisible_left in
  match visible with
  | [] -> p
  | _ :: _ ->
    { p with
      unvisible_left = unvisible;
      unvisible_right = p.visible @ p.unvisible_right;
      visible = List.rev visible; selected = 0; }

let page_right p =
  let visible, unvisible = p.split p.unvisible_right in
  match visible with
  | [] -> p
  | _ :: _ ->
    { p with
      unvisible_right = unvisible;
      unvisible_left = List.rev p.visible @ p.unvisible_left;
      visible; selected = 0; }


let left p =
  if p.selected = 0 then
    if List.is_empty p.unvisible_left then p
    else
      let p' = page_left p in
      { p' with selected = List.length p'.visible - 1 }
  else
    { p with selected = p.selected - 1 }


let right p =
  if p.selected = List.length p.visible - 1 then
    page_right p
  else
    { p with selected = p.selected + 1 }

let fold_visible f state p =
  List.fold ~f:(fun (counter, state) elem ->
    (counter + 1, f state (counter = p.selected) elem))
    ~init:(0, state)
    p.visible |> snd


let selected p =
  if List.is_empty p.visible then failwith "Pagination.selected: empty list"
  else List.nth_exn p.visible p.selected

let is_empty p = List.is_empty p.visible
