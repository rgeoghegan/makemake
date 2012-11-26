task :default => :haml

directory "build"

desc "Compile the haml files into html"
task :haml

desc "Compile the coffee scripts into javascript"
task :javascript

FileList["src/*.haml"].each do |haml_file|
    dest = haml_file.pathmap("build/%n.html")
    task :haml => dest
    file dest => ["build", haml_file, :javascript] do
        sh "haml -r custom_haml #{haml_file} #{dest}"
    end 
end
