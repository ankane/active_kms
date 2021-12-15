module ActiveKms
  class LogSubscriber < ActiveSupport::LogSubscriber
    def decrypt(event)
      return unless logger.debug?

      name = "Decrypt Data Key (#{event.duration.round(1)}ms)"
      debug "  #{color(name, YELLOW, true)}"
    end

    def encrypt(event)
      return unless logger.debug?

      name = "Encrypt Data Key (#{event.duration.round(1)}ms)"
      debug "  #{color(name, YELLOW, true)}"
    end
  end
end
