all: CToFortran

# Note: If this path is incorrect, just export the right one in your environment. e.g.:
# export GFORTRAN_LIB_FLAG=/real/path/to/libgfortran.dylib or .a
GFORTRAN_LIB_FLAG ?= -L/opt/moose/gcc-7.2.0/lib

LIBMESH_DIR ?= $(HOME)/projects/moose/libmesh
LIBTOOL ?= $(LIBMESH_DIR)/contrib/bin/libtool
FC := $(shell which gfortran)

# Set this to true or false
DYNAMIC := false

lib_suffix := la
ifeq ($(DYNAMIC),true)
	lib_suffix := dylib
endif

# Libraries
libFortran.$(lib_suffix) : fortranVar.lo
	$(LIBTOOL) --mode=link --tag=CXX $(CXX) -rpath $(CURDIR) -o $@ $< $(GFORTRAN_LIB_FLAG) -lgfortran
	$(LIBTOOL) --mode=install install -c $@ $(CURDIR)

libC.$(lib_suffix) : cmain.lo libFortran.$(lib_suffix)
	$(LIBTOOL) --mode=link --tag=CXX $(CXX) -rpath $(CURDIR) -o $@ $< libFortran.$(lib_suffix)
	$(LIBTOOL) --mode=install install -c $@ $(CURDIR)

# Executable
CToFortran: libC.$(lib_suffix) libFortran.$(lib_suffix)
	@$(LIBTOOL) --mode=link --tag=CXX $(CXX) -o $@ libC.$(lib_suffix) libFortran.$(lib_suffix)

%.lo:%.f90
	@$(LIBTOOL) --mode=compile --tag=FC $(FC) -c -o $@ $<

%.lo:%.C
	@$(LIBTOOL) --mode=compile --tag=CXX $(CXX) -std=c++11 -c -o $@ $<


.PHONY: clean
clean:
	rm -f *.mod *.o *.lo *.la *.dylib
	rm -rf .libs
