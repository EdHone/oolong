module logger_tests

    use testdrive,  only: new_unittest, unittest_type, error_type, check
    use logger_mod, only: logger_type
    use levels_mod, only: LEVEL_INFO, LEVEL_ERROR, LEVEL_TRACE
    use colour_mod, only: COLOUR_WHITE

    implicit none

    private
    public :: collect_logger_tests

contains

    !> Collect logger unit tests
    subroutine collect_logger_tests(unit_tests)

        implicit none

        type(unittest_type), allocatable, intent(out) :: unit_tests(:)

        unit_tests = [ &
            new_unittest("init_default", test_init_default), &
            new_unittest("format_info", test_format_info) &
        ]

    end subroutine collect_logger_tests

    !> Simple initialisation check for default values
    subroutine test_init_default(error)

        implicit none

        type(error_type), allocatable, intent(out) :: error
        type(logger_type) :: test_log

        test_log = logger_type(LEVEL_INFO)

        call check(error, trim(test_log%id), "None")
        call check(error, test_log%log_level, LEVEL_INFO)
        call check(error, test_log%colour_tag, COLOUR_WHITE)
        call check(error, test_log%stop_level, LEVEL_ERROR)
        if (allocated(error)) return

    end subroutine test_init_default

    !> Simple log information formatting
    subroutine test_format_info(error)

        implicit none

        type(error_type), allocatable, intent(out) :: error
        type(logger_type) :: test_log1, test_log2

        test_log1 = logger_type(LEVEL_INFO)
        test_log2 = logger_type(LEVEL_TRACE, id="Test logger 2")

        call check(error, trim(test_log1%format_info(LEVEL_TRACE)), " TRACE")
        call check(error, trim(test_log2%format_info(LEVEL_INFO)), "[Test logger 2] INFO")

        if (allocated(error)) return

    end subroutine test_format_info

end module logger_tests