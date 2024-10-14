# frozen_string_literal: true

class NextRacing < ActiveRecord::Base
  has_many :next_racing_dogs, foreign_key: 'next_racings_id', primary_key: 'id'

  def self.truncate_table
    ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 0;')
    NextRacingDog.delete_all # Remove todos os registros da tabela
    ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 1;')
  end
end
