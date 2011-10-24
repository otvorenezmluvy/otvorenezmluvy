module Document::Archivable
  extend ActiveSupport::Concern

  def path_to_hardcopy(type, options = {})
    directory = get_path(File.dirname(archive_path), options[:relative] || false)
    filename = File.basename(archive_path)

    base_path = File.join(directory, filename)

    case type
      when :as_is then base_path
      when :directory then directory
      when :original then "#{base_path}.pdf"
      when :text  then "#{base_path}-text.pdf"
      else raise "Hardcopy type '#{type}' is not available"
    end
  end

  private
  def get_path(path, relative = false)
    path_chunks = path.split('/')
    output = []
    path_chunks.each do |chunk|
      numbers = chunk.scan(/[0-9]{3,}/).collect do |part|
        part.to_i / 1000 * 1000
      end
      output += numbers if numbers.any?
      output << chunk
    end
    if relative
      "/documents/#{output.join('/')}"
    else
      "#{Rails.root}/public/documents/#{output.join('/')}"
    end
  end
end

