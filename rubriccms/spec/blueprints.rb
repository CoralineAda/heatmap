require 'faker'
require 'machinist/active_record'
require 'sham'

# Users
Sham.first_name { Faker::Name.first_name }
Sham.last_name  { Faker::Name.last_name }

# Blueprints

FlashAsset.blueprint do
  name              { Faker::Lorem.words(3).to_s }
  description       { Faker::Lorem.words(5).to_s }
  active            { true }
  media_file_name   { "#{Faker::Lorem.words(1).to_s}.fla" }
  media_file_size   { 1234 }
  media_updated_at  { DateTime.now }
end

FooterItem.blueprint do
  link_text   { (Faker::Lorem.words(2) * " ").titleize }
  link_title  { Faker::Lorem.sentence }
  self.url    { "/#{Faker::Lorem.words(1)}/" }
end

ImageAsset.blueprint do
  name              { Faker::Lorem.words(3).to_s }
  description       { Faker::Lorem.words(5).to_s }
  active            { true }
  media_file_name   { "#{Faker::Lorem.words(1).to_s}.jpg" }
  media_file_size   { 1234 }
  media_updated_at  { DateTime.now }  
end

NavbarItem.blueprint do
  link_text   { (Faker::Lorem.words(2) * " ").titleize }
  link_title  { Faker::Lorem.sentence }
  self.url    { "/#{Faker::Lorem.words(1)}/" }
end

PdfAsset.blueprint do
  name              { Faker::Lorem.words(3).to_s }
  description       { Faker::Lorem.words(5).to_s }
  active            { true }
  media_file_name   { "#{Faker::Lorem.words(1).to_s}.pdf" }
  media_file_size   { 1234 }
  media_updated_at  { DateTime.now }
end

QuicktimeAsset.blueprint do
  name              { Faker::Lorem.words(3).to_s }
  description       { Faker::Lorem.words(5).to_s }
  active            { true }
  media_file_name   { "#{Faker::Lorem.words(1).to_s}.mov" }
  media_file_size   { 1234 }
  media_updated_at  { DateTime.now }
end

SidebarItem.blueprint do
  link_text     { (Faker::Lorem.words(2) * " ").titleize }
  link_title    { Faker::Lorem.sentence }
  self.url      { "/#{Faker::Lorem.words(1)}/" }
  site_section  { SiteSection.make }
end

SiteConfiguration.blueprint do
  site_name			                        { 'Test Site' }
  default_meta_description			        { "#{Faker::Lorem.paragraphs(2)}" }
  default_meta_keywords			            { "#{Faker::Lorem.words(10) * ', '}" }
  include_site_section_in_window_title  { true }
  window_title_separator			          { ' : ' }
  maximum_file_size_for_flash_asset			{ 10 }
  maximum_file_size_for_image_asset			{ 12 }
  maximum_file_size_for_pdf_asset			  { 14 }
  maximum_file_size_for_quicktime_asset { 16 }
  active                                { true }
end

SitePage.blueprint :root_page do 
  name                  { Faker::Lorem.words(5) * " " }
  page_title            { (Faker::Lorem.words(5) * " ").titleize }
  content               { "#{Faker::Lorem.paragraphs(2)}" }
  meta_description      { Faker::Lorem.sentence }
  meta_keywords         { Faker::Lorem.words(12) * ", " }
  navbar_item_enabled   { true }
  sidebar_item_enabled  { true }
end

SitePage.blueprint do
  name                  { Faker::Lorem.words(5) * " " }
  page_title            { (Faker::Lorem.words(5) * " ").titleize }
  content               { "#{Faker::Lorem.paragraphs(2)}" }
  slug                  { (Faker::Lorem.words(2) * "_").downcase }
  site_section_id       { SiteSection.make }
  navbar_item_enabled   { 1 }
  sidebar_item_enabled  { 1 }
  meta_description      { "#{Faker::Lorem.paragraphs(2)}" }
  meta_keywords         { "#{Faker::Lorem.words(10) * ', '}" }
  navbar_item_enabled   { true }
  sidebar_item_enabled  { true }
end

SiteSection.blueprint do
  name                      { (Faker::Lorem.words(5) * " ").titleize }
  root_url                  { (Faker::Lorem.words(2) * "_").downcase }
  active                    { true }
  default_meta_description  { "#{Faker::Lorem.paragraphs(2)}" }
  default_meta_keywords     { "#{Faker::Lorem.words(10) * ', '}" }
  sidebar_enabled           { true }
end

# FIXME How do I pull out this dependency on User and Role?

User.blueprint do
  first_name
  last_name
  password              { "floodbrothers" }
  password_confirmation { "floodbrothers" }
  email                 { "#{Faker::Name.first_name.downcase}@seologic.com" }
  activated_at          { 5.days.ago.to_s :db }
end

Role.blueprint do
  name { Faker::Lorem.words(1).to_s }
end

Role.blueprint :admin do
  name { 'Admin' }
end

Role.blueprint :client do
  name { 'Client' }
end

