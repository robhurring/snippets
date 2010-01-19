module FormHelpers
  def error_for(object, attribute, title = nil)
    if message = object.errors.on(attribute)
      "<div class='form_error'>#{title || attribute} #{message}</div>"
    end
  end
  
end