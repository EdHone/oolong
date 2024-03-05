module colour_tests

    use testdrive,  only: new_unittest, unittest_type, error_type, check
    use colour_mod, only: change_colour, COLOUR_WHITE, COLOUR_BLUE

    implicit none

    private
    public :: collect_colour_tests

contains

    !> Collect colour unit tests
    subroutine collect_colour_tests(unit_tests)

        implicit none

        type(unittest_type), allocatable, intent(out) :: unit_tests(:)

        unit_tests = [ &
            new_unittest("change_colour", test_change_colour) &
        ]

    end subroutine collect_colour_tests

    !> Test colour changing output
    subroutine test_change_colour(error)

        implicit none

        type(error_type), allocatable, intent(out) :: error

        call check(error, len(trim(change_colour("TEST", COLOUR_WHITE))), 4)
        call check(error, len(trim(change_colour("TEST", COLOUR_BLUE))), 13)
        if (allocated(error)) return

    end subroutine test_change_colour

end module colour_tests