module oolong

  use logger_mod, only: logger_type
  use colour_mod, only: COLOUR_WHITE, COLOUR_GREY, COLOUR_RED, COLOUR_BLUE, &
                        COLOUR_GREEN, COLOUR_YELLOW
  use levels_mod, only: LEVEL_ALWAYS, LEVEL_ERROR, LEVEL_WARNING, LEVEL_INFO, &
                        LEVEL_DEBUG, LEVEL_TRACE

  implicit none
  private

  public :: logger_type
  public :: COLOUR_WHITE, COLOUR_GREY, COLOUR_RED, COLOUR_BLUE, &
            COLOUR_GREEN, COLOUR_YELLOW
  public :: LEVEL_ALWAYS, LEVEL_ERROR, LEVEL_WARNING, LEVEL_INFO, &
            LEVEL_DEBUG, LEVEL_TRACE

end module oolong
