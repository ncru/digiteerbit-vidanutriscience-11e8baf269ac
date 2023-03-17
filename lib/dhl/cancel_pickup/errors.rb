class CancelPickup
  class InputError < StandardError; end
  class OptionsError < InputError; end

  class Upstream < StandardError
    class UnknownError < Upstream; end
    class ValidationFailureError < Upstream; end
  end
end
