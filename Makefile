all: CToFortran

# Note: If this path is incorrect, just export the right one in your environment. e.g.:
# export GFORTRAN_LIB_FLAG=/real/path/to/libgfortran.dylib or .a
GFORTRAN_LIB_FLAG ?= -L/opt/moose/gcc-7.2.0/lib

CToFortran: cmain.o fortranVar.o
	$(CXX) -o $@ cmain.o fortranVar.o $(GFORTRAN_LIB_FLAG) -lgfortran

%.o : %.f90
	gfortran -c -o $@ $<

%.o : %.C
	$(CXX) -std=c++11 -c -o $@ $<
