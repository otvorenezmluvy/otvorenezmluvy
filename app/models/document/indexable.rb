module Document::Indexable
  extend ActiveSupport::Concern

  def to_indexable
    serializable_hash(
        :include => {:attachments => {:include => :pages}, :matching_heuristics => {}},
        :methods => [
            :department, :supplier, :total_amount, :customer, :published_on, :expires_on,
            :points, :attachments_count, :total_pages_count, :appendixes_count, :supplier_age, :legal_form, :ownership_category, :supplier_nace,
            :comments_count, :source,
            :watcher_ids, :opener_ids
        ]
    )
  end

  module ClassMethods
    def index_settings
      {
          :settings => {:number_of_shards => 1},
          :mappings => mapping
      }
    end

    def mapping
      {
          :page => {
              :properties => {
                  :id => {
                      :type => :long
                  },
                  :text => {
                      :store => :yes,
                      :analyzer => :eulang,
                      :type => :string
                  },
                  :attachment_id => {
                      :type => :long
                  },
                  :attachment => {
                      :properties => {
                          :number => {
                              :type => :long
                          },
                          :document_id => {
                              :type => :long
                          }
                      }
                  },
              }
          },
          :document => {
              :properties => {
                  :total_amount => {
                      :store => :yes,
                      :type => :float
                  },
                  :matching_heuristics => {
                      :properties => {
                          :name => {
                              :type => :string,
                              :store => :yes,
                              :index => :not_analyzed,
                              :include_in_all => false
                          },
                          :serialized_search_parameters => {
                              :type => :string,
                              :store => :yes,
                              :index => :not_analyzed,
                              :include_in_all => false
                          },
                          :created_at => {
                              :type => :date,
                              :format => :dateOptionalTime,
                              :include_in_all => false
                          },
                          :updated_at => {
                              :type => :date,
                              :format => :dateOptionalTime,
                              :include_in_all => false
                          },
                          :id => {
                              :type => :long,
                              :include_in_all => false
                          },
                          :explanation => {
                              :type => :string,
                              :include_in_all => false
                          },
                          :formula => {
                              :type => :string,
                              :include_in_all => false
                          },
                          :points => {
                              :type => :integer,
                              :include_in_all => false

                          }
                      },
                  },
                  :contracted_amount => {
                      :type => :float
                  },
                  :legal_form => {
                      :type => :multi_field,
                      :fields => {
                          :legal_form => {
                              :store => :yes,
                              :analyzer => :eulang,
                              :boost => 10.0,
                              :type => :string
                          },
                          :untouched => {
                              :include_in_all => false,
                              :index => :not_analyzed,
                              :type => :string
                          }
                      }
                  },
                  :ownership_category => {
                      :type => :multi_field,
                      :fields => {
                          :ownership_category => {
                              :store => :yes,
                              :analyzer => :eulang,
                              :boost => 10.0,
                              :type => :string
                          },
                          :untouched => {
                              :include_in_all => false,
                              :index => :not_analyzed,
                              :type => :string
                          }
                      }
                  },
                  :department => {
                      :type => :multi_field,
                      :fields => {
                          :department => {
                              :store => :yes,
                              :analyzer => :eulang,
                              :boost => 10.0,
                              :type => :string
                          },
                          :untouched => {
                              :include_in_all => false,
                              :index => :not_analyzed,
                              :type => :string
                          }
                      }
                  },
                  :published_on => {
                      :format => :dateOptionalTime,
                      :type => :date
                  },
                  :supplier_ico => {
                      :type => :long
                  },
                  :crz_id => {
                      :type => :long
                  },
                  :points => {
                      :type => :long,
                      :store => :yes
                  },
                  :supplier_age => {
                      :type => :long,
                      :store => :yes
                  },
                  :customer => {
                      :type => :multi_field,
                      :fields => {
                          :untouched => {
                              :include_in_all => false,
                              :index => :not_analyzed,
                              :type => :string
                          },
                          :customer => {
                              :store => :yes,
                              :analyzer => :eulang,
                              :boost => 10.0,
                              :type => :string
                          }
                      }
                  },
                  :id => {
                      :type => :long
                  },
                  :updated_at => {
                      :format => :dateOptionalTime,
                      :type => :date
                  },
                  :effective_from => {
                      :format => :dateOptionalTime,
                      :type => :date
                  },
                  :name => {
                      :type => :multi_field,
                      :fields => {
                          :name => {
                              :store => :yes,
                              :analyzer => :eulang,
                              :boost => 10.0,
                              :type => :string
                          },
                          :untouched => {
                              :include_in_all => false,
                              :index => :not_analyzed,
                              :type => :string
                          }
                      }
                  },
                  :emitter => {
                      :include_in_all => false,
                      :analyzer => :eulang,
                      :type => :string
                  },
                  :source => {
                      :type => :multi_field,
                      :fields => {
                          :untouched => {
                              :include_in_all => false,
                              :index => :not_analyzed,
                              :type => :string
                          }
                      }
                  },
                  :supplier_nace => {
                      :type => :multi_field,
                      :fields => {
                          :supplier_nace => {
                              :include_in_all => false,
                              :store => :yes,
                              :analyzer => :eulang,
                              :boost => 10.0,
                              :type => :string
                          },
                          :untouched => {
                              :include_in_all => false,
                              :index => :not_analyzed,
                              :type => :string
                          }
                      }
                  },
                  :created_at => {
                      :format => :dateOptionalTime,
                      :type => :date
                  },
                  :attachments => {
                      :properties => {
                          :id => {
                              :type => :long
                          },
                          :updated_at => {
                              :format => :dateOptionalTime,
                              :type => :date
                          },
                          :document_id => {
                              :type => :long
                          },
                          :comments_count => {
                              :type => :long,
                              :store => :yes,
                              :include_in_all => false
                          },
                          :pages => {
                              :properties => {
                                  :id => {
                                      :type => :long
                                  },
                                  :text => {
                                      :store => :yes,
                                      :analyzer => :eulang,
                                      :type => :string
                                  },
                                  :updated_at => {
                                      :format => :dateOptionalTime,
                                      :type => :date
                                  },
                                  :attachment_id => {
                                      :type => :long
                                  },
                                  :created_at => {
                                      :format => :dateOptionalTime,
                                      :type => :date
                                  },
                                  :number => {
                                      :type => :long
                                  }
                              }
                          },
                          :created_at => {
                              :format => :dateOptionalTime,
                              :type => :date
                          },
                          :crz_doc_id => {
                              :type => :long
                          }
                      }
                  },
                  :expires_on => {
                      :format => :dateOptionalTime,
                      :type => :date
                  },
                  :identifier => {
                      :index => :not_analyzed,
                      :type => :string
                  },
                  :supplier => {
                      :type => :multi_field,
                      :fields => {
                          :untouched => {
                              :include_in_all => false,
                              :index => :not_analyzed,
                              :type => :string
                          },
                          :supplier => {
                              :store => :yes,
                              :analyzer => :eulang,
                              :boost => 10.0,
                              :type => :string
                          }
                      }
                  },
                  :note => {
                      :analyzer => :eulang,
                      :type => :string
                  },
                  :appendixes_count => {
                      :type => :integer,
                      :store => :yes,
                      :include_in_all => false
                  },
                  :comments_count => {
                      :type => :integer,
                      :store => :yes,
                      :include_in_all => false
                  },
                  :total_pages_count => {
                      :type => :integer,
                      :store => :yes,
                      :include_in_all => false
                  },
                  :attachments_count => {
                      :type => :integer,
                      :store => :yes,
                      :include_in_all => false
                  },
                  :watcher_ids => {:type => :long, :include_in_all => false},
                  :opener_ids => {:type => :long, :include_in_all => false}
              },
              :_all => {
                  :analyzer => :eulang
              }
          }
      }
    end
  end
end
