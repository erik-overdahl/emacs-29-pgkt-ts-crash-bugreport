FROM emacs-29-bugreport-shared:latest

RUN dnf install --setopt=install_weak_deps=False -y \
    gtk3-devel

WORKDIR /emacs

RUN export CFLAGS="-g" \
    && ./autogen.sh \
    && ./configure \
        --with-tree-sitter \
        --with-pgtk \
    && make -j "$(nproc)" \
    && make -j "$(nproc)" install

WORKDIR /test
