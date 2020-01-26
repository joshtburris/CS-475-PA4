###
### CS475 Fall 17
### Makefile for CUDA PA5 matmult
### By Wim Bohm, and Waruna Ranasinghe
###

OPTIONS := -O3 --ptxas-options -v --gpu-architecture=sm_61 --compiler-bindir /usr/local/gcc-6.4.0/bin  -std=c++11 -I/s/bach/c/under/joshtb/cuda-patches/include
EXECS := matmult00 vecMax00 matmult01 vecMax01

all: $(EXECS)
	./matmult01 100

clean:
	rm -f $(EXECS) *.o

timer.o: timer.cu timer.h
	nvcc $< -c -o $@ $(OPTIONS)

matmultKernel00.o: matmultKernel00.cu matmultKernel.h 
	nvcc $< -c -o $@ $(OPTIONS)

matmult00: matmult.cu matmultKernel.h matmultKernel00.o timer.o
	nvcc $< matmultKernel00.o -o $@ $(LIB) timer.o $(OPTIONS)

vecMaxKernel00.o: vecMaxKernel00.cu vecMaxKernel.h 
	nvcc $< -c -o $@ $(OPTIONS)

vecMax00: vecMax.cu vecMaxKernel.h vecMaxKernel00.o timer.o
	nvcc $< vecMaxKernel00.o -o $@ $(LIB) timer.o $(OPTIONS)

matmultKernel01.o: matmultKernel01.cu matmultKernel.h 
	nvcc $< -c -o $@ $(OPTIONS)

matmult01: matmult.cu matmultKernel.h matmultKernel01.o timer.o
	nvcc $< matmultKernel01.o -o $@ $(LIB) timer.o $(OPTIONS) -DFOOTPRINT_SIZE=32

vecMaxKernel01.o: vecMaxKernel01.cu vecMaxKernel.h 
	nvcc $< -c -o $@ $(OPTIONS)

vecMax01: vecMax.cu vecMaxKernel.h vecMaxKernel01.o timer.o
	nvcc $< vecMaxKernel01.o -o $@ $(LIB) timer.o $(OPTIONS)

tar: matmultKernel00.cu matmultKernel01.cu matmultKernel.h matmult.cu Makefile vecMax.cu vecMaxKernel00.cu vecMaxKernel01.cu vecMaxKernel.h report.pdf
	tar cf PA4.tar  matmultKernel00.cu matmultKernel01.cu matmultKernel.h matmult.cu Makefile vecMax.cu vecMaxKernel00.cu vecMaxKernel01.cu vecMaxKernel.h report.pdf

