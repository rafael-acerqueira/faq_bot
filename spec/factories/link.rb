FactoryGirl.define do
  factory :link do
    title FFaker::Lorem.word
    url FFaker::Internet.http_url
  end
end
