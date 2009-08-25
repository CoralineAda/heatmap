class RubricCms::AuditsController < ApplicationController

  before_filter :login_required

  # Overrides

  def authorized?
    require_admin_privileges
  end

  # CRUD

  def show
    @audit = Audit.find(params[:id])
    render :layout => 'audit_popup', :popup => true
  end

  private

end
