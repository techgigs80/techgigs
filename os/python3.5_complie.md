Install python 3.5.x on the system
==================================


## Download zlib source from git
+ Check the existence of zlib
```bash
ls /usr/lib/libz*
ls /usr/local/lib/libz*
```
+ Git the source
```bash
git clone https://github.com/madler/zlib.git
```
+ Install the zlib
```bash
cd ${git source folder}
./configure --prefix=/usr/local
make
make test
make install
make clean
```


## Download python 3.5.x from [link](https://www.python.org/downloads/)
```bash
cd ${PYTHON_SRC_CODE_DIR}
./configure --prefix=/usr/local --enable-optimizations
make

vi ${PYTHON_SRC_CODE_DIR}/Module/Setup
# uncomment the below line
"#zlib zlibmodule.c -I$(prefix)/include -L$(exec_prefix)/lib -lz"

make install
make clean
```
