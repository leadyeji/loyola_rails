require 'twilio-ruby'
 
class TwilioController < ApplicationController
  include Webhookable
 
  after_filter :set_header
  
  skip_before_action :verify_authenticity_token
 
  def voice
    from_number = params[:From].gsub(/\+1/,"")
    if Customer.where(phone_number: from_number).length > 0
      user_balance = 0
      customer = Customer.where(phone_number: from_number).first
      Transaction.where(customer_id: customer.id).each do |transaction|
        user_balance += transaction.amount
      end
      response = Twilio::TwiML::Response.new do |r|
        r.Say "Hey there. Welcome to Loyola! Your balance is #{user_balance} dollars.", :voice => 'alice'
        # r.Play 'http://linode.rabasa.com/cantina.mp3'
        r.Sms "Hey there. Welcome to Loyola! Your balance is #{user_balance} dollars."
      end
    else
      Customer.create(name: '', phone_number: from_number)
      response = Twilio::TwiML::Response.new do |r|
        r.Say "Welcome to Loyola! You have just created an account with ABC Bistro! Your mobile telephone number is your account number. Your balance is zero dollars!", :voice => 'alice'
        # r.Play 'http://linode.rabasa.com/cantina.mp3'
        r.Sms "Welcome to Loyola! You have just created an account with ABC Bistro! Your mobile telephone number is your account number. Your balance is zero dollars!"
      end
    end
    render_twiml response
  end
  
  def sms
    puts "\n\n\n\n\nIN SMS\n\n\n\n\n"
    if /YES|yes|[Yy][eE][Ss]/.match(params[:Body])
      from_number = params[:From].gsub(/\+1/,"")
      if Customer.where(phone_number: from_number).length > 0
        user_balance = 0
        customer = Customer.where(phone_number: from_number).first
        Transaction.where(customer_id: customer.id).each do |transaction|
          user_balance += transaction.amount
        end
        response = Twilio::TwiML::Response.new do |r|
          r.Sms "Your transaction has been confirmed with ABC bistro.  Your balance is now #{user_balance}"
        end
      end
    elsif /NO|no/.match(params[:Body])
      response = Twilio::TwiML::Response.new do |r|
        r.Sms 'transaction declined'
      end
    elsif /b|B|[Bb]alance/.match(params[:Body])
      puts "\n\n\n\n\n\nIN HERE\n\n\n\n\n"
      from_number = params[:From].gsub(/\+1/,"")
      if Customer.where(phone_number: from_number).length > 0
        user_balance = 0
        customer = Customer.where(phone_number: from_number).first
        Transaction.where(customer_id: customer.id).each do |transaction|
          user_balance += transaction.amount
        end
        response = Twilio::TwiML::Response.new do |r|
          r.Sms "Hey there. Welcome to Loyola! Your balance is #{user_balance} dollars."
        end
      end
    elsif Customer.where(phone_number: from_number).length > 0
      user_balance = 0
      customer = Customer.where(phone_number: from_number).first
      Transaction.where(customer_id: customer.id).each do |transaction|
        user_balance += transaction.amount
      end
      response = Twilio::TwiML::Response.new do |r|
        # r.Play 'http://linode.rabasa.com/cantina.mp3'
        r.Sms "Hey there. Welcome to Loyola! Your balance is #{user_balance} dollars."
      end
    else
      Customer.create(name: '', phone_number: from_number)
      response = Twilio::TwiML::Response.new do |r|
        r.Sms "Welcome to Loyola! You have just created an account with ABC Bistro! Your mobile telephone number is your account number. Your balance is zero dollars!"
      end
    end 
    render_twiml response
  end
  
end