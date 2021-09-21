FROM tandav/miniconda3-centos6-devtools

COPY weak_glibc214.py /usr/local/lib/python3.7/site-packages/lightgbm/
COPY libc_my.c /usr/local/lib/python3.7/site-packages/lightgbm/libc_my/
RUN python -m pip install lightgbm && \
    cd /usr/local/lib/python3.7/site-packages/lightgbm && \
    python weak_glibc214.py && \
    cd libc_my && \
    gcc -s -shared -o libc_my.so -fPIC -fno-builtin libc_my.c && \
    mv libc_my.so /usr/local/lib/python3.7

ENV LD_LIBRARY_PATH=/usr/local/lib/python3.7:$LD_LIBRARY_PATH
ENV LD_PRELOAD=/usr/local/lib/python3.7/libc_my.so
