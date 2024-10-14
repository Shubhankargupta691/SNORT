# Use the official Ubuntu image as the base
FROM ubuntu:latest

# Set environment variables for non-interactive apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Snort Version
ENV VERSION=2.9.20

RUN mkdir -p /root/pcaps/
COPY labs /root/
COPY tools /root/
WORKDIR /root/src/

# Update package lists and install dependencies
RUN apt update -y && \
    apt upgrade -y && \
    apt install -y \
    build-essential \
    sudo \
    net-tools \
    iproute2 \
    vim \
    nano \
    curl \
    git \
    gcc \
    flex \
    bison \
    wget \
    pkg-config \
    libpcap0.8 \
    libpcap0.8-dev \
    libpcre3 \
    libpcre3-dev \
    libdumbnet1 \
    libdumbnet-dev \
    libdaq2 \
    libdaq-dev \
    zlib1g \
    zlib1g-dev \
    liblzma5 \
    liblzma-dev \
    luajit \
    libluajit-5.1-dev \
    libssl3 \
    libssl-dev \
    libtirpc-dev \
    tcpreplay && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Download and install Snort
RUN wget https://www.snort.org/downloads/snort/snort-${VERSION}.tar.gz && \
    tar -xzf snort-${VERSION}.tar.gz && \
    cd snort-${VERSION} && \
    CPPFLAGS="-I/usr/include/tirpc" LDFLAGS="-ltirpc" ./configure --enable-sourcefire --enable-open-appid && \
    make && \
    make install && \
    ldconfig && \
    cd .. && \
    mv snort-${VERSION} /usr/local/src/snort-${VERSION} && \
    rm -rf snort-${VERSION}.tar.gz


# Add Snorty user
RUN groupadd snorty && useradd -r -s /sbin/nologin -g snorty snorty && \
    usermod -aG sudo snorty

# rule syntax file
COPY include/hog.vim /root/.vim/syntax/hog.vim
# colorscheme
COPY include/ir_black.vim /root/.vim/colors/ir_black.vim
# vimrc
COPY include/vimrc /root/.vimrc


# Create necessary directories for Snort
RUN mkdir /etc/snort /var/log/snort && \
    chown snorty:snorty /etc/snort /var/log/snort

# Create an empty local.rules file in the standard location
RUN touch /etc/snort/rules/local.rules

#copy all files from the etc directory to /etc/snort/
COPY etc/ /etc/snort/



# Set the working directory
WORKDIR /etc/snort

# Expose the ports Snort will use
EXPOSE 80/udp 443/udp 53/udp

# Run Snort (modify with your desired command)
CMD ["/bin/bash"]

