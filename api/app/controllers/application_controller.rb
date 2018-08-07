class ApplicationController < ActionController::Base
  YELLOW = "\e[33m"
  RED = "\e[31m"
  WHITE  = "\033[0m"

  NONE = "#{RED}NONE"

  def endpoint
    Rails.logger.debug "\n#{YELLOW}ETAG: #{request.headers['HTTP_IF_NONE_MATCH'] || NONE}#{WHITE}\n"

    render json: {
      key1: :val1,
      key2: :val2,
      key3: :val3,
      key4: :val4,
      key5: :val5
    }
  end
end
