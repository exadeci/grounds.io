FactoryGirl.define do
  factory :ground do
    skip_create

    language 'python2'
    code 'print 42'

    factory :invalid_ground do
      language ''
    end

    factory :empty_ground do
      code nil
    end

    initialize_with { new(attributes) }
  end
end
