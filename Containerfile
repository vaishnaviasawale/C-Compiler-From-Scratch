FROM fedora:latest

RUN dnf -y update && \
    dnf -y install \
        gcc \
        make \
        binutils \
        glibc-devel \
        git \
        gdb \
        vim \
        less \
        file \
        which \
        diffutils \
        && \
    dnf clean all
