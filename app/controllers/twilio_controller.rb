require 'twilio-ruby'
 
class TwilioController < ApplicationController
  include Webhookable
 
  after_filter :set_header
  
  skip_before_action :verify_authenticity_token
 
  def voice
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Hey there. Welcome to Loyola! Your balance is one hundred dollars.', :voice => 'alice'
      # r.Play 'http://linode.rabasa.com/cantina.mp3'
      r.Sms 'Hey there. Welcome to Loyola! Your balance is one hundred dollars.'
    end
 
    render_twiml response
  end
  
  def sms
    response = Twilio::TwiML::Response.new do |r|
      r.Sms 'Hey there. Welcome to Loyola! Your balance is one hundred dollars.'
    end
 
    render_twiml response
  end
  
end