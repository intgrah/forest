FROM ocaml/opam:debian-ocaml-5.3 AS builder

USER opam
WORKDIR /home/opam

RUN opam install -y forester

COPY --chown=opam:opam . /home/opam/forest
WORKDIR /home/opam/forest

RUN eval $(opam env) && forester build

FROM nginx:alpine

COPY --from=builder /home/opam/forest/output /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
