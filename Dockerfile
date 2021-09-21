FROM tandav/miniconda3-centos6-devtools

RUN python -m pip install lightgbm && \
    cd /usr/local/lib/python3.7/site-packages/lightgbm && \
    python weak_glibc214.py && \
    mkdir libc_my && cd libc_my

COPY libc_my.c /usr/local/lib/python3.7/site-packages/lightgbm/libc_my/
RUN gcc -s -shared -o libc_my.so -fPIC -fno-builtin libc_my.c && \
    mv libc_my.so /usr/local/lib/python3.7/lib

