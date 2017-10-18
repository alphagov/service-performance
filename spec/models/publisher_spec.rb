require 'rails_helper'

RSpec.describe Publisher, type: :model do
  describe '#publishing actual data' do
    it 'marks monthly service metrics as published' do
      department = FactoryGirl.create(:department)
      service = FactoryGirl.create(:service, department: department)

      metrics = FactoryGirl.build(:monthly_service_metrics, service_id: service.id, month: YearMonth.new(2017, 11))
      Publisher.publish(metrics)

      expect(metrics.published).to eq(true)
    end

    it 'creates API models' do
      department = FactoryGirl.create(:department)
      service = FactoryGirl.create(:service, department: department)

      metrics = FactoryGirl.build(:monthly_service_metrics,
        service_id: service.id,
        month: YearMonth.new(2017, 11),
        calls_received: 100,
        online_transactions: 200,
        phone_transactions: 201,
        transactions_with_outcome: 300)

      Publisher.publish(metrics)

      calls = CallsReceivedMetric.where(starts_on: "2017-11-01".to_date, item: "total").first
      expect(calls).to_not be_nil
      expect(calls.quantity).to eq(100)

      online_trxn = TransactionsReceivedMetric.where(starts_on: "2017-11-01".to_date, channel: "online").first
      expect(online_trxn).to_not be_nil
      expect(online_trxn.quantity).to eq(200)

      phone_trxn = TransactionsReceivedMetric.where(starts_on: "2017-11-01".to_date, channel: "phone").first
      expect(phone_trxn).to_not be_nil
      expect(phone_trxn.quantity).to eq(201)

      outcomes = TransactionsWithOutcomeMetric.where(starts_on: "2017-11-01".to_date, outcome: "any").first
      expect(outcomes).to_not be_nil
      expect(outcomes.quantity).to eq(300)
    end

    it 'expects values to be not_provided (aka nil) if no metrics given' do
      department = FactoryGirl.create(:department)
      service = FactoryGirl.create(:service, department: department)

      metrics = FactoryGirl.build(:monthly_service_metrics,
        service_id: service.id,
        month: YearMonth.new(2017, 11))

      Publisher.publish(metrics)

      calls = CallsReceivedMetric.where(service_code: service.natural_key, starts_on: "2017-11-01".to_date)
      calls.each do |c|
        expect(c.quantity).to be_nil
      end
      expect(calls.length).to eq(6)

      trxns = TransactionsReceivedMetric.where(service_code: service.natural_key, starts_on: "2017-11-01".to_date)
      trxns.each do |t|
        expect(t.quantity).to be_nil
      end
      expect(trxns.length).to eq(5)
    end

    it 'expects values to be missing if not applicable' do
      department = FactoryGirl.create(:department)
      service = FactoryGirl.create(:service, department: department,
                                   online_transactions_applicable: false,
                                   phone_transactions_applicable: false,
                                   paper_transactions_applicable: false,
                                   face_to_face_transactions_applicable: false,
                                   other_transactions_applicable: false,
                                   transactions_with_outcome_applicable: false,
                                   transactions_with_intended_outcome_applicable: false,
                                   calls_received_applicable: false,
                                   calls_received_get_information_applicable: false,
                                   calls_received_chase_progress_applicable: false,
                                   calls_received_challenge_decision_applicable: false,
                                   calls_received_other_applicable: false,
                                   calls_received_perform_transaction_applicable: false)

      metrics = FactoryGirl.build(:monthly_service_metrics,
        service_id: service.id,
        month: YearMonth.new(2017, 11))

      Publisher.publish(metrics)

      calls = CallsReceivedMetric.where(service_code: service.natural_key, starts_on: "2017-11-01".to_date).count
      expect(calls).to eq(0)

      trxns = TransactionsReceivedMetric.where(service_code: service.natural_key, starts_on: "2017-11-01".to_date).count
      expect(trxns).to eq(0)

      outcomes = TransactionsWithOutcomeMetric.where(service_code: service.natural_key, starts_on: "2017-11-01".to_date).count
      expect(outcomes).to eq(0)
    end

    it 'expects only calls if only calls are applicable' do
      department = FactoryGirl.create(:department)
      service = FactoryGirl.create(:service, department: department,
                                   online_transactions_applicable: false,
                                   phone_transactions_applicable: false,
                                   paper_transactions_applicable: false,
                                   face_to_face_transactions_applicable: false,
                                   other_transactions_applicable: false,
                                   transactions_with_outcome_applicable: false,
                                   transactions_with_intended_outcome_applicable: false)

      metrics = FactoryGirl.build(:monthly_service_metrics,
        service_id: service.id,
        month: YearMonth.new(2017, 11))

      Publisher.publish(metrics)

      calls = CallsReceivedMetric.where(service_code: service.natural_key, starts_on: "2017-11-01".to_date).count
      expect(calls).to eq(6)

      trxns = TransactionsReceivedMetric.where(service_code: service.natural_key, starts_on: "2017-11-01".to_date).count
      expect(trxns).to eq(0)

      outcomes = TransactionsWithOutcomeMetric.where(service_code: service.natural_key, starts_on: "2017-11-01".to_date).count
      expect(outcomes).to eq(0)
    end
  end
end
