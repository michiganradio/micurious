json.array!(@admin_categories) do |admin_category|
  json.extract! admin_category, :name, :label, :active
  json.url admin_category_url(admin_category, format: :json)
end
