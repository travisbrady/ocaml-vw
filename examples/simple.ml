let printf = Printf.printf

let () =
    let vw = Vw.initialize "--invert_hash the_model.vw" in
    printf "VW!!\n%!";
    let examples = Array.map (fun x -> Vw.read_example vw x) 
        [|"0 | price:.23 sqft:.25 age:.05 2006"; "1 | price:.33 sqft:.35 age:.02 2006"|] in
    let label = Vw.get_label (examples.(0)) in
    printf "GOT label: %f!!!\n" label;
    for i = 0 to 100 do
     (*
     let _ex = if i mod 2 = 1 then ex else ex2 in
*)
    let _ = Vw.learn vw examples.(i mod 2) in
        ()
    done;
    Array.iter (fun ex -> Vw.finish_example vw ex) examples;
    Vw.finish vw;
    ()
