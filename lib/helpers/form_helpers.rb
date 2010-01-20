module FormHelpers
  def error_for(object, attribute, title = nil)
    if message = object.errors.on(attribute)
      message = Array(message).inject(''){ |o, m| o + "#{title || attribute} #{m}<br/>" }
      "<div class='form_error'>#{message}</div>"
    end
  end
  
end