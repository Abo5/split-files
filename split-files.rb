def sanitize_file_path(path)
  # This function removes leading and trailing spaces from the file path and removes quotation marks if present.
  path.strip.gsub(/^'(.*)'$/, '\1')
end

def split_file(input_file, num_splits)
  unless File.exist?(input_file)
    puts "The specified input file '#{input_file}' does not exist."
    return
  end

  total_lines = File.foreach(input_file).count
  lines_per_split = (total_lines / num_splits.to_f).ceil

  file_basename = File.basename(input_file, '.*')
  file_extension = File.extname(input_file)

  (1..num_splits).each do |split_number|
    output_file = "#{file_basename}_part#{split_number}#{file_extension}"
    File.open(output_file, 'w') do |output|
      File.open(input_file, 'r') do |input|
        start_line = (split_number - 1) * lines_per_split
        end_line = split_number * lines_per_split - 1

        input.each_line.with_index do |line, index|
          break if index > end_line
          output.write(line) if index >= start_line
        end
      end
    end

    # Display file information for each split file
    puts "This is file number #{split_number} info"
    puts "File Information:"
    puts "File size: #{File.size(output_file)} bytes"
    puts "Line count: #{File.foreach(output_file).count} lines"
    puts "File type: Text file"
    puts "File path: #{File.expand_path(output_file)}"
    puts
  end

  puts "YAYY! The file splitting process is complete."
end

# Getting the file path from the user and sanitizing it
print "Enter file path: "
file_path = gets.chomp
file_path = sanitize_file_path(file_path)
print "How many files do you want to split: "
# Convert the input to an integer
num_splits = gets.chomp.to_i
split_file(file_path, num_splits)
