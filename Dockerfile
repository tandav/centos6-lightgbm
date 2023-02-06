FROM conda/miniconda3-centos6

# https://www.getpagespeed.com/server-setup/how-to-fix-yum-after-centos-6-went-eol
COPY CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo

RUN yum -y update && yum -y groupinstall "Development Tools"

COPY requirements.txt /
COPY weak_glibc214.py /usr/local/lib/python3.7/site-packages/lightgbm/
COPY libc_my.c /usr/local/lib/python3.7/site-packages/lightgbm/libc_my/

RUN python -m pip install -r requirements.txt && \
    cd /usr/local/lib/python3.7/site-packages/lightgbm && \
    python weak_glibc214.py && \
    cd libc_my && \
    gcc -s -shared -o libc_my.so -fPIC -fno-builtin libc_my.c && \
    mv libc_my.so /usr/local/lib/python3.7

ENV LD_LIBRARY_PATH=/usr/local/lib/python3.7:$LD_LIBRARY_PATH
ENV LD_PRELOAD=/usr/local/lib/python3.7/libc_my.so
