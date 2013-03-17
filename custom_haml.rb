
PACKAGE = ! ENV['PACKAGE'].nil?

def include_tag(tag_name, filename, src_attr, opts={})
    attrs = {}
    if not PACKAGE then
        attrs[src_attr] = filename
    end
    attrs.update(opts)

    if PACKAGE then
        File.open(filename) do |file|
            return haml_tag(tag_name, file.read, attrs)
        end
    else
        return haml_tag(tag_name, attrs)
    end
end

def include_js(filename, opts={})
    attrs = {:type => "text/javascript"}.update(opts)
    include_tag(:script, filename, :src, attrs)
end

def include_css(filename, opts={})
    if PACKAGE then
        tag = :style
        attrs = {:type => "text/css"}
    else
        tag = :link
        attrs = {:rel => "stylesheet"}
    end

    include_tag(tag, filename, :href, attrs.update(opts))
end
