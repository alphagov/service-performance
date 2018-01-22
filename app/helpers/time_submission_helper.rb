module TimeSubmissionHelper
  def field_error?(settings, fields)
    return false if !settings || settings.valid?
    check_errors = fields.map do |field|
      settings.errors.messages.key?(field)
    end
    check_errors.any?
  end
end
