module SessionsHelper

	def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token 															#creating a cookie as a hash and the method .permanent causes Rails to set the expiration of the cookie value remember_token to 20.years .from_now automatically
		self.current_user = user 																							#creates current_user accessible in Controllers and Views thus allowing code such as (<%= current_user.name%>) and self helps not to create a local variable called current_user
	end

	def signed_in?
		!current_user.nil?
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token]) 											#sets the variable to the user corresponding to the remember token, but only if the variable is undefined thus the find_by_remember_token is called atleast once every time a user visits a page on the site
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end
end
