module TimeSubmissionHelper
  def field_error?(settings, field)
    settings && settings.invalid? && settings.errors.messages.key?(field)
  end
end
