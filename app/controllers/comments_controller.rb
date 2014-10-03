class CommentsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /comments/999
  def index
    if params[:password] == "999"
      render json: Comment.all
    else
      render json: {error: 'wrong password'}
    end
  end

  # POST /comments/create
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end


  # GET /comments_for_book/:douban_book_id
  def comments_for_book
    comments = Comment.where({douban_book_id: params[:douban_book_id]}).map do |comment|
      comment.comment_info
    end

    results = {douban_book_id: params[:douban_book_id], comments: comments}
    render json: results
  end

  private

  def comment_params
    params.require(:comment).permit(:douban_book_id, :content, :user_name, :group_name)
  end

end