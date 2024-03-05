module levels_tests

    use testdrive,  only: new_unittest, unittest_type, error_type, check
    use levels_mod, only: logger_level_is_valid, get_log_level_str, &
                          level_is_err, LEVEL_ALWAYS, LEVEL_ERROR, &
                          LEVEL_WARNING, LEVEL_INFO, LEVEL_TRACE, LEVEL_DEBUG

    implicit none

    private
    public :: collect_levels_tests

contains

    !> Collect colour unit tests
    subroutine collect_levels_tests(unit_tests)

        implicit none

        type(unittest_type), allocatable, intent(out) :: unit_tests(:)

        unit_tests = [ &
            new_unittest("valid_level", test_valid_level), &
            new_unittest("level_as_string", test_level_string), &
            new_unittest("level_is_err", test_level_is_err) &
        ]

    end subroutine collect_levels_tests

    !> Test valid level for logger
    subroutine test_valid_level(error)

        implicit none

        type(error_type), allocatable, intent(out) :: error

        call check(error, logger_level_is_valid(42), .false.)
        call check(error, logger_level_is_valid(LEVEL_ALWAYS), .false.)
        call check(error, logger_level_is_valid(LEVEL_ERROR), .true.)
        call check(error, logger_level_is_valid(LEVEL_WARNING), .true.)
        call check(error, logger_level_is_valid(LEVEL_INFO), .true.)
        call check(error, logger_level_is_valid(LEVEL_TRACE), .true.)
        call check(error, logger_level_is_valid(LEVEL_DEBUG), .true.)
        if (allocated(error)) return

    end subroutine test_valid_level

    !> Test level string generation
    subroutine test_level_string(error)

        implicit none

        type(error_type), allocatable, intent(out) :: error

        call check(error, trim(get_log_level_str(LEVEL_ALWAYS)), "ALWAYS")
        call check(error, trim(get_log_level_str(LEVEL_ERROR)), "ERROR")
        call check(error, trim(get_log_level_str(LEVEL_WARNING)), "WARNING")
        call check(error, trim(get_log_level_str(LEVEL_INFO)), "INFO")
        call check(error, trim(get_log_level_str(LEVEL_TRACE)), "TRACE")
        call check(error, trim(get_log_level_str(LEVEL_DEBUG)), "DEBUG")
        if (allocated(error)) return

    end subroutine test_level_string

    !> Test error level checking
    subroutine test_level_is_err(error)

        implicit none

        type(error_type), allocatable, intent(out) :: error

        call check(error, level_is_err(LEVEL_ERROR), .true.)
        call check(error, level_is_err(LEVEL_WARNING), .true.)
        call check(error, level_is_err(LEVEL_INFO), .false.)
        if (allocated(error)) return

    end subroutine test_level_is_err

end module levels_tests