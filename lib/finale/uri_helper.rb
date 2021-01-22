module Finale
  module URIHelper
    BASE_URL = 'https://app.finaleinventory.com'

    def url(resource, url_base: BASE_URL, account: @account, id: nil, action: nil)
      resource_path = resource_path(resource, account: account, id: id, action: action)
      url_from_path(resource_path, url_base: url_base)
    end

    def url_from_path(resource_path, url_base: BASE_URL)
      "#{url_base}/#{resource_path}"
    end

    def resource_path(resource, account: @account, id: nil, action: nil, leading_slash: false)
      path = [account, 'api', resource, id, action].compact.join('/')
      path = leading_slash ? "/#{path}" : path
      path
    end
  end
end
