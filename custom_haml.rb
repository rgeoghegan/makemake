IS_DEVEL = ENV["PROD"].nil?

def load_javascript filename
    if IS_DEVEL then
        haml_tag(:script, {:src=>filename, :type => "text/javascript"})
    else
        File.open(filename) do |file|
            haml_tag(:script, file.read, :type => "text/javascript")
        end
    end
end

def load_css filename
    if IS_DEVEL then
        haml_tag(:link, {:href=>filename, :rel => "stylesheet"})
    else
        File.open(filename) do |file|
            haml_tag(:style, file.read, :type => "text/css")
        end
    end
end
