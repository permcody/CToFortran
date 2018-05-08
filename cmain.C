#include <iostream>

#define FORTRAN_CALL(name) name##_
#define FORTRAN_MODULE_CALL(module, name) __##module##_MOD_##name
#define FORTRAN_DREF_VAR(module, name) *__##module##_MOD_##name

extern "C" void FORTRAN_MODULE_CALL(fortranvar, loadvar)(...);

extern "C" int FORTRAN_DREF_VAR(fortranvar, globalint)(...);

int main()
{
  FORTRAN_MODULE_CALL(fortranvar, loadvar)();

  std::cout << "Hello\nGlobal Int: " << FORTRAN_DREF_VAR(fortranvar, globalint) << std::endl;

  return 0;
}
