FROM fedora:38

RUN dnf install --setopt=install_weak_deps=False -y \
    git \
    autoconf \
    make \
    gcc \
    g++ \
    texinfo \
    gnutls-devel \
    ncurses-devel \
    gdb \
    libtree-sitter-devel-0.20.8

RUN git clone --depth=1 --branch=emacs-29 --recurse-submodules https://github.com/emacs-mirror/emacs.git

WORKDIR /emacs

RUN export CFLAGS="-g" \
    && ./autogen.sh \
    && ./configure \
        --with-tree-sitter \
        --without-gif \
        --without-xpm \
    && make -j "$(nproc)" \
    && make -j "$(nproc)" install

COPY test-files /test

WORKDIR /test

ENV TREE_SITTER_HCL_REF="main"

CMD ["sh", "-c", "emacs --batch -L . -l minimal-reproduce.el 2>&1"]
