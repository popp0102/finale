FactoryBot.define do
  factory :finale_facility, class: Finale::Facility do
    transient do
      options { {} }
    end

    response { build(:finale_facility_response, **options) }

    initialize_with do
      new(response)
    end
  end
end
