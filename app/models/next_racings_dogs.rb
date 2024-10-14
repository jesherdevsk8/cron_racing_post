# frozen_string_literal: true

class NextRacingDog < ActiveRecord::Base
  self.table_name = 'next_racings_dogs'

  has_one :dog, foreign_key: 'dog_id', primary_key: 'id'

  def self.truncate_table
    ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 0;')
    NextRacingDog.delete_all # Remove todos os registros da tabela
    ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 1;')
  end
end
