class CustomersController < ApplicationController
  before_action :set_merchant, only: [:show, :edit, :update, :destroy]
# GET /customers
  # GET /customers.json
  def index
    @customers = Customer.all
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  def check_balance
    @balance = 0
    Transaction.where(:customer_id => Customer.where(phone_number: params[:phone_number]).first.id).each do |transaction|  
      @balance += transaction.amount
    end
  end

  def create_or_update_customer_credit
    phone_number = params[:phone_number]
    if Customer.where(phone_number: phone_number).length > 0
      put "\n\n\n\n\n\nIN THE IF STATEMENT\n\n\n\n\n\n\n\n"
      put "\n\n\n\n\n\n\nphone number: #{params[:phone_number]}\n\n\n\n\n\n\n"
      Transaction.create(customer_id: Customer.where(phone_number: phone_number).first.id, amount: params[:amount].to_i, merchant_id: params[:merchant_id].to_i)
    else
      put "\n\n\n\n\n\nIN THE ELSE STATEMENT\n\n\n\n\n\n\n\n\n\n"
      put "\n\n\n\n\n\n\nphone number: #{params[:phone_number]}\n\n\n\n\n\n\n"
      Customer.create(name: "", phone_number: params[:phone_number])
      Transaction.create(customer_id: Customer.where(phone_number: phone_number).first.id, amount: params[:amount].to_i, merchant_id: params[:merchant_id].to_i)
    end  
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: 'Test was successfully created.' }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @merchant = Merchant.find(params[:id])
    end
    def customer_params
      params.require(:customer).permit(:name, :phone_number)
    end
end
