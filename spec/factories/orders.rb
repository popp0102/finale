FactoryBot.define do
  factory :finale_order, class: Finale::Order do
    transient do
      options { {} }
    end

    order_response { build(:finale_order_response, **options) }

    initialize_with do
      new(order_response)
    end
  end
end
