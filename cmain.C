#include <iostream>
#include <limits>

#define FORTRAN_CALL(name) name##_
#define FORTRAN_MOD_CALL(module, name) __##module##_MOD_##name
#define FORTRAN_DREF_VAR(module, name) *__##module##_MOD_##name

using Real=double;

extern "C" void loadvar ();

extern "C" void get1dvectorr (int *, int *, int *,
                              int *, Real **, Real **, int *);

extern "C" int FORTRAN_DREF_VAR(fortranvar, globalint)(...);

int main()
{
  loadvar ();
  std::cout << "Hello\nGlobal Int: " << FORTRAN_DREF_VAR(fortranvar, globalint) << std::endl;


  int field_num = 1;
  int component_number = 71; //getParam<int>("component_number");
  int face = 2; //getParam<int>("face");

  int buffer_lengths = 0;
  Real * elevations = nullptr;
  Real * values = nullptr;
  int error_code = std::numeric_limits<int>::max();

  std::cout << "Buffer Lengths: " << buffer_lengths << std::endl;
  std::cout << "Elevation: " << elevations << std::endl;
  std::cout << "Values: " << values << std::endl;
  std::cout << "Error Code: " << error_code << std::endl;

  get1dvectorr (&field_num, &component_number, &face,
                                             &buffer_lengths, &elevations, &values, &error_code);

  std::cout << "Buffer Lengths: " << buffer_lengths << std::endl;
  std::cout << "Elevation: " << elevations << std::endl;
  std::cout << "Values: " << values << std::endl;
  std::cout << "Error Code: " << error_code << std::endl;

  return 0;

}
