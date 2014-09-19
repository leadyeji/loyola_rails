require 'twilio-ruby'

class CustomersController < ApplicationController
  before_action :set_merchant, only: [:show, :edit, :update, :destroy]

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
    amount = params[:amount].to_i
    customer_arr = Customer.where(phone_number: phone_number)
    if customer_arr.length > 0
      customer = customer_arr.first  
      Transaction.create(customer_id: customer.id, amount: params[:amount].to_i, merchant_id: params[:merchant_id].to_i)
    else
      customer = Customer.create(name: "", phone_number: params[:phone_number])
      Transaction.create(customer_id: customer.id, amount: params[:amount].to_i, merchant_id: params[:merchant_id].to_i)
    end  
    balance = 0
    customer = Customer.where(phone_number: phone_number).first
    Transaction.where(customer_id: customer.id).each do |transaction|
      balance += transaction.amount
    end
    if amount < 0
      amount = amount*(-1)
      @client = self.twilio_client
      phone_number = customer.phone_number
      @client.messages.create(
        to: phone_number,
        from: '2126837820',
        body: "ABC Bistro requests your permission to settle your bill by charging your account $ #{amount}.  Please respond YES to confirm, NO to decline."
      )
    else
      @client = self.twilio_client
      phone_number = customer.phone_number
      @client.messages.create(
        to: phone_number,
        from: '2126837820',
        body: "Your ABC Bistro account has received a credit of $ #{amount} dollars."
      )
    end
  end

  def send_sms
    @client = self.twilio_client
    @client.messages.create(
      to: '6302207435',
      from: '2126837820',
      body: 'live from Twilio'
    )
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
