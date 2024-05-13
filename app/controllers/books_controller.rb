class BooksController < ApplicationController
  def index
    @book = Book.new
    @books = Book.all
    @user = current_user
    
  end
  
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @book.save
    redirect_to book_path(@book)
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @new_book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end
  
  def destroy
    @book = Book.find(params[:id])
    if @book.destroy
    redirect_to books_path
    else
      render :index
    end
  end
  
  private
  
  def book_params
    params.require(:book).permit(:title, :body)
    
  end
  
end
