class UserStocksController < ApplicationController
  def create
    stock = Stock.check_db(params[:ticker])
    if stock.blank?
      stock = Stock.new_lookup(params[:ticker])
      stock.save
    end
    @user_stock = UserStock.create(user: current_user, stock: stock)
    flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio"
      redirect_to request.referrer
  end

  def destroy
    stock = Stock.find(params[:id])
    user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    if user_stock.destroy
      flash[:notice] = "You have successfully removed #{stock.ticker} from tracking"
      redirect_to my_portfolio_path
    else
      flash[:alert] = 'Something went wrong'
      redirect_to my_portfolio_path
    end
  end
  
end
