class GithubValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    return if valid_github?(value)
    record.errors[attribute] << (options[:message] || "is not a valid GitHub handle")
  end

  private

  def valid_github?(value)
    return false if value.include?("--")
    return false if value.start_with?("-")
    return false if value.end_with?("-")
    value =~ /\A[a-zA-Z0-9-]{1,39}\z/
  end
end
