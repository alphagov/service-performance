require 'rails_helper'

RSpec.describe MetricChartHelper, type: :helper do
  describe '#calculate_transaction_difference' do
    it 'outputs transaction difference for an increased number of transactions' do
      current_metrics = [0, 2, 3, 5, 0, 4, 0, 2, 0, 4, 0, 0]
      previous_metrics = [0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 3, 1]
      output = calculate_transaction_difference(current_metrics, previous_metrics, "transactions received")

      expect(output).to eq("10 (50.0%) more transactions received than previous 12 months")
    end

    it 'outputs transaction difference for a decreased number of transactions' do
      current_metrics = [0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 3, 1]
      previous_metrics = [0, 2, 3, 5, 0, 4, 0, 2, 0, 4, 0, 0]
      output = calculate_transaction_difference(current_metrics, previous_metrics, "transactions received")

      expect(output).to eq("10 (50.0%) less transactions received than previous 12 months")
    end

    it 'outputs transaction difference when no change in number of transactions' do
      current_metrics = [0, 1, 0, 0, 0, 3, 0, 2, 0, 0, 4, 0]
      previous_metrics = [0, 4, 0, 2, 0, 0, 0, 0, 1, 3, 0, 0]
      output = calculate_transaction_difference(current_metrics, previous_metrics, "transactions received")

      expect(output).to eq("Same number of transactions received as previous 12 months")
    end

    it 'outputs transaction difference when metric sum is 0' do
      current_metrics = [0, 1, 0, 0, 0, 3, 0, 2, 0, 0, 4, 0]
      previous_metrics = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      output = calculate_transaction_difference(current_metrics, previous_metrics, "transactions received")
      expect(output).to eq("10 (100.0%) more transactions received than previous 12 months")
    end
  end

  describe '#set_li_arrow_direction' do
    it 'outputs a value to be used to set a html class, when there is an increased number of transactions' do
      current_metrics = [0, 2, 3, 5, 0, 4, 0, 2, 0, 4, 0, 0]
      previous_metrics = [0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 3, 1]
      output = set_li_arrow_direction(current_metrics, previous_metrics)

      expect(output).to eq("increase")
    end

    it 'outputs a value to be used to set a html class, when there is a decreased number of transactions' do
      current_metrics = [0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 3, 1]
      previous_metrics = [0, 2, 3, 5, 0, 4, 0, 2, 0, 4, 0, 0]
      output = set_li_arrow_direction(current_metrics, previous_metrics)

      expect(output).to eq("decrease")
    end

    it 'outputs a value to be used to set a html class, when there is no change in number of transactions' do
      current_metrics = [0, 1, 0, 0, 0, 3, 0, 2, 0, 0, 4, 0]
      previous_metrics = [0, 4, 0, 2, 0, 0, 0, 0, 1, 3, 0, 0]
      output = set_li_arrow_direction(current_metrics, previous_metrics)

      expect(output).to eq(nil)
    end
  end
end
