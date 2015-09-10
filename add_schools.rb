schools = %w[
abjuration
conjuration
divination
enchantment
evocation
illusion
necromancy
transmutation
]

Dir.foreach('_posts') do |spell_file|
  next if spell_file == '.' or spell_file == '..'

  tags_index = 5
  new_tag = ""
  puts spell_file

  # read through once and find the school
  contents = File.readlines('_posts/'+ spell_file).each_with_index do |line, idx|
    # # mark the tags line
    # if line =~ /^tags:/
    #   tags_index = idx
    # end

    schools.each do |school|
      if line =~ /#{school}/i
        puts school + "  /  " + line
        new_tag = school
      end
    end
  end

puts "contents: #{contents}"
  File.open('_posts/'+ spell_file, 'w') do |file|

    # read through again and write the school into tags
    contents.each do |line|
      if line =~ /^tags: / && line !~ /#{new_tag}/
        line = line.gsub(/\]$/, ", #{new_tag}]")
      end
      puts line
      file.puts line
    end
  end
  puts "================"
end
