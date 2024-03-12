# frozen_string_literal: true

class CommentsController < ApplicationController

  # POST /comments
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:text, :commentable_type, :commentable_id)
  end
end
