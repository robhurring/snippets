module Highlighter
  
  DefaultBrush    = 'shBrushPlain'
  DefaultLanguage = 'plain'
  BrushMap = {
    'shBrushBash'       => ['sh', 'bash', 'shell'],
    'shBrushCss'        => ['css'],
    'shBrushDiff'       => ['diff', 'patch'],
    'shBrushJava'       => ['java'],
    'shBrushJScript'    => ['js', 'jscript', 'javascript'],
    'shBrushCpp'        => ['cpp', 'c'],
    'shBrushAS3'        => ['as3', 'as', 'actionscript', 'actionscript3'],
    'shBrushObjC'       => ['objc', 'o', 'm'],
    'shBrushPerl'       => ['pl', 'perl'],
    'shBrushPhp'        => ['php', 'phps'],
    'shBrushPython'     => ['py', 'python'],
    'shBrushRuby'       => ['rb', 'ruby', 'rails', 'ror'],
    'shBrushSql'        => ['sql'],
    'shBrushXml'        => ['xml', 'html', 'xhtml']
  }
  
  def self.brush_for_language(language)
    brush = BrushMap.select{ |brush, aliases| return brush if aliases.include?(language) }
    brush = DefaultBrush if brush.empty?
  end
  
  def self.language_for_extension(extension)
    brush = BrushMap.select{ |brush, aliases| return extension if aliases.include?(extension) }
    brush = DefaultLanguage if brush.empty?
  end
  
  def self.brush_for_extension(extension)
    brush_for_language(language_for_extension(extension))    
  end
  
end