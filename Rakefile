task :default => [:haml, :javascript]

directory "build"

desc "Compile the haml files into html"
task :haml

desc "Compile the coffee scripts into javascript"
task :javascript

desc "Place all the static files in the right place"
task :static => :downloadable_static

FileList["src/*.haml"].each do |haml_file|
    dest = haml_file.pathmap("build/%n.html")
    task :haml => dest
    file dest => ["build", haml_file, :static] do
        cd "build" do
            sh "haml -I .. -r custom_haml ../#{haml_file} ../#{dest}"
        end
    end 
    if ENV["DEVEL"].nil? then
        file dest => :javascript
    end
end

FileList["src/*.coffee"].each do |coffee_file|
    dest = coffee_file.pathmap("build/%n.js")
    task :javascript => dest
    file dest => ["build", coffee_file] do
        sh "coffee -c -o build #{coffee_file}"
    end
end

def downloads()
    if File.exists?('downloads.yaml') then
        return YAML.parse_file('downloads.yaml').to_ruby
    end
    return {}
end

directory "static_downloads"
downloads.each_pair do |name, src|
    dest = "static_downloads/#{name}"
    task :downloadable_static => dest
    file dest => ["static_downloads"] do
        sh "wget -O #{dest} #{src}"
    end

    real_dest = "build/#{name}"
    task :static => ["build", real_dest]
    file real_dest => dest do
        cp(dest, real_dest)
    end
end

FileList["static/*"].each do |static|
    dest = 'build' + static.sub(/^static/, '')
    file dest => static do
        cp static, dest
    end
    task :static => dest
end

task :clear_all => :clear do
    rm_rf "static_downloads"
end

task :clear do
    rm_rf "build"
end

task :perpet do
    while true do
        sh 'rake'
        sleep 1
    end
end
