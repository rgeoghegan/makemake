def load_javascript filename
    if ENV['DEBUG'].nil? then
        File.open(filename) do |file|
            haml_tag(:script, file.read, :type => "text/javascript")
        end
    else
        haml_tag(:script, {:src=>filename, :type => "text/javascript"})
    end
end

def load_css filename
    if ENV['DEBUG'].nil? then
        File.open(filename) do |file|
            haml_tag(:style, file.read, :type => "text/css")
        end
    else
        haml_tag(:link, {:href=>filename, :rel => "stylesheet"})
    end
end
