all: CToFortran

CToFortran: cmain.o fortranVar.o
	$(CXX) -o $@ cmain.o fortranVar.o -L/opt/moose/gcc-6.2.0/lib -lgfortran

%.o : %.f90
	gfortran -c -o $@ $<
