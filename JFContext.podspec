Pod::Spec.new do |s|
  s.name             = "JFContext"
  s.version          = "0.1.0"
  s.summary          = "A short description of JFContext."
  s.description      = <<-DESC
                       An optional longer description of JFContext

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.license          = 'MIT'
  s.author           = { "Denis Jajčević" => "denis.jajcevic@gmail.com" }
  s.source           = { :git => "https://github.com/jfwork/JFContext.git", :tag => s.version.to_s }

  s.platform     = :ios, '5.0'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Resources'

  s.ios.exclude_files = 'Classes/osx'
end
