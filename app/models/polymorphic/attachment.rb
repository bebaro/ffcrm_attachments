# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------

class Attachment < ActiveRecord::Base

  ATTACHMENT_FORMATS = ['image/jpeg', 'image/png', 'image/gif', 'image/jpg']
  STYLES = { medium: "150x150>" }

  belongs_to :user
  belongs_to :entity, :polymorphic => true

  do_not_validate_attachment_file_type :attachment

  has_attached_file :attachment,
    styles: lambda{ |a| ATTACHMENT_FORMATS.include?(a.content_type) ? STYLES : {} }

  def to_default_image
    default = "default-document.jpg"
    matches = Regexp.new(/\.(doc|pdf|ppt|xls)/).match(self.attachment_file_name)
    default = "default-#{matches[1]}.png" if matches
    "/assets/ffcrm_attachments/#{default}"
  end

  def is_image?
    ATTACHMENT_FORMATS.include?(attachment.content_type)
  end

  ActiveSupport.run_load_hooks(:fat_free_crm_attachment, self)
end
