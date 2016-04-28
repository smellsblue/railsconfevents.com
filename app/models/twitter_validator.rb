class TwitterValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    return if value =~ /\A[a-zA-Z0-9_]{1,15}\z/
    record.errors[attribute] << (options[:message] || "is not a valid Twitter handle")
  end
end
