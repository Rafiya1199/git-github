# Define function directory
ARG FUNCTION_DIR="/function"

# Download base image ubuntu 20.04
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
# Install aws-lambda-cpp build dependencies
RUN apt-get update && \
  apt-get install -y \
  tcl \
  python3.8 \
  python3-pip \
  g++ \
  make \
  cmake \
  unzip \
  libcurl4-openssl-dev

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Create function directory
RUN mkdir -p ${FUNCTION_DIR}

# Copy function code
COPY app.py ${FUNCTION_DIR}
COPY requirements.txt ${FUNCTION_DIR}
# Install the runtime interface client
RUN pip3 install \
        --target ${FUNCTION_DIR} \
        awslambdaric

RUN pip3 install -r ${FUNCTION_DIR}/requirements.txt --target ${FUNCTION_DIR}

WORKDIR ${FUNCTION_DIR}
# Command can be overwritten by providing a different command in the template directly.
ENTRYPOINT [ "python3", "-m", "awslambdaric" ]
CMD [ "app.handler" ]
        