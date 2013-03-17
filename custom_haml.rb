IS_DEVEL = ENV["PROD"].nil?

def load_javascript(filename, opts={})
    attrs = {:type => "text/javascript"}
    if IS_DEVEL then
        attrs[:src] = filename
        attrs.update(opts)
        return haml_tag(:script, attrs)
    else
        attrs.update(opts)
        File.open(filename) do |file|
            return haml_tag(:script, file.read, attrs)
        end
    end
end

def load_css(filename, opts={})
    if IS_DEVEL then
        attrs = {:href => filename, :rel => "stylesheet"}
        attrs.update(opts)
        haml_tag(:link, attrs)
    else
        File.open(filename) do |file|
            attrs = {:type => "text/css"}
            attrs.update(opts)
            haml_tag(:style, file.read, attrs)
        end
    end
end
