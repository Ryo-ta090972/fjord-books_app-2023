# frozen_string_literal: true

class CommentsController < ApplicationController

  # POST /comments
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to request.referer, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      redirect_to request.referer, status: :unprocessable_entity
    end
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:text, :commentable_type, :commentable_id)
  end
end
