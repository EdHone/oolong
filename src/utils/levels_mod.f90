module levels_mod

    use, intrinsic :: iso_fortran_env, only : error_unit

    implicit none

    private
    public :: logger_level_is_valid, get_log_level_str, level_is_err

    integer, public, parameter :: LEVEL_ALWAYS  = 158952
    integer, public, parameter :: LEVEL_ERROR   = 89013
    integer, public, parameter :: LEVEL_WARNING = 7135
    integer, public, parameter :: LEVEL_INFO    = 219
    integer, public, parameter :: LEVEL_DEBUG   = 87
    integer, public, parameter :: LEVEL_TRACE   = 1

contains

    !> Detemines whether a log level is valid
    function logger_level_is_valid(log_level) result(l_valid)

        implicit none

        integer, intent(in) :: log_level

        logical :: l_valid

        select case(log_level)
        case(LEVEL_ERROR)
            l_valid = .true.
        case(LEVEL_WARNING)
            l_valid = .true.
        case(LEVEL_INFO)
            l_valid = .true.
        case(LEVEL_DEBUG)
            l_valid = .true.
        case(LEVEL_TRACE)
            l_valid = .true.
        case default
            l_valid = .false.
        end select

    end function logger_level_is_valid

    !> Gets string form for log level
    function get_log_level_str(log_level) result(log_level_str)

        implicit none

        integer, intent(in) :: log_level

        character(7) :: log_level_str

        select case(log_level)
        case(LEVEL_ALWAYS)
            log_level_str = "ALWAYS "
        case(LEVEL_ERROR)
            log_level_str = "ERROR  "
        case(LEVEL_WARNING)
            log_level_str = "WARNING"
        case(LEVEL_INFO)
            log_level_str = "INFO   "
        case(LEVEL_DEBUG)
            log_level_str = "DEBUG  "
        case(LEVEL_TRACE)
            log_level_str = "TRACE  "
        case default
            write(error_unit, '(A)') &
                "ERROR - oolong__levels_mod_37: Invalid choice for log level"
            stop 1
        end select

    end function get_log_level_str

    !> Returns true if log level should go to std.err
    function level_is_err(log_level) result(l_err)

        implicit none

        integer, intent(in) :: log_level

        logical :: l_err

        select case(log_level)
        case(LEVEL_ERROR)
            l_err = .true.
        case(LEVEL_WARNING)
            l_err = .true.
        case default
            l_err = .false.
        end select

    end function level_is_err

end module levels_mod