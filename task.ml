open Utils
open Str

let rec walk dir : string list =
  let entries = Array.to_list (Sys.readdir dir) in
  let rec loop acc entries =
    match entries with
    | [] -> acc
    | name :: rest ->
        let path = Filename.concat dir name in
        let acc =
          if Sys.is_directory path then
            if name <> "." && name <> ".." then
              walk path @ acc  (* recurse and append *)
            else acc
          else
            path :: acc       (* add file to acc *)
        in
        loop acc rest
  in
  loop [] entries

let rec process_line (regex) (acc) (counter: int) (lines: string list) =
  begin match lines with
  | head :: tail -> 
      if Str.string_match regex head 0 then
          process_line regex ((head, counter)::acc) (counter+1) tail
      else
        process_line regex acc (counter+1) tail;
  | [] -> List.rev acc
  end

let process_file_for_todos (config: Utils.config) (lines: string list) = 
  let regex = Str.regexp_case_fold
  "[ \t]*[^ \t\\w]*\\(/\\*\\*\\*\\|/\\*\\*\\|\\*/\\*\\*\\|\\*\\|//\\|#\\|'\\|--\\|%\\|;\\|\\\"\\\"\\\"\\|'''\\) *TODO[\\-()]? *:* *"
  in
  let filtered = process_line regex [] 1 lines in
    let rec print lines = 
      match lines with
      | (head, lineno) :: tail ->
          Printf.printf "%3d. [Fname: %s] %s\n" lineno config.filename head;
          print tail
      | [] -> ()
  in print filtered

