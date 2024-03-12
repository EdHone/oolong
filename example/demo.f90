program demo

use oolong, only: abstract_logger_type, logger_type, &
                  COLOUR_GREEN, &
                  LEVEL_ALWAYS, LEVEL_INFO, LEVEL_TRACE, LEVEL_WARNING, &
                  LEVEL_ERROR

implicit none

#if defined(MPI)
call mpi_log_demo()
#endif

call serial_log_demo()

contains

subroutine serial_log_demo()

    implicit none

    class(abstract_logger_type), allocatable :: abs_log
    type(logger_type)           :: log, log1, log2

    allocate(abs_log, source = logger_type(LEVEL_INFO))
    call abs_log%event("Hello from abstract logger", LEVEL_INFO)

    log = logger_type(LEVEL_INFO)
    log1 = logger_type(LEVEL_INFO, id = "Foo")
    log2 = logger_type(LEVEL_TRACE, id = "Bar", colour=COLOUR_GREEN)

    call log%event("Hello", LEVEL_INFO)
    call log1%event("Hello from logger 1", LEVEL_INFO)
    call log1%event("Testing trace level from logger 1", LEVEL_TRACE)
    call log2%event("Hello from logger 2", LEVEL_INFO)
    call log2%event("Testing trace level from logger 2", LEVEL_TRACE)

    call log%event("Test warning", LEVEL_WARNING)
    call log%event("Test error", LEVEL_ERROR)

end subroutine serial_log_demo


#if defined(MPI)
subroutine mpi_log_demo()
    use oolong, only: mpi_logger_type
    use mpi, only: mpi_init, mpi_finalize, mpi_comm_world, mpi_comm_size, &
                   mpi_comm_rank

    implicit none

    type(mpi_logger_type) :: mpi_log1, mpi_log2
    integer :: ierr, comm_size, comm_rank

    call mpi_init(ierr)
    call mpi_comm_rank(mpi_comm_world, comm_rank, ierr)

    mpi_log1 = mpi_logger_type(LEVEL_INFO, mpi_comm_world, comm_rank)
    call mpi_log1%event("Hello from logger 1", LEVEL_INFO)

    mpi_log2 = mpi_logger_type( LEVEL_INFO, mpi_comm_world, comm_rank, &
                                id="Log 2", colour=COLOUR_GREEN )
    call mpi_log2%event("Hello from logger 2", LEVEL_INFO)

    call mpi_log1%event("TEST ERROR", LEVEL_ERROR)

    call mpi_finalize(ierr)

end subroutine mpi_log_demo
#endif

end program demo
