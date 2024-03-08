module datetime_mod

    implicit none

    private
    public :: datetime_string

contains

    !> Gets formatted date/time information from iso_fortran_env
    !!
    !> return Character array of length 25
    function datetime_string() result(result_string)

        implicit none

        character(len=25) :: result_string
        integer :: datetime_values(8)

        call date_and_time(values = datetime_values)

        write( result_string,                                         &
            '(I4,A1,I2.2,A1,I2.2,A1,I2.2,A1,I2.2,A1,I2.2,A1,I3.3)')  &
                    datetime_values(1), "-", datetime_values(2), "-", &
                    datetime_values(3), " ", datetime_values(5), ":", &
                    datetime_values(6), ":", datetime_values(7), ".", &
                    datetime_values(8)

    end function datetime_string

end module datetime_mod