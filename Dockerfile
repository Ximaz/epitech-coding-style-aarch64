FROM fedora:38
LABEL maintainer="DURAND Malo <malo.durand@epitech.eu>"

RUN dnf -y upgrade                     \
    && dnf -y install dnf-plugins-core \
    && dnf -y --refresh install        \
    --setopt=tsflags=nodocs            \
    --setopt=deltarpm=false            \
    autoconf                           \
    automake                           \
    boost                              \
    boost-devel.aarch64                \
    boost-graph                        \
    boost-math                         \
    boost-static.aarch64               \
    clang.aarch64                      \
    clang-analyzer                     \
    cmake.aarch64                      \
    curl.aarch64                       \
    elfutils-libelf-devel.aarch64      \
    gcc-c++.aarch64                    \
    gcc.aarch64                        \
    gdb.aarch64                        \
    git                                \
    glibc-devel.aarch64                \
    glibc-locale-source.aarch64        \
    glibc.aarch64                      \
    langpacks-en                       \
    libconfig                          \
    libconfig-devel                    \
    gmp-devel                          \
    llvm.aarch64                       \
    llvm-devel.aarch64                 \
    make.aarch64                       \
    meson                              \
    ninja-build                        \
    openal-soft-devel.aarch64          \
    openssl-devel                      \
    python3.aarch64                    \
    python3-devel.aarch64              \
    systemd-devel                      \
    tar.aarch64                        \
    wget.aarch64                       \
    which.aarch64                      \
    vim                                \
    # Used for Vera compilation
    tcl                                \
    # Used for Vera compilation
    tcl-devel                          \
    && dnf clean all -y

RUN python3 -m pip install --upgrade pip           \
    && python3 -m pip install -Iv libclang==16.0.6 \
    && localedef -i en_US -f UTF-8 en_US.UTF-8

# Install Lambdananas for Haskell coding style check
RUN cd /tmp                                                                    \
    && curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh \
    && /root/.ghcup/bin/ghcup install ghc 9.8.2

RUN cd /tmp                                             \
    && git clone https://github.com/Epitech/lambdananas \
    && export PATH="/root/.ghcup/bin/:$PATH"            \
    && cd lambdananas                                   \
    && make                                             \
    && mv lambdananas /usr/local/bin

# Install Banana for coding style checker

# Compile banana-vera to get vera++ coding style binary
RUN cd /tmp                                                                                                  \
    && git clone https://github.com/Epitech/banana-vera.git                                                  \
    && cd banana-vera                                                                                        \
    && cmake . -DTCL_INCLUDE_PATH=/usr/share/tcl8/8.6 -DVERA_LUA=OFF -DPANDOC=OFF -DVERA_USE_SYSTEM_BOOST=ON \
    && make -j                                                                                               \
    && make install

# Copy the vera profiles from https://github.com/Epitech/banana-coding-style-checker
COPY ./vera /root/vera

RUN cd /root                                                                                  \
    && echo -e "#!/bin/bash\nvera++ -p epitech -r /root/vera \$@" > /usr/local/bin/new-vera++ \
    && chmod +x /usr/local/bin/new-vera++

# Format the coding style report to get better descriptive warns/errors
COPY coding-style /usr/local/bin/
RUN chmod +x /usr/local/bin/coding-style

ENV LANG=en_US.utf8 LANGUAGE=en_US:en LC_ALL=en_US.utf8 PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

RUN cd /tmp            \
    && rm -rf /tmp/*   \
    && chmod 1777 /tmp

WORKDIR /usr/app

ENTRYPOINT [ "coding-style" ]
