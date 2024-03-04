module oolong

  use logger_mod, only: logger_type
  use colour_mod, only: COLOUR_WHITE, COLOUR_GREY, COLOUR_RED, COLOUR_BLUE, &
                        COLOUR_GREEN, COLOUR_YELLOW

  implicit none
  private

  public :: logger_type
  public :: COLOUR_WHITE, COLOUR_GREY, COLOUR_RED, COLOUR_BLUE, &
            COLOUR_GREEN, COLOUR_YELLOW

end module oolong
