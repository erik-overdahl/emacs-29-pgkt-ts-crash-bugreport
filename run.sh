#!/usr/bin/env sh

set -euo pipefail

docker build -f ./shared.dockerfile -t emacs-29-bugreport-shared:latest .
docker build -f ./non-pgtk.dockerfile -t emacs-29-bugreport-non-pgtk:latest .
docker build -f ./pgtk.dockerfile -t emacs-29-bugreport-pgtk:latest .

echo "Using grammar at v1.1.0 with non-pgtk. This should succeed."
docker container run --rm -it \
    --env TREE_SITTER_HCL_REF="v1.1.0" \
    emacs-29-bugreport-non-pgtk:latest

echo "Using grammar at v1.1.0 with pgtk. This should succeed."
docker container run --rm -it \
    --env TREE_SITTER_HCL_REF="v1.1.0" \
    emacs-29-bugreport-pgtk:latest

echo "Using grammar at main with non-pgtk. This should succeed."
docker container run --rm -it \
    --env TREE_SITTER_HCL_REF="main" \
    emacs-29-bugreport-non-pgtk:latest

echo "Using grammar at main with pgtk. This should FAIL."
docker container run --rm -it \
    --env TREE_SITTER_HCL_REF="main" \
    emacs-29-bugreport-pgtk:latest
