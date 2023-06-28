# FROM rust:1-slim-buster as builder
# WORKDIR /app
# RUN echo $PATH
# COPY . .
# # COPY ./src/templates ./templates/.
# RUN ls -al
# RUN pwd
# RUN cargo install --path .


# FROM debian:stable-slim as runner

# RUN addgroup --system --gid 1000 worker
# RUN adduser --system --uid 1000 --ingroup worker --disabled-password worker
# USER worker:worker

# COPY --from=builder /usr/local/cargo/bin/rust /usr/local/bin/rust
# RUN ls -al
# RUN pwd
# ENV ROCKET_ADDRESS=127.0.0.0
# EXPOSE 8000
# RUN cd usr
# RUN pwd
# RUN ls -al
# RUN pwd
# CMD ["rust"]

# FROM rust:1.70 as builder
FROM rust:1-slim-buster as builder

RUN USER=root

RUN mkdir rocket-docker-test
WORKDIR /rocket-docker-test
ADD . ./
RUN pwd
RUN ls -al
RUN cargo clean && cargo build --release

FROM debian:bullseye
ARG APP=/user/src/app
RUN mkdir -p {$APP}

RUN pwd
RUN ls -al

# Copy the compiled binaries into the new container.
COPY --from=builder /rocket-docker-test/target/release/rocket-docker-test ${APP}/rocket-docker-test
COPY --from=builder /rocket-docker-test/Rocket.toml ${APP}/Rocket.toml

WORKDIR ${APP}

EXPOSE 8000

CMD ["./rocket-docker-test"]