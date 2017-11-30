FactoryGirl.define do
  factory :permission, class: Permission do
    regex '^\\/nomisapi\\/health$'
    position do
      Permission.any? ? Permission.all.sort_by(&:position).last.position + 100 : 100
    end
  end
end
