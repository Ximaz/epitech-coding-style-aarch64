FROM arm64v8/fedora:40
LABEL maintainer="DURAND Malo <malo.durand@epitech.eu>"

COPY dnf.requirements.txt dnf.requirements.txt

# Copy the vera profiles from https://github.com/Epitech/banana-coding-style-checker
COPY ./vera /root/vera

ENV LANG=en_US.utf8 LANGUAGE=en_US:en LC_ALL=en_US.utf8 PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

RUN dnf -y install $(cat "dnf.requirements.txt") \
    && dnf clean all -y                          \
    && rm -f "dnf.requirements.txt"

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN python3 -m pip install --upgrade pip           \
    && python3 -m pip install -Iv libclang==16.0.6 \
    && python3 -m pip cache purge

# Install Lambdananas for Haskell coding style check
RUN cd /tmp                                                                                                                               \
    && curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | GHCUP_CURL_OPTS="-k" BOOTSTRAP_HASKELL_GHC_VERSION="9.6.5" sh

RUN cd /tmp                                                    \
    && git clone https://github.com/Epitech/lambdananas        \
    && export PATH="/root/.ghcup/bin/:/root/.cabal/bin/:$PATH" \
    && cd lambdananas                                          \
    && make                                                    \
    && mv lambdananas /usr/local/bin                           \
    && rm -rf /root/.cabal /root/.ghcup /root/.stack

# Install Banana for coding style checker

# Compile banana-vera to get vera++ coding style binary
RUN cd /tmp                                                                                                  \
    && git clone https://github.com/Epitech/banana-vera.git                                                  \
    && cd banana-vera                                                                                        \
    && cmake . -DTCL_INCLUDE_PATH=/usr/share/tcl8/8.6 -DVERA_LUA=OFF -DPANDOC=OFF -DVERA_USE_SYSTEM_BOOST=ON \
    && make -j                                                                                               \
    && make install

RUN cd /root                                                                                  \
    && echo -e "#!/bin/bash\nvera++ -p epitech -r /root/vera \$@" > /usr/local/bin/new-vera++ \
    && chmod +x /usr/local/bin/new-vera++

# Format the coding style report to get better descriptive warns/errors
COPY coding-style /usr/local/bin/

RUN chmod +x /usr/local/bin/coding-style

RUN cd /tmp            \
    && rm -rf /tmp/*   \
    && chmod 1777 /tmp

WORKDIR /usr/app

ENTRYPOINT [ "coding-style" ]
