module logger_mod

    use, intrinsic :: iso_fortran_env, only : output_unit, error_unit

    implicit none

    private

    type, public :: logger_type
        character(len=16) :: id = "None"
        integer           :: log_level
        integer           :: output_stream
    contains
        procedure, public :: event
        procedure         :: format_info
    end type

    interface logger_type
        procedure :: logger_constructor
    end interface logger_type

contains

    function logger_constructor(id) result(self)

        implicit none

        type(logger_type) :: self
        character(len=*), optional, intent(in) :: id

        self%log_level = 100
        self%output_stream = output_unit

        if (present(id)) self%id = trim(id)

    end function logger_constructor

    subroutine event(self, message, level)

        implicit none

        class(logger_type), intent(inout) :: self
        character(len=*),   intent(in)    :: message
        integer,            intent(in)    :: level

        character(len=25) :: dt_str
        character(len=32) :: info_str

        dt_str = datetime_string()
        info_str = self%format_info()

        write ( self%output_stream, '("[", A,"] | " A, ": ", A)' ) &
            trim(dt_str), trim(info_str), trim(message)

    end subroutine event

    function format_info(self) result(result_string)

        implicit none

        class(logger_type), intent(inout) :: self

        character(len=32) :: result_string

        if (trim(self%id) == "None") then
            write( result_string, '(A)' ) "TEST"
        else
            write( result_string, '(A, " | ", A)' ) trim(self%id), "TEST"
        end if

    end function format_info

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

end module logger_mod