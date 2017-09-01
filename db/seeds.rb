ActiveRecord::Base.transaction do
  # departments
  Department.create!(natural_key: 'D0001', name: 'Department for Environment Food & Rural Affairs', website: 'http://example.com/department-for-environment-food-and-rural-affairs')
  Department.create!(natural_key: 'D0002', name: 'Department for Transport', website: 'http://example.com/department-for-transport')
  Department.create!(natural_key: 'D0003', name: 'Department of Health', website: 'http://example.com/department-of-health')
  Department.create!(natural_key: 'D0004', name: 'HM Revenue & Customs', website: 'http://example.com/hm-revenue-and-customs')
  Department.create!(natural_key: 'D0005', name: 'Ministry of Justice', website: 'http://example.com/ministry-of-justice')
  Department.create!(natural_key: 'D0006', name: 'Department for Education', website: 'http://example.com/department-for-education')
  Department.create!(natural_key: 'D0007', name: 'Department for Business, Energy & Industrial Strategy', website: 'http://example.com/department-for-business-energy-and-industrial-strategy')

  # delivery organisations
  DeliveryOrganisation.create!(department_code: 'D0001', natural_key: '01', name: 'Environment Agency', website: 'http://example.com/environment-agency')
  DeliveryOrganisation.create!(department_code: 'D0003', natural_key: '02', name: 'NHS Blood and Transplant', website: 'http://example.com/nhs-blood-and-transplant')
  DeliveryOrganisation.create!(department_code: 'D0002', natural_key: '03', name: 'Driver and Vehicle Licensing Agency', website: 'http://example.com/driver-and-vehicle-licensing-agency')
  DeliveryOrganisation.create!(department_code: 'D0002', natural_key: '04', name: 'Driver and Vehicle Standards Agency', website: 'http://example.com/driver-and-vehicle-standards-agency')
  DeliveryOrganisation.create!(department_code: 'D0005', natural_key: '06', name: 'HM Courts & Tribunals Service', website: 'http://example.com/hm-courts-and-tribunals-service')
  # DeliveryOrganisation.create!(department_code: '', natural_key: '07', name: 'Her Majesty’s Prison & Probation Service', website: 'http://example.com/her-majestys-prison-and-probation-service')
  # DeliveryOrganisation.create!(department_code: '', natural_key: '08', name: 'Independent Police Complaints Commission', website: 'http://example.com/independent-police-complaints-comission')
  DeliveryOrganisation.create!(department_code: 'D0003', natural_key: '09', name: 'NHS England', website: 'http://example.com/nhs-england')
  # DeliveryOrganisation.create!(department_code: '', natural_key: '11', name: 'Ordnance Survey', website: 'http://example.com/ordnance-survey')
  DeliveryOrganisation.create!(department_code: 'D0006', natural_key: '12', name: 'Skills Funding Agency', website: 'http://example.com/skills-funding-agency')
  DeliveryOrganisation.create!(department_code: 'D0006', natural_key: '13', name: 'Student Loans Company', website: 'http://example.com/student-loans-company')
  # DeliveryOrganisation.create!(department_code: '', natural_key: '14', name: 'Land Registry', website: 'http://example.com/land-registry')
  # DeliveryOrganisation.create!(department_code: '', natural_key: '15', name: 'Companies House', website: 'http://example.com/companies-house')
  # DeliveryOrganisation.create!(department_code: '', natural_key: '16', name: 'Intellectual Property Office', website: 'http://example.com/intellectual-property-office')
  # DeliveryOrganisation.create!(department_code: '', natural_key: '17', name: 'Rural Payments Agency', website: 'http://example.com/rural-payments-agency')

  # services
  Service.create!(department_code: 'D0001', delivery_organisation_code: '01', natural_key: '01', name: 'Buy a fishing rod licence', hostname: 'buy-a-fishing-licence')
  Service.create!(department_code: 'D0002', delivery_organisation_code: '03', natural_key: '02', name: 'Apply for a provisional driving license', hostname: 'apply-for-a-provisional-driving-license')
  Service.create!(department_code: 'D0003', delivery_organisation_code: '02', natural_key: '03', name: 'Give blood', hostname: 'give-blood')
  Service.create!(department_code: 'D0006', delivery_organisation_code: '12', natural_key: '04', name: 'Search and apply for apprenticeship vacancies in England', hostname: 'search-and-apply-for-apprenticeship-vacancies-in-england')
  Service.create!(department_code: 'D0006', delivery_organisation_code: '12', natural_key: '05', name: 'Create a unique learner number', hostname: 'create-a-unique-learner-number')
  Service.create!(department_code: 'D0006', delivery_organisation_code: '12', natural_key: '06', name: 'Post an apprenticeship vacancy', hostname: 'post-an-apprenticeship-vacancy')
  Service.create!(department_code: 'D0006', delivery_organisation_code: '13', natural_key: '07', name: 'Apply for student finance', hostname: 'apply-for-student-finance')
  Service.create!(department_code: 'D0006', delivery_organisation_code: '13', natural_key: '08', name: 'Repay student loan voluntarily', hostname: 'repay-student-loan-voluntarily')
  Service.create!(department_code: 'D0006', delivery_organisation_code: '13', natural_key: '09', name: 'Apply for disabled student allowance', hostname: 'apply-for-disabled-student-allowance')
  Service.create!(department_code: 'D0006', delivery_organisation_code: '13', natural_key: '10', name: 'Apply for part time study support', hostname: 'apply-for-part-time-study-support')
  Service.create!(department_code: 'D0002', delivery_organisation_code: '04', natural_key: '11', name: 'Pay the Dartford Crossing Charge', hostname: 'pay-the-dartford-crossing-charge')
  Service.create!(department_code: 'D0002', delivery_organisation_code: '03', natural_key: '12', name: 'Tax your vehicle', hostname: 'tax-your-vehicle')
  Service.create!(department_code: 'D0002', delivery_organisation_code: '03', natural_key: '13', name: 'Make a change to a vehicle registration certificate', hostname: 'make-a-change-to-a-vehicle-registration-certificate')
  Service.create!(department_code: 'D0002', delivery_organisation_code: '03', natural_key: '14', name: "Check someone's driving information", hostname: 'check-someones-driving-information')
  Service.create!(department_code: 'D0002', delivery_organisation_code: '03', natural_key: '15', name: "Tell DVLA you've sold, transferred or bought a vehicle", hostname: 'tell-dvla-youve-sold-transferred-or-bought-a-vehicle')
  Service.create!(department_code: 'D0002', delivery_organisation_code: '04', natural_key: '16', name: 'Book a driving theory test', hostname: 'book-a-driving-theory-test')
  Service.create!(department_code: 'D0002', delivery_organisation_code: '04', natural_key: '17', name: 'Book a practical driving test', hostname: 'book-a-practical-driving-test')
  Service.create!(department_code: 'D0002', delivery_organisation_code: '04', natural_key: '18', name: 'Change a practical driving test booking', hostname: 'change-a-practical-driving-test-booking')
  Service.create!(department_code: 'D0004', delivery_organisation_code:  nil, natural_key: '19', name: 'State pension: existing claims', hostname: 'state-pension-existing-claims')
  Service.create!(department_code: 'D0004', delivery_organisation_code:  nil, natural_key: '20', name: 'Disability allowance: existing claims', hostname: 'disability-allowance-existing-claims')
  Service.create!(department_code: 'D0004', delivery_organisation_code:  nil, natural_key: '21', name: 'Education support allowance: existing claims', hostname: 'education-support-allowance-existing-claims')
  Service.create!(department_code: 'D0004', delivery_organisation_code:  nil, natural_key: '22', name: 'Pension credit: existing claims', hostname: 'pension-credit-existing-claims')
  Service.create!(department_code: 'D0004', delivery_organisation_code:  nil, natural_key: '23', name: 'Education support allowance: new claims', hostname: 'education-support-allowance-new-claims')
  Service.create!(department_code: 'D0003', delivery_organisation_code: '02', natural_key: '24', name: 'Changes to organ donor register', hostname: 'changes-to-organ-donor-register')
  Service.create!(department_code: 'D0003', delivery_organisation_code: '02', natural_key: '25', name: 'Register to donate organs', hostname: 'register-to-donate-organs')
  Service.create!(department_code: 'D0003', delivery_organisation_code: '09', natural_key: '26', name: 'NHS e-referrals', hostname: 'nhs-e-referrals')
  Service.create!(department_code: 'D0005', delivery_organisation_code:  nil, natural_key: '27', name: 'PAYE transactions', hostname: 'paye-transactions')
  Service.create!(department_code: 'D0005', delivery_organisation_code:  nil, natural_key: '28', name: 'Customs transactions', hostname: 'customs-transactions')
  Service.create!(department_code: 'D0005', delivery_organisation_code:  nil, natural_key: '29', name: 'VAT transactions', hostname: 'vat-transactions')
  Service.create!(department_code: 'D0005', delivery_organisation_code:  nil, natural_key: '30', name: 'Register for and file your Self Assessment tax return', hostname: 'register-for-and-file-your-self-assessment-tax-return')
  # Service.create!(department_code: 'D0007', delivery_organisation_code:  nil, natural_key: '31', name: 'Apply for lasting power of attorney', hostname: 'apply-for-lasting-power-of-attorney')
  # Service.create!(department_code: 'D0007', delivery_organisation_code: '06', natural_key: '32', name: 'Make a money claim online', hostname: 'make-a-money-claim-online')
  # Service.create!(department_code: 'D0007', delivery_organisation_code: '06', natural_key: '33', name: "Apply for the legal right to deal with the estate of someone who's died", hostname: 'apply-for-the-legal-right-to-deal-with-the-estate-of-someone-whos-died')
  # Service.create!(department_code: 'D0007', delivery_organisation_code: '07', natural_key: '34', name: 'Visit someone in prison', hostname: 'visit-someone-in-prison')
  # Service.create!(department_code: 'D0007', delivery_organisation_code: '08', natural_key: '35', name: 'Complain about the police', hostname: 'complain-about-the-police')
  # Service.create!(department_code:     nil, delivery_organisation_code: '11', natural_key: '36', name: 'Digital product subscriptions', hostname: 'digital-product-subscriptions')
  # Service.create!(department_code:     nil, delivery_organisation_code: '11', natural_key: '37', name: 'Physical product order fulfilment', hostname: 'physical-product-order-fulfilment')
  # Service.create!(department_code:     nil, delivery_organisation_code: '11', natural_key: '38', name: 'Digital product order fulfilment', hostname: 'digital-product-order-fulfilment')
  # Service.create!(department_code: 'D0009', delivery_organisation_code: '14', natural_key: '39', name: 'Updates to the Register', hostname: 'updates-to-the-register')
  # Service.create!(department_code: 'D0009', delivery_organisation_code: '14', natural_key: '40', name: 'Requests to Land Registry for official copies of records', hostname: 'requests-to-land-registry-for-official-copies-of-records')
  # Service.create!(department_code: 'D0009', delivery_organisation_code: '15', natural_key: '41', name: 'Companies House annual returns filed', hostname: 'companies-house-annual-returns-filed')
  # Service.create!(department_code: 'D0009', delivery_organisation_code: '15', natural_key: '42', name: 'Companies House accounts filed', hostname: 'companies-house-accounts-filed')
  # Service.create!(department_code: 'D0009', delivery_organisation_code: '16', natural_key: '43', name: 'Patent Renewals', hostname: 'patent-renewals')
  Service.create!(department_code: 'D0005', delivery_organisation_code:  nil, natural_key: '44', name: 'Stamp Duty Reserve Tax', hostname: 'stamp-duty-reserve-tax')
  # Service.create!(department_code: 'D0001', delivery_organisation_code: '17', natural_key: '45', name: 'Cattle Tracing System', hostname: 'cattle-tracing-system')

  [
    { service_code: '01', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000032 },
    { service_code: '01', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'paper', quantity: 1000004 },
    { service_code: '01', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 1000003 },
    { service_code: '02', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000050 },
    { service_code: '02', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 1000043 },
    { service_code: '03', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000031 },
    { service_code: '03', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'face-to-face', quantity: 1000020 },
    { service_code: '03', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 1000077 },
    { service_code: '04', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000011 },
    { service_code: '04', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'face-to-face', quantity: 1000007 },
    { service_code: '05', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000006 },
    { service_code: '06', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000045 },
    { service_code: '07', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000008 },
    { service_code: '07', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'paper', quantity: 1000010 },
    { service_code: '07', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 1000013 },
    { service_code: '08', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000099 },
    { service_code: '08', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 1000002 },
    { service_code: '08', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'paper', quantity: 1000077 },
    { service_code: '09', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000101 },
    { service_code: '09', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 1000089 },
    { service_code: '10', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000012 },
    { service_code: '10', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 1000002 },
    { service_code: '11', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 19999888 },
    { service_code: '11', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'other', quantity: 19987654 },
    { service_code: '12', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 37123768 },
    { service_code: '12', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'face-to-face', quantity: 5986365 },
    { service_code: '12', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 4123645 },
    { service_code: '13', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000008 },
    { service_code: '13', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'paper', quantity: 12658392 },
    { service_code: '14', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 5019274 },
    { service_code: '14', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 1000020 },
    { service_code: '14', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'paper', quantity: 999998 },
    { service_code: '15', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000008 },
    { service_code: '15', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'paper', quantity: 4198645 },
    { service_code: '15', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 1000011 },
    { service_code: '16', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 2111119 },
    { service_code: '16', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 1000007 },
    { service_code: '17', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 2456921 },
    { service_code: '17', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 1000045 },
    { service_code: '18', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000012 },
    { service_code: '18', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 1000003 },
    { service_code: '24', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000004 },
    { service_code: '24', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 2123456 },
    { service_code: '25', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000012 },
    { service_code: '25', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 1000108 },
    { service_code: '26', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000001 },
    { service_code: '26', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 10008980 },
    { service_code: '26', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'face-to-face', quantity: 2012983 },
    { service_code: '27', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 391657483 },
    { service_code: '27', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'paper', quantity: 10918273 },
    { service_code: '27', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 9098765 },
    { service_code: '28', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 146345678 },
    { service_code: '29', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 16987654 },
    { service_code: '29', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'other', quantity: 3123456 },
    { service_code: '30', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 11123456 },
    { service_code: '30', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'paper', quantity: 3999922 },
    # { service_code: '31', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000120 },
    # { service_code: '31', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'paper', quantity: 1000000 },
    # { service_code: '32', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000023 },
    # { service_code: '32', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'paper', quantity: 1000701 },
    # { service_code: '32', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 998789 },
    # { service_code: '33', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'paper', quantity: 1000120 },
    # { service_code: '34', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000109 },
    # { service_code: '34', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 989999 },
    # { service_code: '35', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000034 },
    # { service_code: '35', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 1000012 },
    # { service_code: '36', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 999009 },
    # { service_code: '37', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'other', quantity: 999999 },
    # { service_code: '38', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1000001 },
    # { service_code: '39', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 319111 },
    # { service_code: '39', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'paper', quantity: 32012 },
    # { service_code: '40', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 814109 },
    # { service_code: '40', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'paper', quantity: 6222 },
    # { service_code: '41', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 251021 },
    # { service_code: '41', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 3110 },
    # { service_code: '42', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 146002 },
    # { service_code: '42', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 34098 },
    # { service_code: '42', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'paper', quantity: 34111 },
    # { service_code: '43', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 3023 },
    # { service_code: '43', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'other', quantity: 29001 },
    # { service_code: '43', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'paper', quantity: 1213 },
    # { service_code: '44', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 104999876 },
    # { service_code: '45', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'online', quantity: 1521987 },
    # { service_code: '45', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'paper', quantity: 132876 },
    # { service_code: '45', starts_on: '2017-05-01', ends_on: '2017-05-31', channel: 'phone', quantity: 75001 }
  ].each do |transaction_received_metric|
    service = Service.where(natural_key: transaction_received_metric[:service_code]).first!

    TransactionsReceivedMetric.create!(
      department_code: service.department_code,
      delivery_organisation_code: service.delivery_organisation_code,
      service_code: service.natural_key,
      starts_on: transaction_received_metric[:starts_on],
      ends_on: Date.parse(transaction_received_metric[:ends_on]) + 1.day,
      channel: transaction_received_metric[:channel],
      quantity: transaction_received_metric[:quantity]
    )
  end

  [
    { service_code: '01', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 2435098 },
    { service_code: '01', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 2400000 },
    { service_code: '02', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 1735098 },
    { service_code: '02', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 1500000 },
    { service_code: '03', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 2999765 },
    { service_code: '03', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 2000777 },
    { service_code: '04', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 1888325 },
    { service_code: '04', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 1321827 },
    { service_code: '05', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 896102 },
    { service_code: '05', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 716881 },
    { service_code: '06', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 900321 },
    { service_code: '06', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 540192 },
    { service_code: '07', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 2108398 },
    { service_code: '07', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 1792138 },
    { service_code: '08', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 2754098 },
    { service_code: '08', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 2340983 },
    { service_code: '09', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 1872999 },
    { service_code: '09', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 1685699 },
    { service_code: '10', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 1699999 },
    { service_code: '10', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 1138999 },
    { service_code: '11', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 36654190 },
    { service_code: '11', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 28223726 },
    { service_code: '12', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 46098876 },
    { service_code: '12', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 37801078 },
    { service_code: '13', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 12129921 },
    { service_code: '13', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 9825236 },
    { service_code: '14', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 5980761 },
    { service_code: '14', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 5801338 },
    { service_code: '15', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 4897987 },
    { service_code: '15', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 3722470 },
    { service_code: '16', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 2214567 },
    { service_code: '16', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 1107283 },
    { service_code: '17', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 2987599 },
    { service_code: '17', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 2658963 },
    { service_code: '18', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 1888789 },
    { service_code: '18', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 1681022 },
    { service_code: '24', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 2975863 },
    { service_code: '24', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 2559242 },
    { service_code: '25', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 1293847 },
    { service_code: '25', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 1255031 },
    { service_code: '26', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 12012345 },
    { service_code: '26', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 9609876 },
    { service_code: '27', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 392000001 },
    { service_code: '27', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 333200000 },
    { service_code: '28', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 139000222 },
    { service_code: '28', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 125100199 },
    { service_code: '29', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 18002002 },
    { service_code: '29', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 14221581 },
    { service_code: '30', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'any', quantity: 13000210 },
    { service_code: '30', starts_on: '2017-05-01', ends_on: '2017-05-31', outcome: 'intended', quantity: 12610203 },
  ].each do |transaction_with_outcome_metric|
    service = Service.where(natural_key: transaction_with_outcome_metric[:service_code]).first!

    TransactionsWithOutcomeMetric.create!(
      department_code: service.department_code,
      delivery_organisation_code: service.delivery_organisation_code,
      service_code: service.natural_key,
      starts_on: transaction_with_outcome_metric[:starts_on],
      ends_on: Date.parse(transaction_with_outcome_metric[:ends_on]) + 1.day,
      outcome: transaction_with_outcome_metric[:outcome],
      quantity: transaction_with_outcome_metric[:quantity]
    )
  end

  Service.update_all(
    start_page_url: 'https://example.com',
    paper_form_url: 'https://example.com',
    purpose: 'Why the service was built, its policy objectives and the user need it meets.',
    how_it_works: 'The processes and back-office operations that allow the service to operate.',
    typical_users: 'Each of the service’s key user groups with their respective demographic, geographic distribution and other relevant details.',
    frequency_used: 'On average, how often each of the key user groups uses the service.',
    duration_until_outcome: 'The average amount of time for each of the key user groups that it takes for a received transaction to end in an outcome.'
  )
end
