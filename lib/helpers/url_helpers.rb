module URLHelpers
    
  def link_to(title, path, *args)
    options = args.extract_options!
    html_options = options.delete(:html) || {}
    
    "<a href='%s' %s>%s</a>" % [url_for(path, options), html_options.to_attributes, title]
  end

  def image_tag(path, *args)
    options = args.extract_options!
    path_options = options.delete(:path) || {}
    path = '/images/' + path
    
    "<img src='%s' %s/>" % [url_for(path, path_options), options.to_attributes]
  end
  
  def url_for(url_fragment, *args)
    options = args.extract_options!
    mode = options.delete(:mode) || :path_only

    unless url_fragment =~ /^http/
      case mode
      when :path_only
        base = request.script_name
      when :full
        scheme = request.scheme
        if (scheme == 'http' && request.port == 80 ||
            scheme == 'https' && request.port == 443)
          port = ""
        else
          port = ":#{request.port}"
        end
        base = "#{scheme}://#{request.host}#{port}#{request.script_name}"
      else
        raise TypeError, "Unknown url_for mode #{mode}"
      end
      url = "#{base}#{url_fragment}"
    else
      url = url_fragment
    end
    
    params = options.to_params
    params = '?' + params unless params.empty?
    "#{url}#{params}"
  end
end