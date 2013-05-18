require 'base64'

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

def include_img(filename, mimetype=nil, attrs={})
    if mimetype.nil?
        [
            [/.*\.jpg/, "image/jpeg"],
            [/.*\.gif/, "image/gif"],
            [/.*\.png/, "image/png"]
        ].each do |regex, mime|
            if regex.match(filename) then
                mimetype = mime
                break
            end
        end
    end

    opts = {:src => filename}
    if PACKAGE then
        content = File.open(filename) do |file|
            Base64.encode64(file.read)
        end
        opts = {:src => "data:#{mimetype};base64,#{content}"}
    end
    opts.update(attrs)
    return haml_tag(:img, opts)
end
