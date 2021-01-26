module Finale
  module URIHelper
    BASE_URL = 'https://app.finaleinventory.com'

    def url(resource, url_base: BASE_URL, account: @account, id: nil, action: nil)
      resource_path = resource_path(resource, account: account, id: id, action: action)
      url_from_path(resource_path, url_base: url_base)
    end

    def url_from_path(resource_path, url_base: BASE_URL)
      resource_path_parts = resource_path.split("/").reject(&:empty?)
      full_path_parts     = [url_base] + resource_path_parts
      full_path_parts.join("/")
    end

    def resource_path(resource, account: @account, id: nil, action: nil, leading_slash: false)
      path = [account, 'api', resource, id, action].compact.join('/')
      path = leading_slash ? "/#{path}" : path
      path
    end
  end
end
