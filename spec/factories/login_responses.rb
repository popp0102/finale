FactoryBot.define do
  factory :login_response, class: Hash do
    initialize_with do
      {
        name: "some_user@some_company.com",
        primaryEmail: "some_user@some_company.com",
      }
    end
  end
end

