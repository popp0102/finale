module Finale
  class NotLoggedIn < StandardError
    def initialize(verb: nil, url: nil)
      message = "Request to (#{verb}) #{url} can't be made. You are not logged in."
      super(message)
    end
  end

  class MaxRequests < StandardError
    def initialize(max_requests)
      message = "Finale API request max reached: '#{max_requests}'"
      super(message)
    end
  end
end

