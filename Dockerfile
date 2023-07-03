# Using the latest version of Ubuntu as the base image
FROM ubuntu:latest

# Update the apt package index and install necessary packages
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    libboost-all-dev \
    libusb-1.0-0-dev \
    python3-docutils \
    python3-mako \
    python3-numpy \
    python3-requests \
    python3-ruamel.yaml \
    python3-setuptools \
    build-essential \
    python3-pip

# Clone the Ettus Research UHD codebase, build and install
RUN git clone https://github.com/EttusResearch/uhd.git && \
    cd uhd/host && \
    mkdir build && \
    cd build && \
    cmake -DENABLE_TESTS=OFF -DENABLE_C_API=OFF -DENABLE_MANUAL=OFF .. && \
    make -j8 && \
    make install && \
    ldconfig

# Install Jupyter Notebook
RUN pip3 install notebook

# Create a directory for your Jupyter Notebooks
RUN mkdir /notebooks

# Expose port for the Jupyter Notebook web server
EXPOSE 8888

# Start Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=*", "--port=8888", "--no-browser", "--allow-root"]
