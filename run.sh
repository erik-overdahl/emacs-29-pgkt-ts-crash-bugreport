#!/usr/bin/env bash

run_test() {
    local grammar_ref build_type print_emacs_info
    grammar_ref="$1"
    build_type="$2"

    printf '\nGRAMMAR REF: %s\nEMACS BUILD: %s\n' "$grammar_ref" "$build_type"
    docker container run --rm -it \
        --env TREE_SITTER_HCL_REF="$grammar_ref" \
        "emacs-29-bugreport-${build_type}:latest"

    if [[ "$?" -ne 0 ]]; then
        printf '\n%s\n' 'Generating backtrace'

        docker container run --rm -it \
            --env TREE_SITTER_HCL_REF="$grammar_ref" \
            --env PRINT_EMACS_INFO="false" \
            -v ./debug-out:/out:z \
            "emacs-29-bugreport-${build_type}:latest" \
            gdb -batch-silent --command=generate-backtrace.gdb \
                --args emacs --batch -L . -l minimal-reproduce.el

        printf '\n%s\n' 'Backtrace file written to ./debug-out/gdb.bt'
    fi
}

docker build -f ./non-pgtk.dockerfile -t emacs-29-bugreport-non-pgtk:latest .
docker build -f ./pgtk.dockerfile -t emacs-29-bugreport-pgtk:latest .

mkdir -p ./debug-out

run_test v1.1.0 non-pgtk
run_test v1.1.0 pgtk
run_test main non-pgtk
run_test main pgtk
