FROM rust:1-slim-buster as builder
WORKDIR /app
RUN echo $PATH
COPY . .
COPY ./src/templates ./templates/.
RUN pws
RUN ls -a
RUN cargo install --path .


FROM debian:stable-slim as runner

RUN addgroup --system --gid 1000 worker
RUN adduser --system --uid 1000 --ingroup worker --disabled-password worker
USER worker:worker

COPY --from=builder /usr/local/cargo/bin/rust /usr/local/bin/rust
RUN pws
RUN ls -a
ENV ROCKET_ADDRESS=127.0.0.0
EXPOSE 8000
CMD ["rust"]