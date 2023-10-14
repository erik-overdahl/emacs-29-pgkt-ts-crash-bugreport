FROM emacs-29-bugreport-shared:latest

WORKDIR /emacs

RUN export CFLAGS="-g" \
    && ./autogen.sh \
    && ./configure \
        --with-tree-sitter \
        --without-gif \
        --without-xpm \
    && make -j "$(nproc)" \
    && make -j "$(nproc)" install

WORKDIR /test
