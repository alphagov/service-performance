class AllowDeliveryOrganisationToNotHaveParentOrganisation < ActiveRecord::Migration[5.0]
  def change
    change_column_null :delivery_organisations, :department_code, true
  end
end
