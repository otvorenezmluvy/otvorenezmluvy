# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121106160631) do

  create_table "attachments", :force => true do |t|
    t.integer  "document_id", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "type",        :null => false
    t.string   "name"
    t.integer  "number",      :null => false
  end

  add_index "attachments", ["document_id"], :name => "index_document_attachments_on_document_id"

  create_table "banned_ips", :force => true do |t|
    t.string   "ip",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
  end

  add_index "banned_ips", ["ip"], :name => "index_banned_ips_on_ip", :unique => true

  create_table "comment_reports", :force => true do |t|
    t.integer  "comment_id", :null => false
    t.integer  "user_id"
    t.text     "body",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comment_reports", ["comment_id"], :name => "index_comment_reports_on_comment_id"

  create_table "comments", :force => true do |t|
    t.text     "comment"
    t.text     "area"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "document_id",                       :null => false
    t.integer  "parent_id"
    t.integer  "votes",          :default => 0,     :null => false
    t.integer  "flags",          :default => 0
    t.boolean  "mail_sent",      :default => false
    t.datetime "censored_at"
    t.integer  "reports_count",  :default => 0,     :null => false
    t.integer  "censored_by_id"
  end

  add_index "comments", ["page_id"], :name => "index_comments_on_page_id"
  add_index "comments", ["parent_id"], :name => "index_comments_on_parent_id"
  add_index "comments", ["user_id", "created_at"], :name => "user_idx"

  create_table "crz_appendix_connections", :force => true do |t|
    t.integer "document_id", :null => false
    t.integer "crz_id",      :null => false
  end

  add_index "crz_appendix_connections", ["document_id"], :name => "index_crz_appendix_connections_on_document_id"

  create_table "crz_attachment_details", :force => true do |t|
    t.integer "attachment_id",                 :null => false
    t.integer "crz_doc_id"
    t.integer "crz_text_id"
    t.text    "note"
    t.string  "base_text_name",  :limit => 50
    t.string  "base_image_name", :limit => 50
  end

  add_index "crz_attachment_details", ["crz_doc_id"], :name => "index_crz_attachment_details_on_crz_doc_id", :unique => true

  create_table "crz_document_details", :force => true do |t|
    t.integer  "crz_id",                                           :null => false
    t.string   "identifier",                                       :null => false
    t.string   "department"
    t.string   "customer",                                         :null => false
    t.string   "supplier",                                         :null => false
    t.integer  "supplier_ico"
    t.decimal  "contracted_amount", :precision => 12, :scale => 2
    t.decimal  "total_amount",      :precision => 12, :scale => 2
    t.text     "note"
    t.date     "published_on"
    t.date     "effective_from"
    t.date     "expires_on"
    t.integer  "contract_crz_id"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "emitter"
    t.integer  "document_id",                                      :null => false
    t.string   "status"
  end

  add_index "crz_document_details", ["contract_crz_id"], :name => "index_crz_document_details_on_contract_crz_id"
  add_index "crz_document_details", ["crz_id"], :name => "index_documents_on_crz_id", :unique => true
  add_index "crz_document_details", ["document_id"], :name => "index_crz_document_details_on_document_id"

  create_table "deleted_comments", :id => false, :force => true do |t|
    t.integer  "id"
    t.text     "comment"
    t.text     "area"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "document_id"
    t.integer  "parent_id"
    t.integer  "votes"
    t.integer  "flags"
    t.boolean  "mail_sent"
  end

  create_table "document_openings", :force => true do |t|
    t.integer  "document_id", :null => false
    t.integer  "user_id",     :null => false
    t.datetime "created_at",  :null => false
  end

  add_index "document_openings", ["document_id"], :name => "index_document_openings_on_document_id"
  add_index "document_openings", ["user_id"], :name => "index_document_openings_on_user_id"

  create_table "documents", :force => true do |t|
    t.string   "name",       :limit => 1000
    t.string   "type",                       :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "documents", ["created_at"], :name => "index_on_created_at"

  create_table "documents_heuristics", :id => false, :force => true do |t|
    t.integer "document_id",  :null => false
    t.integer "heuristic_id", :null => false
  end

  add_index "documents_heuristics", ["document_id"], :name => "index_documents_heuristics_on_document_id"

  create_table "egovsk_attachment_details", :force => true do |t|
    t.integer "attachment_id",          :null => false
    t.integer "egovsk_doc_id",          :null => false
    t.integer "egovsk_doc2_id",         :null => false
    t.string  "egovsk_attachment_type"
  end

  create_table "egovsk_document_details", :force => true do |t|
    t.integer  "egovsk_id",                                                        :null => false
    t.decimal  "total_amount",                      :precision => 12, :scale => 2
    t.string   "customer",                                                         :null => false
    t.string   "supplier",                                                         :null => false
    t.integer  "supplier_ico",         :limit => 8
    t.text     "note"
    t.date     "signed_on"
    t.date     "published_on"
    t.date     "effective_from"
    t.date     "valid_from"
    t.date     "expires_on"
    t.string   "contract_number"
    t.string   "root_contract_number"
    t.string   "contract_type"
    t.string   "periodicity"
    t.integer  "document_id",                                                      :null => false
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.integer  "customer_id"
    t.string   "founder"
  end

  add_index "egovsk_document_details", ["customer_id"], :name => "index_egovsk_document_details_on_customer_id"
  add_index "egovsk_document_details", ["document_id"], :name => "index_egovsk_document_details_on_document_id"
  add_index "egovsk_document_details", ["egovsk_id"], :name => "index_egovsk_document_details_on_egovsk_id", :unique => true

  create_table "events", :force => true do |t|
    t.integer  "for_user_id",   :null => false
    t.integer  "external_id"
    t.string   "external_type"
    t.string   "type",          :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "events", ["for_user_id", "created_at"], :name => "index_events_on_for_user_id_and_created_at"

  create_table "ft_vvo_contracts", :force => true do |t|
    t.string "document_id"
    t.string "document_code"
    t.string "contract_key"
    t.string "document_type_code"
    t.string "vz_flag"
    t.string "vestnik_cislo"
    t.string "cislo_oznamenia"
    t.string "source_url"
    t.string "bulletin_date_id"
    t.string "bulletin_date"
    t.text   "zakazka_nazov"
    t.string "druh_postupu_id"
    t.string "druh_postupu_code"
    t.string "druh_postupu"
    t.string "druh_zakazky_id"
    t.string "druh_zakazky_code"
    t.string "druh_zakazky"
    t.string "kriteria_vyhodnotenia_id"
    t.string "kriteria_vyhodnotenia_code"
    t.string "kriteria_vyhodnotenia"
    t.string "elektronicka_aukcia_flag"
    t.string "zakazka_eurofondy_flag"
    t.string "cpv_id"
    t.string "cpv_code"
    t.string "obstaravatel_id"
    t.string "obstaravatel_ico"
    t.string "obstaravatel_region"
    t.string "obstaravatel_nazov"
    t.string "obstaravatel_sektor_id"
    t.string "obstaravatel_sektor"
    t.string "obstaravatel_contact_email"
    t.string "obstaravatel_contact_phone"
    t.string "obstaravatel_contact_url"
    t.string "obstaravatel_contact_person"
    t.string "dodavatel_id"
    t.string "dodavatel_ico"
    t.string "dodavatel_region"
    t.string "dodavatel_nazov"
    t.string "dodavatel_stat"
    t.string "dodavatel_sektor_id"
    t.string "dodavatel_sektor"
    t.string "geography_id"
    t.string "predpoklad_subdodavok"
    t.string "pocet_ponuk"
    t.string "pocet_zmluv"
    t.string "zakazka_hodnota"
    t.string "zakazka_currency"
    t.string "zmluva_hodnota"
    t.string "zmluva_currency"
  end

  create_table "heuristics", :force => true do |t|
    t.string   "name",                         :null => false
    t.text     "explanation",                  :null => false
    t.string   "formula",                      :null => false
    t.text     "serialized_search_parameters", :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "heuristics", ["serialized_search_parameters"], :name => "index_heuristics_on_serialized_search_parameters", :unique => true

  create_table "pages", :force => true do |t|
    t.integer  "attachment_id", :null => false
    t.integer  "number",        :null => false
    t.text     "text"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "pages", ["attachment_id"], :name => "index_attachment_pages_on_document_attachment_id"
  add_index "pages", ["number", "created_at"], :name => "idx"
  add_index "pages", ["number", "created_at"], :name => "idx2", :order => {"created_at"=>:desc}
  add_index "pages", ["number", "created_at"], :name => "idx_partial"
  add_index "pages", ["number"], :name => "idx3"

  create_table "procurements", :force => true do |t|
    t.string  "zmluva_hodnota"
    t.text    "zakazka_nazov"
    t.string  "vestnik_cislo"
    t.string  "source_url"
    t.string  "date_year"
    t.string  "date_month"
    t.string  "date_month_name"
    t.string  "date_month_sname"
    t.string  "date_id"
    t.string  "date_day"
    t.string  "cpv_division"
    t.string  "cpv_division_label"
    t.string  "cpv_division_compet"
    t.string  "cpv_group"
    t.string  "cpv_group_label"
    t.string  "cpv_group_compet"
    t.string  "cpv_class"
    t.string  "cpv_class_label"
    t.string  "cpv_class_compet"
    t.string  "cpv_category"
    t.string  "cpv_category_label"
    t.string  "cpv_category_compet"
    t.string  "cpv_id"
    t.string  "cpv_detail"
    t.string  "cpv_detail_label"
    t.string  "cpv_code"
    t.string  "cpv_detail_compet"
    t.string  "procurer_account_sector_code"
    t.string  "procurer_account_sector"
    t.string  "procurer_id"
    t.string  "procurer_ico"
    t.string  "procurer_name"
    t.string  "procurer_region"
    t.string  "procurer_address"
    t.string  "procurer_legal_form"
    t.string  "procurer_offer_count_avg"
    t.string  "procurer_competitiveness"
    t.string  "supplier_id"
    t.string  "supplier_ico"
    t.string  "supplier_name"
    t.string  "supplier_address"
    t.string  "supplier_country"
    t.string  "supplier_date_start"
    t.string  "supplier_date_end"
    t.string  "supplier_legal_form"
    t.string  "supplier_ownership"
    t.string  "supplier_offer_count_avg"
    t.string  "supplier_competitiveness"
    t.string  "druh_postupu_id"
    t.string  "druh_postupu_code"
    t.string  "druh_postupu_description"
    t.string  "druh_postupu_sdesc"
    t.string  "kriteria_vyhodnotenia_code"
    t.text    "kriteria_vyhodnotenia_description"
    t.text    "kriteria_vyhodnotenia_sdesc"
    t.string  "kriteria_vyhodnotenia_id"
    t.string  "geography_kraj_code"
    t.string  "geography_kraj"
    t.string  "geography_okres_code"
    t.string  "geography_okres"
    t.string  "document_id"
    t.string  "pocet_ponuk"
    t.string  "druh_zakazky_id"
    t.string  "druh_zakazky_code"
    t.string  "druh_zakazky"
    t.string  "elektronicka_aukcia_flag"
    t.string  "zakazka_eurofondy_flag"
    t.integer "document_detail"
    t.string  "document_detail_type"
  end

  create_table "question_answers", :force => true do |t|
    t.integer  "question_id",                     :null => false
    t.integer  "question_choice_id",              :null => false
    t.text     "detail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "document_id"
    t.integer  "guest_user_id",      :limit => 8
  end

  create_table "question_choices", :force => true do |t|
    t.integer "question_id",  :null => false
    t.string  "label",        :null => false
    t.boolean "wants_detail"
  end

  create_table "questions", :force => true do |t|
    t.text    "text",                            :null => false
    t.boolean "in_contract",  :default => true
    t.boolean "in_appendix",  :default => true
    t.boolean "always_shown", :default => false, :null => false
  end

  create_table "regis_subjects", :force => true do |t|
    t.integer "regis_id",                         :null => false
    t.integer "ico",                              :null => false
    t.string  "name",                             :null => false
    t.string  "address"
    t.date    "created_on"
    t.date    "dissolved_on"
    t.string  "district"
    t.integer "legal_form_code"
    t.string  "legal_form_label"
    t.integer "sk_nace_category_code"
    t.string  "sk_nace_category_label"
    t.integer "okec_category_code"
    t.string  "okec_category_label"
    t.integer "sector_code"
    t.string  "sector_label"
    t.integer "ownership_category_code"
    t.string  "ownership_category_label"
    t.integer "organisation_size_category_code"
    t.string  "organisation_size_category_label"
  end

  add_index "regis_subjects", ["ico"], :name => "index_regis_subjects_on_ico", :unique => true
  add_index "regis_subjects", ["regis_id"], :name => "index_regis_subjects_on_regis_id", :unique => true

  create_table "spaceship_settings", :force => true do |t|
    t.string  "identifier"
    t.string  "label"
    t.integer "value"
  end

  create_table "static_pages", :force => true do |t|
    t.string   "slug",       :limit => 100, :null => false
    t.string   "title",      :limit => 100, :null => false
    t.text     "content",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "static_pages", ["slug"], :name => "index_static_pages_on_slug"

  create_table "temp_procurements", :force => true do |t|
    t.string "zmluva_hodnota"
    t.text   "zakazka_nazov"
    t.string "vestnik_cislo"
    t.string "source_url"
    t.string "date_year"
    t.string "date_month"
    t.string "date_month_name"
    t.string "date_month_sname"
    t.string "date_id"
    t.string "date_day"
    t.string "cpv_division"
    t.string "cpv_division_label"
    t.string "cpv_division_compet"
    t.string "cpv_group"
    t.string "cpv_group_label"
    t.string "cpv_group_compet"
    t.string "cpv_class"
    t.string "cpv_class_label"
    t.string "cpv_class_compet"
    t.string "cpv_category"
    t.string "cpv_category_label"
    t.string "cpv_category_compet"
    t.string "cpv_id"
    t.string "cpv_detail"
    t.string "cpv_detail_label"
    t.string "cpv_code"
    t.string "cpv_detail_compet"
    t.string "procurer_account_sector_code"
    t.string "procurer_account_sector"
    t.string "procurer_id"
    t.string "procurer_ico"
    t.string "procurer_name"
    t.string "procurer_region"
    t.string "procurer_address"
    t.string "procurer_legal_form"
    t.string "procurer_offer_count_avg"
    t.string "procurer_competitiveness"
    t.string "supplier_id"
    t.string "supplier_ico"
    t.string "supplier_name"
    t.string "supplier_address"
    t.string "supplier_country"
    t.string "supplier_date_start"
    t.string "supplier_date_end"
    t.string "supplier_legal_form"
    t.string "supplier_ownership"
    t.string "supplier_offer_count_avg"
    t.string "supplier_competitiveness"
    t.string "druh_postupu_id"
    t.string "druh_postupu_code"
    t.string "druh_postupu_description"
    t.string "druh_postupu_sdesc"
    t.string "kriteria_vyhodnotenia_code"
    t.text   "kriteria_vyhodnotenia_description"
    t.text   "kriteria_vyhodnotenia_sdesc"
    t.string "kriteria_vyhodnotenia_id"
    t.string "geography_kraj_code"
    t.string "geography_kraj"
    t.string "geography_okres_code"
    t.string "geography_okres"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                     :default => "",    :null => false
    t.string   "encrypted_password",         :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                             :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin"
    t.boolean  "expert"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                                                         :null => false
    t.boolean  "banned",                                    :default => false
    t.boolean  "stream_show_openings",                      :default => true,  :null => false
    t.boolean  "stream_show_watching",                      :default => true,  :null => false
    t.boolean  "stream_show_my_comments",                   :default => true,  :null => false
    t.boolean  "stream_show_other_comments",                :default => true,  :null => false
    t.boolean  "stream_show_answers",                       :default => true,  :null => false
    t.integer  "results_per_page",                          :default => 15,    :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votings", :force => true do |t|
    t.integer "user_id",    :null => false
    t.integer "comment_id", :null => false
    t.string  "up_or_down", :null => false
  end

  add_index "votings", ["user_id", "comment_id"], :name => "index_votings_on_user_id_and_comment_id"

  create_table "watchlists", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.integer  "document_id", :null => false
    t.string   "notice"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "watchlists", ["user_id", "document_id"], :name => "index_watchlists_on_user_id_and_document_id"

  add_foreign_key "attachments", "documents", :name => "attachments_document_id_fk", :dependent => :delete

  add_foreign_key "banned_ips", "users", :name => "banned_ips_creator_id_fk", :column => "creator_id"

  add_foreign_key "comments", "users", :name => "comments_censored_by_id_fk", :column => "censored_by_id", :dependent => :nullify

  add_foreign_key "crz_appendix_connections", "documents", :name => "crz_appendix_connections_document_id_fk", :dependent => :delete

  add_foreign_key "crz_attachment_details", "attachments", :name => "crz_attachment_details_attachment_id_fk", :dependent => :delete

  add_foreign_key "crz_document_details", "documents", :name => "crz_document_details_document_id_fk", :dependent => :delete

  add_foreign_key "documents_heuristics", "documents", :name => "documents_heuristics_document_id_fk", :dependent => :delete
  add_foreign_key "documents_heuristics", "heuristics", :name => "documents_heuristics_heuristic_id_fk", :dependent => :delete

  add_foreign_key "egovsk_attachment_details", "attachments", :name => "egovsk_attachment_details_attachment_id_fk", :dependent => :delete

  add_foreign_key "egovsk_document_details", "documents", :name => "egovsk_document_details_document_id_fk", :dependent => :delete

  add_foreign_key "pages", "attachments", :name => "pages_attachment_id_fk", :dependent => :delete

  add_foreign_key "question_answers", "documents", :name => "question_answers_document_id_fk", :dependent => :delete
  add_foreign_key "question_answers", "question_choices", :name => "question_answers_question_choice_id_fk", :dependent => :delete
  add_foreign_key "question_answers", "questions", :name => "question_answers_question_id_fk", :dependent => :delete
  add_foreign_key "question_answers", "users", :name => "question_answers_user_id_fk", :dependent => :nullify

  add_foreign_key "question_choices", "questions", :name => "question_choices_question_id_fk", :dependent => :delete

end
