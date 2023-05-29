FROM node:16 as stage
RUN apt-get update
RUN apt-get install -y git
RUN apt install build-essential
RUN apt-get install libgmp-dev
RUN apt-get install -y libsodium-dev
RUN apt-get install nasm
WORKDIR /app
RUN git clone https://github.com/iden3/rapidsnark.git
WORKDIR /app/rapidsnark
RUN npm install
RUN git submodule init
RUN git submodule update
RUN npx task createFieldSources
RUN npx task buildProver
FROM scratch AS export-stage
COPY --from=stage /app/rapidsnark/build .
# CMD ["npx", "task", "buildProver"];