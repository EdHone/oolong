module logger_mod

    implicit none

    type, public :: logger_type
        integer :: id
    end type

    interface logger_type
        procedure :: logger_constructor
    end interface logger_type

contains

    function logger_constructor() result(self)

        implicit none

        type(logger_type) :: self

        self%id = 1

    end function logger_constructor

end module logger_mod