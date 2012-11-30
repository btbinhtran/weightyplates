class CustomFailure < Devise::FailureApp

  def referer
    @env['HTTP_REFERER'] || '/'
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect_to request.referer
    end
  end

end