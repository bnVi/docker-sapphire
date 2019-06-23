FROM archlinux/base as build
RUN pacman -Sy --noconfirm --needed git base-devel cmake boost-libs libmariadbclient
RUN git clone --recursive https://github.com/SapphireServer/Sapphire.git
WORKDIR Sapphire/build
ARG CHECKOUT=master
RUN git checkout ${CHECKOUT}
RUN cmake ..
RUN make -j$(nproc)

FROM archlinux/base
RUN pacman -Sy --noconfirm gcc libmariadbclient
WORKDIR /opt/sapphire/bin
COPY --from=build /Sapphire/build/bin/ ./
ENV PATH="/opt/sapphire/bin:${PATH}"