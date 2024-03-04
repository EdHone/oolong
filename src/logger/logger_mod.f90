!> Module containing an flexible logger class
module logger_mod

    use, intrinsic :: iso_fortran_env, only : output_unit, error_unit

    use colour_mod, only: change_colour, COLOUR_WHITE, COLOUR_GREY
    use levels_mod, only: logger_level_is_valid, get_log_level_str, &
                          level_is_err, LEVEL_ERROR

    implicit none

    private

    !> Logger class
    type, public :: logger_type
        character(len=16) :: id = "None"
        integer           :: log_level
        integer           :: output_stream
        integer           :: colour_tag = COLOUR_WHITE
        logical           :: outputs_to_term
        integer           :: stop_level = LEVEL_ERROR
    contains
        procedure, public :: event
        procedure         :: format_info
        procedure         :: all_stop
    end type

    interface logger_type
        procedure :: logger_constructor
    end interface logger_type

contains

    !> Constructor for the logger object
    function logger_constructor(level, id, colour, stop_level) result(self)

        implicit none

        type(logger_type)                      :: self
        integer,                    intent(in) :: level
        character(len=*), optional, intent(in) :: id
        integer,          optional, intent(in) :: colour
        integer,          optional, intent(in) :: stop_level

        if (logger_level_is_valid(level)) then
            self%log_level = level
        else
            write(error_unit, '(A)') &
                "ERROR - oolong__logger_mod_45: Invalid choice for log_level"
            stop 1
        end if

        self%output_stream = output_unit
        self%outputs_to_term = isatty(self%output_stream)

        if (present(id)) self%id = trim(id)
        if (present(colour)) self%colour_tag = colour

        if (present(stop_level)) then
            if (logger_level_is_valid(stop_level) .and. &
                    level_is_err(stop_level)) then
                self%stop_level = stop_level
            else
                write(error_unit, '(A)') &
                    "ERROR - oolong__logger_mod_62: Invalid choice for stop_level"
                stop 1
            end if
        end if

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

        integer :: log_out

        if (self%log_level > level) return

        dt_str = datetime_string()
        info_str = self%format_info(level)

        if (self%outputs_to_term) then
            fmt_dt_str = change_colour(dt_str, COLOUR_GREY)
        else
            fmt_dt_str = dt_str
        end if

        if (level_is_err(level)) then
            log_out = error_unit
        else
            log_out = self%output_stream
        end if

        write ( log_out, '("[", A,"]" A, ": ", A)' ) &
            trim(fmt_dt_str), trim(info_str), trim(message)

        if (level >= self%stop_level) call self%all_stop()

    end subroutine event

    !> Formats information about this logger object ready for output
    !!
    !> level  Log level of the message
    !> return Character array of length 32
    function format_info(self, level) result(result_string)

        implicit none

        class(logger_type), intent(inout) :: self
        integer,            intent(in)    :: level

        character(len=32) :: result_string, fmt_tag_str

        if (trim(self%id) == "None") then
            write( result_string, '(" ", A)' ) &
                trim(get_log_level_str(level))
        else
            if (self%outputs_to_term) then
                fmt_tag_str = change_colour(trim(self%id), self%colour_tag)
            else
                fmt_tag_str = trim(self%id)
            end if
            write( result_string, '("[", A,"] ", A)' ) &
                trim(fmt_tag_str), trim(get_log_level_str(level))
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

    subroutine all_stop(self)

        implicit none

        class(logger_type), intent(inout) :: self

        stop 1

    end subroutine all_stop

end module logger_mod