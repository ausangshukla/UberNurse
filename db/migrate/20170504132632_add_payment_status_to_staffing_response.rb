class AddPaymentStatusToStaffingResponse < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_responses, :payment_status, :string, limit: 10
  end
end
