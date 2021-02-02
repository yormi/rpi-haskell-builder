FROM navikey/raspbian-buster AS ghc-setup
RUN apt update
RUN apt install -y wget xz-utils make gcc libtinfo5 llvm-9-dev
RUN wget https://downloads.haskell.org/~ghc/8.10.3/ghc-8.10.3-armv7-deb10-linux.tar.xz
RUN tar xaf ghc-8.10.3-armv7-deb10-linux.tar.xz
WORKDIR /ghc-8.10.3
RUN ./configure --prefix=/opt/ghc
RUN make install


FROM navikey/raspbian-buster AS cabal-setup
RUN apt update
RUN apt install -y make gcc libtinfo5 wget llvm-9-dev zlib1g-dev

#RUN --mount=type=cache,target=/root/.cabal \
    RUN apt install -y cabal-install

#RUN --mount=type=cache,target=/root/.cabal \
    RUN cabal update

#RUN --mount=type=cache,target=/root/.cabal \
    RUN cabal install cabal-install --constraint 'lukko -ofd-locking'



FROM navikey/raspbian-buster
RUN apt update
RUN apt install -y make gcc libtinfo5 zlib1g-dev libatomic1 libgmp-dev git llvm-9-dev
COPY --from=cabal-setup /root/.cabal/bin/cabal /usr/bin/cabal
COPY --from=ghc-setup /opt /opt
ENV PATH=/opt/ghc/bin:${PATH}

COPY build /usr/bin/build

CMD "/bin/bash"
