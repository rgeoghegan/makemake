require 'rake'
require 'yaml'
require 'custom_haml'

task :default => [:haml, :javascript, :static]

desc "Compile the haml files into html"
task :haml

desc "Compile the coffee scripts into javascript"
task :javascript

desc "Place all the static files in the right place"
task :static => :downloadable_static

desc "Package everything into one html file"
task :package => [:clear, :set_package, :static, :javascript, :haml]

task :set_package do
    ENV["PACKAGE"] = "true"
end

directory "build"
FileList["src/*.haml"].each do |haml_file|
    dest = haml_file.pathmap("build/%n.html")
    task :haml => dest
    file dest => ["build", haml_file] do
        cd "build" do
            hamlfy('../' + haml_file, '../' + dest)
        end
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
        return YAML::load(open('downloads.yaml'))
    end
    return {}
end

task :downloadable_static

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

FileList["static/**/*"].each do |static|
    if File.file? static then
        dest = 'build' + static.sub(/^static/, '')
        dirname = File.dirname dest
        directory dirname
        file dest => [dirname, static] do
            cp static, dest
        end
        task :static => dest
    end
end

desc "Clears the build directory AND the static downloads directory"
task :clear_all => :clear do
    rm_rf "static_downloads"
end

desc "Clears the build directory"
task :clear do
    rm_rf "build"
end

file "downloads.yaml" do
    open("downloads.yaml", "w") do |outfile|
        outfile.write("# example line:\njquery.js: http://cdnjs.cloudflare.com/ajax/libs/jquery/1.8.3/jquery.min.js")
    end
end

directory "src"
directory "static"

desc "Creates all the necessary files and directories for a new instance"
task :init => ["downloads.yaml", "src", "static"]

def run_no_fail(task)
    # Runs the default task and if anything fails, catches and prints the
    # exception.
    Rake::Task.tasks.each {|t| t.reenable}
    begin
        task.invoke
    rescue RuntimeError => e
        puts e
    end
end
