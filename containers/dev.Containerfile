FROM alpine:latest as buildenv

ARG GOFUMPTVER=0.4.0
ARG REVIVEVER=1.2.5
ARG GOFLAGS

RUN apk add --no-cache go git
RUN mkdir -p /src
RUN git clone "https://github.com/mvdan/gofumpt" /src/gofumpt
WORKDIR /src/gofumpt
RUN git checkout v$GOFUMPTVER
RUN go build $GOFLAGS -o gofumpt
RUN git clone "https://github.com/mgechev/revive" /src/revive
WORKDIR /src/revive
RUN git checkout v$REVIVEVER
RUN go build $GOFLAGS -o revive

FROM localhost/alpine-baseline:latest

RUN apk add go gopls staticcheck make
COPY --from=buildenv /src/gofumpt/gofumpt /usr/bin/gofumpt
COPY --from=buildenv /src/revive/revive /usr/bin/revive
