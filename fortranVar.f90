MODULE FortranVar
!
   USE iso_c_binding
   IMPLICIT NONE
!
   REAL*8 :: globalReal
   INTEGER :: globalInt
   LOGICAL :: globalLogical
   !
   REAL*8, TARGET, DIMENSION(2) :: LocalElev = (/1.0, 2.0/)

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

SUBROUTINE LoadVar () bind(C, name="loadvar")
!
   IMPLICIT NONE
!
   INTEGER :: i, j, k
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
         DO k=1,2
            FortranType(i)%num4(j,k) = i*j*3
         END DO
      END DO
   END DO
 END SUBROUTINE LoadVar

 SUBROUTINE subtest(pointr) bind(C, name="sub_test")
   TYPE(C_PTR) :: pointr
!   REAL(c_double), DIMENSION(:), POINTER :: pointr

   pointr = C_LOC(localElev)
 END SUBROUTINE

      SUBROUTINE Get1DVectorR(name, compnum, face, elements, elevation, pointr, errorCode) bind(C, name="get1dvectorr")
        INTEGER(c_int), INTENT(INOUT) :: name
        INTEGER(c_int), INTENT(IN) :: compnum
        INTEGER(c_int), INTENT(IN) :: face
        INTEGER(c_int), INTENT(OUT) :: errorCode
        TYPE(c_ptr) :: pointr, elevation
        INTEGER(c_int), INTENT(OUT) :: elements
        INTEGER :: i, cco


        PRINT *,"Name: ",name
        PRINT *,"CompNum: ",compnum
        PRINT *,"Face: ",face

        PRINT *,"Elements: ",elements
        PRINT *,"ErrorCode: ",errorCode
        PRINT *, "FortranType Values: ", FortranType(compnum)%num4(:,2)


!    name - ascii string denoting the name of the variable that
!           is sought
!    ordInd - index denoting the location within this ROD's
!             array data structure
!    found - logical variable indicating whether the variable name has
!            been found within the array data.
!            This argument is optional - if it is used, then it is left
!            to the programmer to design a suitable error trapping
!            logic.  If it is not used (recommended), then the error
!            trapping logic in this routine is used.
!    pointr - pointer to the requested array data
!
!  When the found argument is present, set it TRUE initially,
!  then to FALSE later on, if it turns out that the variable
!  name cannot be located
!
!
!       In the event that something goes wrong finding the pointer assign an
!       error code value for debugging in MOOSE.
!       Value     Description
!           0     Subroutine executed Normally
!           1     Invalid TRACE component number passed into the routine
        !           2     Invalid text string passed into the routine

        cco = 0
        errorCode =0
!        localElev = (/1.0, 2.0/)

!        DO i=1, SIZE(bisonAR)
!           IF (compNum==bisonAr(i)%traceCompNum) cco=i
!        END DO
!        IF (cco==0) then
!           errorCode = 1
!           Return
!        END if
        elevation = C_LOC(localElev)
        elements = SIZE(FortranType(compNum)%num4(:,face))
        pointr = C_LOC(FortranType(compnum)%num4(:,face))

        PRINT *,"Name: ",name
        PRINT *,"CompNum: ",compnum
        PRINT *,"Face: ",face

        PRINT *,"Elements: ",elements
        PRINT *,"ErrorCode: ",errorCode


!        SELECT CASE (name)
!        !CASE ('hrfl',1)
!          CASE (1)
!              elements = SIZE(bisonAr(cco)%hrfl(:,face))
!              pointr => bisonAr(cco)%hrfl(:,face)
!           !CASE ('hrfv',2)
!          CASE (2)
!              elements = SIZE(bisonAr(cco)%hrfv(:,face))
!              pointr => bisonAr(cco)%hrfv(:,face)
!           !CASE ('alpr',3)
!          CASE (3)
!              elements = SIZE(bisonAr(cco)%alpr(:,face))
!              pointr => bisonAr(cco)%alpr(:,face)
!           !CASE ('tlnr',4)
!          CASE (4)
!              elements = SIZE(bisonAr(cco)%tlnr(:,face))
!              pointr => bisonAr(cco)%tlnr(:,face)
!           !CASE ('tvnr',5)
!          CASE (5)
!              elements = SIZE(bisonAr(cco)%tvnr(:,face))
!              pointr => bisonAr(cco)%tvnr(:,face)
!           !CASE ('pr',6)
!           CASE (6)
!              elements = SIZE(bisonAr(cco)%pr(:,face))
!              pointr => bisonAr(cco)%pr(:,face)
!           CASE DEFAULT
!              errorCode = 2
!        END SELECT
      END SUBROUTINE


END MODULE FortranVar
