def load_file filename
    File.open(filename) do |file|
        return file.read
    end
end
