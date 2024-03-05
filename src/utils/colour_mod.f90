module colour_mod

    use, intrinsic :: iso_fortran_env, only : error_unit

    implicit none

    private
    public :: change_colour

    integer, public, parameter :: COLOUR_WHITE  = 2503
    integer, public, parameter :: COLOUR_GREY   = 3858
    integer, public, parameter :: COLOUR_RED    = 8901
    integer, public, parameter :: COLOUR_BLUE   = 1876
    integer, public, parameter :: COLOUR_GREEN  = 4581
    integer, public, parameter :: COLOUR_YELLOW = 5372

contains

    !> Returns a string with formatting which will change the colour when
    !> output to the terminal
    !!
    !> param[in] input_str The input string to be formatted
    !> param[in] colour    Enum denoting colour to be changed to
    function change_colour(input_str, colour) result(result_str)

        implicit none

        character(len=*), intent(in) :: input_str
        integer,          intent(in) :: colour
        character(len=128) :: result_str

        character(len=4) :: colour_fmt

        ! If string tag is too long then colour can't be formatted - call error
        if (len(trim(input_str)) > len(result_str) - 9) then
            write(error_unit, '(A)') &
                "ERROR - oolong_colour_mod_37: Input string too long for colour change"
            stop 1
        end if

        select case(colour)
        case(COLOUR_WHITE)
            result_str = trim(input_str)
            return
        case(COLOUR_GREY)
            colour_fmt = "[90m"
        case(COLOUR_RED)
            colour_fmt = "[91m"
        case(COLOUR_GREEN)
            colour_fmt = "[92m"
        case(COLOUR_YELLOW)
            colour_fmt = "[93m"
        case(COLOUR_BLUE)
            colour_fmt = "[94m"
        case default
            write(error_unit, '(A)') &
                "ERROR - oolong_colour_mod_57: Invalid choice for colour change"
            stop 1
        end select

        result_str = achar(27)//colour_fmt//trim(input_str)//achar(27)//'[0m'

    end function change_colour

end module colour_mod