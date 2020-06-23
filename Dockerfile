FROM debian:buster-slim as build
RUN apt-get update && apt-get install -y git cmake libmariadb-dev zlib1g-dev build-essential
RUN git clone --depth 1 --recursive https://github.com/SapphireServer/Sapphire.git
WORKDIR /Sapphire/build
ARG CHECKOUT=master
RUN git checkout ${CHECKOUT}
RUN cmake ..
RUN make -j$(nproc)

FROM debian:buster-slim
RUN apt-get update && apt-get install -y libmariadb-dev zlib1g-dev
WORKDIR /opt/sapphire/bin
COPY --from=build /Sapphire/build/bin/ ./
ENV PATH="/opt/sapphire/bin:${PATH}"
