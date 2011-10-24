class Heuristic < ActiveRecord::Base
  def search_parameters=(params)
    self.serialized_search_parameters = params.to_json
  end

  def search_parameters
    ActiveSupport::JSON.decode(serialized_search_parameters).with_indifferent_access
  end

  def self.find_or_initialize_by_search_parameters(params)
    find_or_initialize_by_serialized_search_parameters(params.to_json)
  end

  def self.find_matching_heuristics(index, document)
    identifiers = index.percolate(document)
    find_all_by_identifiers(identifiers)
  end

  def register(index, translator)
    index.register_percolator(identifier, create_search(translator))
  end

  def create_search(translator)
    translator.create_restrictions_search(search_parameters).to_scrollable
  end

  def on(document)
    Formula.new(document, formula)
  end

  def has_formula?
    formula.to_i.to_s != formula
  end

  def points
    formula.to_i
  end

  private
  def identifier
    "heuristic-#{id}"
  end

  def self.find_all_by_identifiers(identifiers)
    ids = identifiers.collect do |identifier|
      identifier.split('-').last.to_i
    end
    find_all_by_id(ids)
  end

  class Formula
    def initialize(context, formula)
      @context = context
      @formula = formula
    end

    def points
      replace_variables!
      eval(@formula).to_i
    end

    private

    def replace_variables!
      @formula.gsub!(/\$[a-z_]+/) do |variable|
        @context.send remove_leading_dollar(variable)
      end
    end

    def remove_leading_dollar(variable)
      variable[1..-1]
    end
  end
end
