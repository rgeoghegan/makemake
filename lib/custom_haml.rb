require 'base64'
require 'haml'

class Package
    include Singleton
    attr_accessor :enable
end
Package.instance.enable = false

def include_tag(tag_name, filename, src_attr, opts={})
    attrs = {}
    if not Package.instance.enable then
        attrs[src_attr] = filename
    end
    attrs.update(opts)

    if Package.instance.enable then
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
    if Package.instance.enable then
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
    if Package.instance.enable then
        content = File.open(filename) do |file|
            Base64.encode64(file.read)
        end
        opts = {:src => "data:#{mimetype};base64,#{content}"}
    end
    opts.update(attrs)
    return haml_tag(:img, opts)
end

def hamlfy(src, dest)
    puts "#{src} -> #{dest}"

    if ENV["PACKAGE"] == "true"
        Package.instance.enable = true
    end

    open(src) do |srcfile|
        template = srcfile.read
        interpolated = Haml::Engine.new(template).render
        open(dest, "w") {|outfile| outfile.write(interpolated)}
    end
end
