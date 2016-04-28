module UserManipulator
  extend ActiveSupport::Concern

  def can_manipulate_users?
    super_admin?
  end

  def promote_user!(params)
    raise PermissionError unless can_manipulate_users?
    return unless ["admin", "super_admin"].include? params[:role]
    user = User.find params[:id]
    return if user.super_admin?
    user.role = params[:role]
    user.save!
  end

  module Anonymous
    extend ActiveSupport::Concern

    def can_manipulate_users?
      false
    end

    def promote_user!(params)
      raise PermissionError
    end
  end
end
