class SvieController < ApplicationController
  before_action :require_login

  def edit
    @svie_memberships = current_user.memberships.select { |m| m.group.issvie && !m.newbie? }
  end

  def update
    current_user.update(svie_primary_membership: params[:svie][:primary_membership])
    redirect_to profiles_me_path
  end

end
