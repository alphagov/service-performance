class DepartmentDataPresenterSerializer < ActiveModel::Serializer
  attributes :department,
             :transactions_received_online,
             :transactions_received_phone,
             :transactions_received_paper,
             :transactions_received_face_to_face,
             :transactions_received_other,
             :transactions_ending_any_outcome,
             :transactions_ending_user_intended_outcome

  belongs_to :department
end
