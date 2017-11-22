module JavascriptHelper
  def with_conditional_javascript(&block)
    examples = -> do
      let(:javascript_enabled) { |example| example.metadata[:js] }

      instance_eval(&block)
    end

    context('with javascript', js: true, &examples)
    context('without javascript', js: false, &examples)
  end
end

RSpec.configure do |config|
  config.extend(JavascriptHelper, type: :feature)
end
