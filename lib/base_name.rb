class BaseName
  def self.extract(file)
    File.basename(file, File.extname(file))
  end
end
