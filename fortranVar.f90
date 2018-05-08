MODULE FortranVar
   IMPLICIT NONE
!
   REAL*8 :: globalReal
   INTEGER :: globalInt
   LOGICAL :: globalLogical
!
   TYPE ComplexType
      INTEGER :: num1
      REAL*8 :: num2
      REAL*8, ALLOCATABLE,  DIMENSION(:) :: num3
      REAL*8, ALLOCATABLE, DIMENSION(:,:) :: num4
   END TYPE
!
   TYPE(ComplexType), ALLOCATABLE, TARGET, DIMENSION(:) :: FortranType
!
   CONTAINS

SUBROUTINE LoadVar
!
   IMPLICIT NONE
!
   INTEGER :: i, j
!
   globalReal = 1.0
   globalInt= 2
   globalLogical = .FALSE.
   ALLOCATE(FortranType(2))
   DO i=1,2
      FortranType(i)%num1=42
      FortranType(i)%num2=37.3;
      ALLOCATE(FortranType(i)%num3(2))
      ALLOCATE(FortranType(i)%num4(2,2))
   END DO
!
   DO i=1,2
      FortranType(i)%num3(i) = i*2.0d0
      DO j=1,2
         FortranType(i)%num4(i,j) = i*j*3
      END DO
   END DO
END SUBROUTINE LoadVar

END MODULE FortranVar
