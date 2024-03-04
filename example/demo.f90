program demo

use oolong, only: logger_type

implicit none

type(logger_type) :: log

print*, "Put some examples in here!"

log = logger_type(id = "Moon")

call log%event("Hello", 100)
call log%event("how", 100)
call log%event("are", 100)
call log%event("you", 100)
call log%event("today", 100)

end program demo
