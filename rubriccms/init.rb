# Include hook code here

require 'faker'
require 'friendly_id'
require 'aasm' # FIXME Actually requires rubyist-aasm. Hmm.
require 'will_paginate'
require 'paperclip'
require 'rubric_cms'

config.to_prepare do
  ApplicationController.helper(RubricCms::RubricCmsHelper)
end

