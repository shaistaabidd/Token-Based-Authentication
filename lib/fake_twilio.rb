class FakeTwilio
    attr_reader :client
    def initialize(_account_sid, _auth_token)
      @client = Twilio::REST::Client.new account_sid, auth_token
    end

    def account_sid
      ENV['ACCOUNT_SID']
      #Rails.application.credentials.twilio[:account_sid]
    end

    def auth_token
      ENV['AUTH_TOKEN']
      #Rails.application.credentials.twilio[:auth_token]
    end

    def phone_number
      ENV['TWILIO_PHONE_NUMBER']
      #Rails.application.credentials.twilio[:twilio_phone_number]

    end

    def send_message(user)
      client.api.account.messages.create(
        from: phone_number,
        to: '+18312939010',
        body: body(user) 
        )
      rescue Twilio::REST::RestError => e
        #errors.add :twilio_notice, e.message.split("\n")
    end

    def body(user)
      header = "Hi #{user.name}\n\n"
      message = "your OTP authentication code is: #{user.test_otp_code}. Please verify your account."
      footer = "\n\nRegards,\nTeam System Plus."
      header + message + footer
    end

    # def initialize(_account_sid, _auth_token)
    #   @client = Twilio::REST::Client.new account_sid, auth_token
    # end

    # def account_sid
    #   Rails.application.credentials.twilio[:account_sid]
    # end

    # def auth_token
    #   Rails.application.credentials.twilio[:auth_token]
    # end

    # def phone_number
    #   Rails.application.credentials.twilio[:twilio_phone_number]

    # end

    # def send_message
    #   client.api.account.messages.create(
    #     from: phone_number,
    #     to: '+18312939010',
    #     body: "dsd" 
    #     )
    # end
  
    def verify
      @verify ||= Verify.new
    end
  
end
  
class Verify
    def initialize
    end
  
    def services(sid)
      @services = Services.new
    end
  
end
  
class Services
    def initialize
    end
  
    def verifications
      @verifications = Verifications.new
    end
  
    def verification_checks
      @verification_checks = VerificationChecks.new
    end
end
  
class Verifications
    def initialize
    end
  
    def create(to:, channel:)
      return { to: to, channel: channel }
    end
end
  
class VerificationChecks
    def initialize
    end
  
    def create(to:, code:)
      return OpenStruct.new(status:  'approved')
    end
end