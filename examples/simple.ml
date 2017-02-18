let printf = Printf.printf

let () =
    let vw = Vw.initialize "-f the_model.vw" in
    let ex = Vw.read_example vw "1 | 1:1.0 2:0.0" in
    let label = Vw.get_label ex in
    for i = 0 to 100 do
        let learn_res = Vw.learn vw ex in
        printf "learn: %f\n" learn_res;
    done;
    printf "done label: %f\n" label;
    ()
