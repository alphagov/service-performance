class RenameAgenciesToDeliveryOrganisations < ActiveRecord::Migration[5.0]
  def change
    rename_table :agencies, :delivery_organisations

    rename_column :calls_breakdown_metrics, :agency_code, :delivery_organisation_code
    rename_column :calls_received_metrics, :agency_code, :delivery_organisation_code
    rename_column :services, :agency_code, :delivery_organisation_code
    rename_column :transactions_received_metrics, :agency_code, :delivery_organisation_code
    rename_column :transactions_with_outcome_metrics, :agency_code, :delivery_organisation_code
  end
end
