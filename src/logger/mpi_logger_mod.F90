!> Module containing a parallel logger class with MPI integration
module mpi_logger_mod
#if defined(MPI)

    use, intrinsic :: iso_fortran_env, only : output_unit, error_unit
    use mpi, only : mpi_abort

    use abstract_logger_mod, only: abstract_logger_type
    use colour_mod,          only: change_colour, COLOUR_WHITE, COLOUR_GREY
    use datetime_mod,        only: datetime_string
    use levels_mod,          only: logger_level_is_valid, get_log_level_str, &
                                   level_is_err, LEVEL_ERROR

    implicit none

    private

    !> MPI parallel logger class
    type, public, extends(abstract_logger_type) :: mpi_logger_type
        character(len=16) :: id = "None"
        integer           :: log_level
        integer           :: output_stream
        integer           :: colour_tag = COLOUR_WHITE
        integer           :: mpi_comm
        integer           :: mpi_rank
        logical           :: outputs_to_term
        logical           :: root_rank_only
        integer           :: stop_level = LEVEL_ERROR
    contains
        procedure, public :: event
        procedure         :: format_info
        procedure         :: all_stop
    end type

    interface mpi_logger_type
        procedure :: mpi_logger_constructor
    end interface mpi_logger_type

contains

    !> Constructor for the MPI logger object
    function mpi_logger_constructor( level, mpi_comm, mpi_rank, id, colour, &
                                     stop_level, root_rank_only ) result(self)

        implicit none

        type(mpi_logger_type)                  :: self
        integer,                    intent(in) :: level
        integer,                    intent(in) :: mpi_comm
        integer,                    intent(in) :: mpi_rank
        character(len=*), optional, intent(in) :: id
        integer,          optional, intent(in) :: colour
        integer,          optional, intent(in) :: stop_level
        logical,          optional, intent(in) :: root_rank_only

        if (logger_level_is_valid(level)) then
            self%log_level = level
        else
            write(error_unit, '(A)') &
                "ERROR - oolong__logger_mod_49: Invalid choice for log_level"
            stop 1
        end if

        self%output_stream = output_unit
        self%outputs_to_term = isatty(self%output_stream)
        self%mpi_comm = mpi_comm
        self%mpi_rank = mpi_rank

        if (present(id)) self%id = trim(id)
        if (present(colour)) self%colour_tag = colour

        if (present(stop_level)) then
            if (logger_level_is_valid(stop_level) .and. &
                    level_is_err(stop_level)) then
                self%stop_level = stop_level
            else
                write(error_unit, '(A)') &
                    "ERROR - oolong__logger_mod_65: Invalid choice for stop_level"
                stop 1
            end if
        end if

        if (present(root_rank_only)) then
            self%root_rank_only = root_rank_only
        else
            self%root_rank_only = .false.
        end if

    end function mpi_logger_constructor

    !> Calls a logging event
    !!
    !> @param[in] message The message to be logged
    !> @param[in] level   The level to be logged at
    subroutine event(self, message, level)

        implicit none

        class(mpi_logger_type), intent(inout) :: self
        character(len=*),   intent(in)    :: message
        integer,            intent(in)    :: level

        character(len=25)  :: dt_str
        character(len=32)  :: info_str
        character(len=128) :: fmt_dt_str, fmt_info_str

        integer :: log_out

        if (self%log_level > level) return
        if (self%root_rank_only .and. self%mpi_rank /= 0) return

        dt_str = datetime_string()
        info_str = self%format_info(level)

        if (self%outputs_to_term) then
            fmt_dt_str = change_colour(dt_str, COLOUR_GREY)
        else
            fmt_dt_str = dt_str
        end if

        if (level_is_err(level)) then
            log_out = error_unit
        else
            log_out = self%output_stream
        end if

        write ( log_out, '("[", A,"]" A, ": ", A)' ) &
            trim(fmt_dt_str), trim(info_str), trim(message)

        if (level >= self%stop_level .and. level_is_err(level)) then
            call self%all_stop()
        end if

    end subroutine event

    !> Formats information about this logger object ready for output
    !!
    !> level  Log level of the message
    !> return Character array of length 32
    function format_info(self, level) result(result_string)

        implicit none

        class(mpi_logger_type), intent(inout) :: self
        integer,            intent(in)    :: level

        character(len=32) :: result_string, fmt_tag_str

        if (trim(self%id) == "None") then
            write( result_string, '("[P", I0, "] ", A)' ) &
                self%mpi_rank, trim(get_log_level_str(level))
        else
            if (self%outputs_to_term) then
                fmt_tag_str = change_colour(trim(self%id), self%colour_tag)
            else
                fmt_tag_str = trim(self%id)
            end if
            write( result_string, '("[P", I0, "][", A,"] ", A)' ) &
                 self%mpi_rank, trim(fmt_tag_str),trim(get_log_level_str(level))
        end if

    end function format_info

    !> An interface to halt the model if an error is called
    subroutine all_stop(self)

        implicit none

        class(mpi_logger_type), intent(inout) :: self
        integer :: ierr

        call mpi_abort(self%mpi_comm, 1, ierr)

    end subroutine all_stop

#endif
end module mpi_logger_mod