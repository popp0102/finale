FactoryBot.define do
  factory :facility_response, class: Hash do
    id      { '10001' }
    account { 'some_account' }

    initialize_with do
      {
        facilityId: id,
        facilityUrl: "/#{account}/api/facility/#{id}",
        statusId: 'FACILITY_ACTIVE',
        lastUpdatedDate: '2018-07-30T17:57:29',
        createdDate: '2018-07-30T17:56:59',
        actionUrlDeactivate: "/#{account}/api/facility/#{id}/deactivate",
        contactMech: {
          contactMechId: '10093',
          contactMechTypeId: 'POSTAL_ADDRESS',
          address1: '123 Main St',
          city: 'Denver',
          stateProvinceGeoId: 'CO',
          postalCode: '12345',
          countryGeoId: 'USA'
        },
        facilityName: 'A Warehouse',
        parentFacilityUrl: "/#{account}/api/facility/10000",
        shippingDisabled: nil,
        actionUrlActivate: nil,
        receivingDisabled: nil
      }
    end
  end

  factory :facility_collection, class: Hash do
    account      { 'some_account' }
    facility_id1 { '10000' }
    facility_id2 { '10001' }

    initialize_with do
      {
        facilityId: [facility_id1, facility_id2],
        facilityUrl: ["/#{account}/api/facility/#{facility_id1}", "/#{account}/api/facility/#{facility_id2}"],
        statusId: ['FACILITY_ACTIVE', 'FACILITY_ACTIVE'],
        lastUpdatedDate: ['2018-07-19T14:51:20', '2018-07-20T14:51:20'],
        createdDate: ['2017-07-19T14:51:20', '2017-07-20T14:51:20'],
        actionUrlDeactivate: ["/#{account}/api/facility/#{facility_id1}/deactivate", "/#{account}/api/facility/#{facility_id2}/deactivate"],
        contactMech: [
          {
            contactMechId: '10093',
            contactMechTypeId: 'POSTAL_ADDRESS',
            address1: '123 Main St',
            city: 'Denver',
            stateProvinceGeoId: 'CO',
            postalCode: '12345',
            countryGeoId: 'USA'
          },
          {
            contactMechId: '10094',
            contactMechTypeId: 'POSTAL_ADDRESS'
          }
        ],
        facilityName: ['The Main Warehouse', 'A Warehouse'],
        parentFacilityUrl: [nil, "/#{account}/api/facility/10000"],
        shippingDisabled: [nil, true],
        actionUrlActivate: [nil, nil],
        receivingDisabled: [nil, true]
      }
    end
  end
end

