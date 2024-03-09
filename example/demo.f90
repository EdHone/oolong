program demo

use oolong, only: abstract_logger_type, logger_type, &
                  COLOUR_GREEN, &
                  LEVEL_ALWAYS, LEVEL_INFO, LEVEL_TRACE, LEVEL_WARNING, &
                  LEVEL_ERROR

implicit none

class(abstract_logger_type), allocatable :: abs_log
type(logger_type)           :: log, log1, log2

allocate(abs_log, source = logger_type(LEVEL_INFO))
call abs_log%event("Hello from abstract logger", LEVEL_INFO)

#if defined(MPI)
print*, "MPI"
#endif

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

end program demo
