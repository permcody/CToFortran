all: CToFortran

GFORTRAN_LIB_FLAG := -L/opt/moose/gcc-7.2.0/lib

CToFortran: cmain.o fortranVar.o
	$(CXX) -o $@ cmain.o fortranVar.o $(GFORTRAN_LIB_FLAG) -lgfortran

%.o : %.f90
	gfortran -c -o $@ $<

%.o : %.C
	clang++ -std=c++11 -c -o $@ $<
