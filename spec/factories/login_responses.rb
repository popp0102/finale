FactoryBot.define do
  factory :login_response, class: Hash do
    initialize_with do
      {
        name: "some_user@some_account.com",
        primaryEmail: "some_user@some_account.com",
      }
    end
  end
end

