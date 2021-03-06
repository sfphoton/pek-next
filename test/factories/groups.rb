FactoryBot.define do
  factory :group do
    name { 'Babhámozó' }
    type { 'szakmai kör' }

    after(:create) do |group|
      group.memberships << create(:membership, :leader, group: group)
    end

    trait :with_additional_info do
      description { 'vietnámiak' }
      webpage { 'http://babhamozo.sch.bme.hu' }
      maillist { 'babhamozo@sch.bme.hu' }
      founded { 1998 }
    end
  end
end
