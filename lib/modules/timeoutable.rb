require "timeout"

module Timeoutable
  DEFAULT_TIMEOUT = 0.5.freeze

  def with_timeout(&block)
    Timeout::timeout(DEFAULT_TIMEOUT){ block.call }
  rescue
    ''
  end
end
