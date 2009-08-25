class RubricCms::HomeController < ApplicationController

  before_filter :login_required

  # ========================================== Overrides ===========================================

  def authorized?
    require_admin_privileges :index
  end

  # ============================================ CRUD ============================================

  def index
  end

end
