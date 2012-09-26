# = Repeater gem

module Kernel
  class InvalidRetryableOptions < RuntimeError; end

  ##
  # This method catches specified exceptions and retries to execute code block again
  #
  # The possible +options+ :
  #
  #   [tries]       count of tries (by default 1)
  #   [timeout]     timeout (by default 0)
  #   [sleep]       waiting for some sleep in seconds after each attempt (by default 0)
  #   [on]          what kind of exceptions it is required to catch (by default generic Exception class)
  #   [matching]    matching some error text by regular expression (by default any text /.*/)
  #   [logger]      custom logger, for instance Log4R (by default STDOUT)
  #   [trace]       should we output handled errors? (by default false)
  #   [silent]      should we generate exception after finishing? (by default false)
  #
  #  == Examples:
  #  <tt>retryable { raise "Some fake error" }<tt>
  #  <tt>rp(tries: 10, silent: true) { raise "Some fake error"}

  def retryable(options = {}, &block)
    opts = Retryable::merge_options(options)

    return nil if opts[:tries] == 0

    retry_exception = [ opts[:on] ].flatten
    retries = 0
    end_time = Time.now + opts[:timeout]
    exception = nil
    begin
      begin
        return block.call(retries)
      rescue *retry_exception => e
        exception = e
        Retryable::log_or_raise(opts[:logger], e) unless e.message =~ opts[:matching]
        Retryable::trace(opts[:logger], "#{e.class}: #{e.message}") if opts[:trace]
        sleep opts[:sleep].respond_to?(:call) ? opts[:sleep].call(retries) : opts[:sleep]
        if retries + 1 < opts[:tries]
          retries += 1
          retry if opts[:timeout] <= 0 || !Retryable::time_run_out?(end_time)
        end
      end
    end until Retryable::time_run_out?(end_time)
    Retryable::log_or_raise(opts[:logger], exception) unless exception.nil? || opts[:silent]
  end

  alias :rp :retryable

  module Retryable # :nodoc: all
    class << self

      def time_run_out?(end_time)
        Time.now >= end_time
      end

      def merge_options(options)
        default_options = { tries: 1, timeout: 0, sleep: 0, on: Exception, matching: /.*/, logger: nil, trace: false, silent: false }
        check_options(options, default_options)
        default_options.merge!(options)
      end

      def check_options(custom_options, default_options)
        invalid_options = default_options.merge(custom_options).keys - default_options.keys
        unless invalid_options.empty?
          Retryable::log_or_raise(opts[:logger], InvalidRetryableOptions.new("Invalid options: #{invalid_options.join(", ")}"))
        end
      end

      def trace(logger, msg)
        if logger.nil?
          puts "[WARN] Kernel.retryable: #{msg}"
        else
          logger.warn msg
        end
      end

      def log_or_raise(logger, *args)
        if logger.nil?
          raise *args
        else
          logger.send :error, *args
        end
      end
    end
  end

end