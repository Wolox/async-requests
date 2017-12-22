class CreateAsyncRequestJobs < ActiveRecord::Migration
  def change
    create_table :async_request_jobs do |t|
      t.string :worker
      t.integer :status
      t.integer :status_code
      t.text :response
      t.string :uid
      t.text :params

      t.timestamps null: false
    end
    add_index :async_request_jobs, :status
    add_index :async_request_jobs, :uid, unique: true
  end
end
