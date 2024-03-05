program unit_tests

    use, intrinsic :: iso_fortran_env, only: error_unit

    use testdrive,    only: run_testsuite, new_testsuite, testsuite_type
    use logger_tests, only: collect_logger_tests
    use colour_tests, only: collect_colour_tests
    use levels_tests, only: collect_levels_tests

    implicit none

    type(testsuite_type), allocatable :: test_suites(:)
    integer :: stat, i
    character(len=*), parameter :: fmt = '("#", *(1x, a))'

    stat = 0

    test_suites = [ &
        new_testsuite("logger_tests", collect_logger_tests), &
        new_testsuite("colour_tests", collect_colour_tests), &
        new_testsuite("levels_tests", collect_levels_tests) &
        ]

    do i = 1, size(test_suites)
        write(error_unit, fmt) "Testing:", test_suites(i)%name
        call run_testsuite(test_suites(i)%collect, error_unit, stat)
    end do

    if (stat > 0) then
        write(error_unit, '(i0, 1x, a)') stat, "test(s) failed!"
        error stop
    end if

end program unit_tests
