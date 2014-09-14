require 'twilio-ruby'

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
    amount = params[:amount].to_i
    if Customer.where(phone_number: phone_number).length > 0
      Customer.all.each do |customer|
        Transaction.create(customer_id: customer.id, amount: params[:amount].to_i, merchant_id: params[:merchant_id].to_i)
      end
    else
      Customer.create(name: "", phone_number: params[:phone_number])
      Customer.all.each do |customer|
        Transaction.create(customer_id: customer.id, amount: params[:amount].to_i, merchant_id: params[:merchant_id].to_i)
      end
    end  
    balance = 0
    customer = Customer.where(phone_number: phone_number).first
    Transaction.where(customer_id: customer.id).each do |transaction|
      balance += transaction.amount
    end
    if amount < 0
      amount = amount*(-1)
      @account_sid = 'AC252fd68f455d6827cff9af9ec2c447e7'
      @auth_token = '03792a669827438532699b311e7893ae'
      @client = Twilio::REST::Client.new @account_sid, @auth_token
      Customer.all.each do |customer|
        phone_number = customer.phone_number
        @client.messages.create(
          to: phone_number,
          from: '2126837820',
          body: "ABC Bistro requests your permission to settle your bill by charging your account $ #{amount}.  Please respond YES to confirm, NO to decline."
        )
      end
    else
      @account_sid = 'AC252fd68f455d6827cff9af9ec2c447e7'
      @auth_token = '03792a669827438532699b311e7893ae'
      @client = Twilio::REST::Client.new @account_sid, @auth_token
      Customer.all.each do |customer|
        phone_number = customer.phone_number
        @client.messages.create(
          to: phone_number,
          from: '2126837820',
          body: "Your ABC Bistro account has received a credit of $ #{amount} dollars."
        )
      end
    end
  end

  def send_sms
    @account_sid = 'AC252fd68f455d6827cff9af9ec2c447e7'
    @auth_token = '03792a669827438532699b311e7893ae'
    @client = Twilio::REST::Client.new @account_sid, @auth_token
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
