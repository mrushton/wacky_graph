module WackyGraph
  class GraphError < StandardError
    attr_accessor :message, :type, :code, :error_subcode
#    attr_accessor :type
#    attr_accessor :code
#    attr_accessor :error_subcode

    def initialize(message, type, code, error_subcode)
      @message = message
      @type = type
      @code = code
      @error_subcode = error_subcode
    end
  end
end
