OmniAuth.config.on_failure = Proc.new {|environment| OmniAuth::FailureEndpoint.new(environment).redirect_to_failure }

Rails.application.config.middleware.use OmniAuth::Builder do
	provider :google, GOOGLE_CREDENTIALS['consumer_key'], GOOGLE_CREDENTIALS['consumer_secret'], { name: 'gmail', scope: 'https://mail.google.com/' }
end