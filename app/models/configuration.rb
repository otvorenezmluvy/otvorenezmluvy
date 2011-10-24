class Configuration < Settingslogic
  extend ActiveSupport::Memoizable

  source "#{Rails.root}/config/crowdcloud.yml"
  namespace Rails.env

  def documents_repository
    DocumentsRepository.new(documents_index, AsyncHeuristicListener.new(Resque), pages_repository)
  end

  def pages_repository
    PagesRepository.new(pages_index)
  end

  def normalize_points_to
    Heuristic.all.reduce(0) { |sum, heuristic| sum + (heuristic.has_formula? ? 0 : heuristic.points) }
  end
  memoize :normalize_points_to

  def facets
    [
        Factic::FulltextFacet.new(:q),
        Factic::SearchableTermsFacet.new(:supplier),
        Factic::SearchableTermsFacet.new(:department),
        Factic::SearchableTermsFacet.new(:customer),
        Factic::DateFacet.new(:published_on),
        Factic::RangeFacet.new(:expires_on, [Date.civil(2011, 1, 1)..Date.civil(2012, 12, 31),
                                             Date.civil(2012, 1, 1)..Date.civil(2015, 12, 31),
                                             Date.civil(2016, 1, 1)..Date.civil(2020, 12, 31)]),
        Factic::RangeFacet.new(:total_amount, [0..1,1..10, 10..100, 100..1000, 1000..10_000, 10_000..100_000]),
        Factic::RangeFacet.new(:supplier_age, [1..30, 30..90, 90..365, 365..2*365, 2*365..3*365, 3*365..5*365]),
        Factic::RangeFacet.new(:attachments_count, [0..1, 1..2, 2..3, 3..5]),
        Factic::RangeFacet.new(:appendixes_count, [0..1, 1..2, 2..3, 3..5]),
        Factic::RangeFacet.new(:total_pages_count, [1..3, 3..5, 5..10, 10..50, 50..100]),
        Factic::RangeFacet.new(:comments_count, [1..3, 3..5, 5..10, 10..50, 50..100]),
        Factic::NormalizedRangeFacet.new(:points, [1..2, 2..3, 3..4, 4..5, 5..6, 6..7, 7..8, 8..9], :normalized_to => normalize_points_to),
        Factic::SearchableTermsFacet.new(:legal_form),
        Factic::SearchableTermsFacet.new(:ownership_category),
        Factic::SearchableTermsFacet.new(:supplier_nace),
        Factic::SearchableTermsFacet.new(:source),
        Factic::StatisticalFacet.new(:total_amount)
    ]
  end

  def factic
    Factic.new(
        documents_repository,
        :facets => facets,
        :fields => [:id, :name, :department, :total_amount, :supplier, :customer, :published_on, :points, "matching_heuristics.name", "matching_heuristics.serialized_search_parameters"],
        :sort_fields => [:published_on, :total_amount, :points],
        :highlight => {
            :name => {:number_of_fragments => 0},
            :department => {:number_of_fragments => 0},
            :customer => {:number_of_fragments => 0},
            :supplier => {:number_of_fragments => 0}
        }
    )
  end

  private
  def pages_index
    ElasticRecordIndex.new(Page, index_name, elasticsearch)
  end

  def documents_index
    ElasticRecordIndex.new(Document, index_name, elasticsearch)
  end
end
