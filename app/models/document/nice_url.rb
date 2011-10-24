module Document::NiceUrl
  def to_param
    "#{id}-#{customer.parameterize}-#{supplier.parameterize}-#{name[0..20].parameterize}"
  end
end