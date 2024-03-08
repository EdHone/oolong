!> Module containing an abstract logger base class
module abstract_logger_mod

    implicit none

    private

    !> Logger class
    type, public, abstract :: abstract_logger_type
        private
    contains
        procedure(event_inter), public, deferred :: event
        procedure(format_info_inter),   deferred :: format_info
        procedure(all_stop_inter),      deferred :: all_stop
    end type

    abstract interface

        subroutine event_inter(self, message, level)
            import abstract_logger_type
            implicit none
            class(abstract_logger_type), intent(inout) :: self
            character(len=*),            intent(in)    :: message
            integer,                     intent(in)    :: level
        end subroutine event_inter

        function format_info_inter(self, level)
            import abstract_logger_type
            implicit none
            class(abstract_logger_type), intent(inout) :: self
            integer,                     intent(in)    :: level
            character(len=*) :: format_info_inter
        end function format_info_inter

        subroutine all_stop_inter(self)
            import abstract_logger_type
            implicit none
            class(abstract_logger_type), intent(inout) :: self
        end subroutine all_stop_inter

    end interface

end module abstract_logger_mod