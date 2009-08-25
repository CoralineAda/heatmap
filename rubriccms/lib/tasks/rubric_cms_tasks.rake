namespace :rubric_cms do
  
  desc 'Installs necessary migrations and other files for RubricCMS'
  task :install do
    puts 'Copying migrations...'
    system 'rsync -ru vendor/plugins/rubric_cms/db/migrate db'

    puts 'Copying plugin dependencies to vendor/plugins/rubric_cms_dependencies/...'
    system 'rsync -ru vendor/plugins/rubric_cms/dependencies/plugins vendor/plugins/rubric_cms_dependencies'

    puts 'Copying javascripts to public/javascripts...'
    system 'rsync -ru vendor/plugins/rubric_cms/dependencies/javascripts/ public/javascripts'
    
    puts 'Copying stylesheets to public/stylesheets...'
    system 'rsync -ru vendor/plugins/rubric_cms/dependencies/stylesheets/ public/stylesheets'
    
    puts 'Copying configuration file to /config/rubric_cms...'
    system 'rsync -ru vendor/plugins/rubric_cms/config/rubric_cms.rb config/'

    #FIXME Should output the next steps here.
    puts "\nInstallation complete. Refer to the README for next steps."
  end

end