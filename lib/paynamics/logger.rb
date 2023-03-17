module Paynamics
  # Defines the logger.
  class Logger
    attr_reader :logger
  
    # Initialize the logger instance.
    def initialize
      logger           = ActiveSupport::Logger.new(STDOUT)
      logger.formatter = ::Logger::Formatter.new
      @logger          = ActiveSupport::TaggedLogging.new(logger)
    end
  end
end
