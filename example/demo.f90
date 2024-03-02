program demo

use oolong, only: logger_type

implicit none

type(logger_type) :: log

print*, "Put some examples in here!"

log = logger_type()
print*, log%id

end program demo
