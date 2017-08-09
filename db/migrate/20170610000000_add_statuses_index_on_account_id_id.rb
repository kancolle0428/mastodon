class AddStatusesIndexOnAccountIdId < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def change
    # Statuses queried by account_id are often sorted by id. Querying statuses
    # of an account to show them in his status page is one of the most
    # significant examples.
    # Add this index to improve the performance in such cases.
    add_index 'statuses', ['account_id', 'id'],  name: 'index_statuses_on_account_id_id'

    remove_index 'statuses', column: 'account_id', name: 'index_statuses_on_account_id'
  end
end
