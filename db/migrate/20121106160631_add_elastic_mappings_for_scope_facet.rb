class AddElasticMappingsForScopeFacet < ActiveRecord::Migration
  def up
    Configuration.documents_repository.remap
  end

  def down
  end
end
