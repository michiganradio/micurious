class CreateVotingRounds < ActiveRecord::Migration
  def change
    create_table :voting_rounds do |t|
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
