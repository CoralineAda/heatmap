# Display to the console the contents of the README file.
puts IO.read(File.join(File.dirname(__FILE__), 'README'))

puts "To continue installation:"
puts "Run rake rubric_cms:install, and then rake db:migrate to complete installation."
