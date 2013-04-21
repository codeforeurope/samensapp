class SandboxEmailInterceptor
  def self.delivering_email(message)
    message.to = ['piotr@tapangi.com']
  end
end

#ActionMailer::Base.register_interceptor(SandboxEmailInterceptor)