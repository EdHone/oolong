module oolong

    use abstract_logger_mod, only: abstract_logger_type
    use logger_mod,          only: logger_type
#if defined(MPI)
    use mpi_logger_mod,      only: mpi_logger_type
#endif
    use colour_mod,          only: COLOUR_WHITE, COLOUR_GREY, COLOUR_RED, &
                                    COLOUR_BLUE, COLOUR_GREEN, COLOUR_YELLOW
    use levels_mod,          only: LEVEL_ALWAYS, LEVEL_ERROR, LEVEL_WARNING, &
                                    LEVEL_INFO, LEVEL_DEBUG, LEVEL_TRACE

    implicit none
    private

    public :: abstract_logger_type
    public :: logger_type
    public :: COLOUR_WHITE, COLOUR_GREY, COLOUR_RED, COLOUR_BLUE, &
              COLOUR_GREEN, COLOUR_YELLOW
    public :: LEVEL_ALWAYS, LEVEL_ERROR, LEVEL_WARNING, LEVEL_INFO, &
              LEVEL_DEBUG, LEVEL_TRACE
#if defined(MPI)
    public :: mpi_logger_type
#endif

end module oolong
