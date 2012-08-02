FactoryGirl.define do
	factory :user do
		sequence(:name) { |n| "Person #{n}" }
		sequence(:email) { |n| "Person_#{n}@example.com"}
		password "foobar"
		password_confirmation "foobar"

		#factory to create admins
		factory :admin do
			admin true
		end
	end
end