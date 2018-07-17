#include <iostream>
#include <limits>

#define FORTRAN_CALL(name) name##_
#define FORTRAN_MOD_CALL(module, name) __##module##_MOD_##name
#define FORTRAN_DREF_VAR(module, name) *__##module##_MOD_##name

using Real=double;

extern "C" void loadvar ();

extern "C" void get1dvectorr (int *, int *, int *,
                              int *, Real **, Real **, int *);

extern "C" void string_test(const char **, int *);

extern "C" void bool_test(bool *, bool *);

extern "C" int FORTRAN_DREF_VAR(fortranvar, globalint)(...);

int main()
{
  loadvar ();
  std::cout << "Hello\nGlobal Int: " << FORTRAN_DREF_VAR(fortranvar, globalint) << std::endl;

  std::cout << "********************* Numbers Test ******************\n";
  int field_num = 1;
  int component_number = 1; //getParam<int>("component_number");
  int face = 2; //getParam<int>("face");

  int buffer_lengths = 0;
  Real * elevations = nullptr;
  Real * values = nullptr;
  int error_code = std::numeric_limits<int>::max();

  std::cout << "Buffer Lengths: " << buffer_lengths << std::endl;
  std::cout << "Elevation: " << elevations << std::endl;
  std::cout << "Values: " << values << std::endl;
  std::cout << "Error Code: " << error_code << '\n' << std::endl;

  get1dvectorr (&field_num, &component_number, &face, &buffer_lengths, &elevations, &values, &error_code);

  std::cout << "\nBuffer Lengths: " << buffer_lengths << std::endl;
  std::cout << "Elevation: " << elevations << std::endl;
  std::cout << "Values: " << values << std::endl;
  std::cout << "Error Code: " << error_code << std::endl;

  for (unsigned int i = 0; i < buffer_lengths; ++i)
    std::cout << values[i] << '\t';
  std::cout << std::endl;

  std::cout << "********************* String Test ******************\n";
  std::string foo("foobar more");
  auto c_str = foo.c_str();
  int c_len = foo.size() + 1;
  string_test(&c_str, &c_len);

  std::cout << "********************* Bool Test ******************\n";
  bool true_value = true;
  bool false_value = false;
  bool_test(&true_value, &false_value);

  return 0;

}
