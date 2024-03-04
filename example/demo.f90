program demo

use oolong, only: logger_type

implicit none

type(logger_type) :: log, log1, log2
integer :: TEST_LEVEL = 100

log = logger_type()
log1 = logger_type(id = "Foo")
log2 = logger_type(id = "Bar")

call log%event("Hello", TEST_LEVEL)
call log1%event("Hello from Logger 1", TEST_LEVEL)
call log2%event("Hello from Logger 2", TEST_LEVEL)

end program demo
