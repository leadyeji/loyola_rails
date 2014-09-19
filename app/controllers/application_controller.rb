class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  def twilio_num
    ENV['TWILIO_NUMBER']	
  end

  def twilio_sid
  	ENV['TWILIO_ACCOUNT_SID']
  end

  def twilio_auth_token
  	ENV['TWILIO_AUTH_TOKEN']
  end
  
  def twilio_client
  	Twilio::REST::Client.new self.twilio_sid, self.twilio_auth_token
  end
  
  def twilio_sms_response(message)
  	response = Twilio::TwiML::Response.new do |r|
  	  r.sms = message
  	end
  	response
  end

  def twilio_voice_response(message)
  	response = Twilio::TwiML::Response.new do |r|
  	  r.say = message
  	end
  	response
  end

  def twilio_sms_and_voice_message(sms_message, voice_message)
  	response = Twilio::TwiML::Response.new do |r|
      r.sms = sms_message
      r.say = voice_message
  	end
  end
end
