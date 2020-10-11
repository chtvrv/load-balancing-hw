FROM swift:latest as builder
WORKDIR /root
COPY . .

RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get -y install wget
RUN apt-get -y install tar
RUN apt-get -y install tcl

RUN wget -O sqlite.tar.gz https://www.sqlite.org/src/tarball/sqlite.tar.gz?r=release
RUN tar -xzvf sqlite.tar.gz && cd sqlite && ./configure && make && make install

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
RUN swift build \
    --enable-test-discovery \
    -c release \
    -Xlinker -L/usr/local/lib \
    -Xlinker -lsqlite3 \
    -Xswiftc -g

FROM swift:slim
WORKDIR /run

COPY --from=builder /usr/local/lib/libsqlite* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /root/.build/release /run
COPY --from=builder /root/Resources /run/Resources
COPY --from=builder /root/Public /run/Public


ENTRYPOINT ["./Run"]
CMD ["serve", "--auto-migrate", "--env", "production", "--hostname", "0.0.0.0"]