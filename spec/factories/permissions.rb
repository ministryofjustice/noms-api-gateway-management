FactoryGirl.define do
  factory :permission, class: Permission do
    name 'health'
    regex '^\\/nomisapi\\/health$'
    token { Token.any? ? Token.first : create(:token) }
    position do
      Permission.any? ? Permission.all.sort_by(&:position).last.position + 100 : 100
    end
  end
end
