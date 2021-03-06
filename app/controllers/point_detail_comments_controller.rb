class PointDetailCommentsController < ApplicationController
  before_action :set_point_detail_comment, only: %i[edit update]
  before_action :authorize

  def index
    comments = comments_by_principle_user_id(params[:principle_id].to_i, params[:user_id].to_i)
    @point_detail_comments = PointDetailCommentDecorator.decorate_collection(comments)
    @point_detail_comment = PointDetailComment.new
    render layout: false
  end

  def create
    create_comment = CreatePointDetailComment.new(params[:evaluation_id], params[:principle_id],
                                                  params[:user_id], current_user)
    point_detail_comment = create_comment.call(update_params[:comment])
    return head :forbidden unless point_detail_comment&.valid?

    @point_detail_comment = point_detail_comment.decorate
  end

  def update
    @point_detail_comment.update update_params
    respond_to do |format|
      format.html { redirect_back }
      format.js
    end
  end

  def edit; end

  private

  def set_point_detail_comment
    @point_detail_comment = PointDetailComment.find(params[:id]).decorate
  end

  def update_params
    params.require(:point_detail_comment).permit(:comment)
  end

  def comments_by_principle_user_id(principle_id, user_id)
    PointDetailComment.includes([{ point_detail: [:point_request] }])
                      .order(:created_at)
                      .select do |comment|
      comment.point_detail.principle_id == principle_id &&
        comment.point_detail.point_request.user_id == user_id
    end
  end

  def authorize
    principle = @point_detail_comment&.principle
    principle ||= Principle.find params[:principle_id]
    head :forbidden unless current_user.leader_of?(principle.group)
  end
end
