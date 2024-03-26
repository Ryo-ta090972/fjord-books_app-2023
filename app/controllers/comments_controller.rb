# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]

  # GET /books/1/edit
  def edit; end

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

  # PATCH/PUT /books/1 or /books/1.json
  def update
    return unless @comment.user_id == current_user.id

    if @comment.update(comment_params)
      redirect_to polymorphic_path([@comment.commentable]), notice: t('controllers.common.notice_update', name: Comment.model_name.human)
    else
      fredirect_to polymorphic_path([@comment.commentable]), status: :unprocessable_entity
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    return unless @comment.user_id == current_user.id

    @comment.destroy
    redirect_to request.referer, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:text, :commentable_type, :commentable_id)
  end
end
