!> Module containing an flexible logger class
module logger_mod

    use, intrinsic :: iso_fortran_env, only : output_unit, error_unit

    use colour_mod, only: change_colour, COLOUR_WHITE, COLOUR_GREY

    implicit none

    private

    !> Logger class
    type, public :: logger_type
        character(len=16) :: id = "None"
        integer           :: log_level
        integer           :: output_stream
        integer           :: colour_tag = COLOUR_WHITE
        logical           :: outputs_to_term
    contains
        procedure, public :: event
        procedure         :: format_info
    end type

    interface logger_type
        procedure :: logger_constructor
    end interface logger_type

contains

    !> Constructor for the logger object
    function logger_constructor(id, colour) result(self)

        implicit none

        type(logger_type) :: self
        character(len=*), optional, intent(in) :: id
        integer,          optional, intent(in) :: colour

        self%log_level = 100
        self%output_stream = output_unit
        self%outputs_to_term = isatty(self%output_stream)

        if (present(id)) self%id = trim(id)
        if (present(colour)) self%colour_tag = colour

    end function logger_constructor

    !> Calls a logging event
    !!
    !> param[in] message The message to be logged
    !> param[in] level   The level to be logged at
    subroutine event(self, message, level)

        implicit none

        class(logger_type), intent(inout) :: self
        character(len=*),   intent(in)    :: message
        integer,            intent(in)    :: level

        character(len=25)  :: dt_str
        character(len=32)  :: info_str
        character(len=128) :: fmt_dt_str, fmt_info_str

        dt_str = datetime_string()
        info_str = self%format_info()

        if (self%outputs_to_term) then
            fmt_dt_str = change_colour(dt_str, COLOUR_GREY)
        else
            fmt_dt_str = dt_str
        end if

        write ( self%output_stream, '("[", A,"]" A, ": ", A)' ) &
            trim(fmt_dt_str), trim(info_str), trim(message)

    end subroutine event

    !> Formats information about this logger object ready for output
    !!
    !> return Character array of length 32
    function format_info(self) result(result_string)

        implicit none

        class(logger_type), intent(inout) :: self

        character(len=32) :: result_string, fmt_tag_str

        if (trim(self%id) == "None") then
            write( result_string, '(" ", A)' ) "TEST"
        else
            if (self%outputs_to_term) then
                fmt_tag_str = change_colour(trim(self%id), self%colour_tag)
            else
                fmt_tag_str = trim(self%id)
            end if
            write( result_string, '("[", A,"] ", A)' ) trim(fmt_tag_str), "TEST"
        end if

    end function format_info

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

end module logger_mod