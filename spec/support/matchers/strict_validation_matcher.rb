matcher = ->(model) do
  begin
    model.valid?
    true
  rescue ActiveModel::StrictValidationFailed
    false
  end
end

RSpec::Matchers.define :pass_strict_validations do
  match(&matcher)
end

RSpec::Matchers.define :fail_strict_validations do
  match do |model|
    !matcher.call(model)
  end
end
