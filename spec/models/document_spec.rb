require 'spec_helper'

describe Document do
  context "when indexing" do
    #before do
    #  @index = Configuration.documents_repository
    #  @index.recreate
    #  @index.flush_percolators
    #end

    xit "should index itself after create" do
      doc = Crz::Document.create(:supplier => "minio, s.r.o", :crz_id => 1, :identifier => "xxx", :name => "bla bla", :customer => "AFP+TIS")
      @index.get(doc.id).should_not be_nil
    end

    xit "should also update index after update" do
      doc = Crz::Document.create(:supplier => "minio, s.r.o", :crz_id => 1, :identifier => "xxx", :name => "bla bla", :customer => "AFP+TIS")
      doc.supplier = "varle, a.s."
      doc.save
      updated = @index.get(doc.id)
      updated.supplier.should == "varle, a.s."
    end

    xit "should remove itself from index after destroy" do
      doc = Crz::Document.create(:supplier => "minio, s.r.o", :crz_id => 1, :identifier => "xxx", :name => "bla bla", :customer => "AFP+TIS")
      doc.destroy
      @index.get(doc.id).should be_nil
    end

    it "should return indexable hash with all info" do
      Regis::Subject.create!(
          :ico=> 46058397,
          :name=> "minio, s. r. o.",
          :address=> "Šafárikovo námestie 7, 811 02 Bratislava - Staré Mesto",
          :created_on=> Date.parse("26.02.2011"),
          :district=> "Bratislava I",
          :legal_form_code=> 112,
          :legal_form_label=> "Spoločnosť s ručením obmedzeným",
          :sk_nace_category_code=> 82990,
          :sk_nace_category_label=> "Ostatné pomocné obchodné činnosti i. n.",
          :okec_category_code=> 74870,
          :okec_category_label=> "Ostatné obchodné činnosti i. n.",
          :sector_code=> 11002,
          :sector_label=> "Súkromné nefinančné korporácie",
          :ownership_category_code=> 2,
          :ownership_category_label=> "Súkromné tuzemské",
          :organisation_size_category_code=> 00,
          :organisation_size_category_label=> "nezistený počet zamestnacov",
          :regis_id => 123
      )

      appendix = Crz::Appendix.create(
          :supplier => "minio, s.r.o.",
          :customer => "STU Bratislava",
          :published_on => Date.civil(2011, 1, 20),
          :expires_on => Date.civil(2041, 1, 20),
          :total_amount => 2200.0,
          :name => 'dodavka softveru',
          :identifier => 'ass',
          :contract_crz_id => 123,
          :crz_id => 123456
      )

      doc = Crz::Contract.new(
          :supplier => "minio, s.r.o.",
          :supplier_ico => 46058397,
          :customer => "STU Bratislava",
          :published_on => Date.civil(2011, 2, 28),
          :expires_on => Date.civil(2041, 1, 20),
          :total_amount => 2200.0,
          :name => 'dodavka softveru',
          :crz_id => 123
      )

      attachment = doc.attachments.build
      attachment.pages.build(:number => 1, :text => "minio.sk")
      attachment.pages.build(:number => 2, :text => "test")
      attachment.pages.build(:number => 3, :text => "minio.sk")
      attachment.pages.build(:number => 4, :text => "minio.sk")
      attachment.pages.build(:number => 5, :text => "minio.sk")
      attachment.pages.build(:number => 6, :text => "minio.sk")
      doc.attachments.build

      indexable = doc.to_indexable.with_indifferent_access

      indexable[:supplier].should_not be_nil
      indexable[:customer].should_not be_nil
      indexable[:published_on].should_not be_nil
      indexable[:expires_on].should_not be_nil
      indexable[:total_amount].should_not be_nil
      indexable[:name].should_not be_nil
      indexable[:attachments].should_not be_nil
      indexable[:attachments].first[:pages].should_not be_nil
      indexable[:attachments].first[:pages].first[:number].should == 1
      indexable[:attachments].first[:pages].first[:text].should_not be_nil
      indexable[:attachments_count].should == 2
      indexable[:points].should_not be_nil
      indexable[:total_pages_count].should == 6
      indexable[:appendixes_count].should == 1
      indexable[:supplier_age].should == 2
      indexable[:comments_count].should == 0
      indexable[:source].should == "www.crz.gov.sk"
      indexable[:supplier_nace].should == "Ostatné pomocné obchodné činnosti i. n."
      indexable
    end

    it "should return nil when supplier age not available" do
      appendix = Crz::Appendix.create(
          :supplier => "minio, s.r.o.",
          :customer => "STU Bratislava",
          :published_on => Date.civil(2011, 1, 20),
          :expires_on => Date.civil(2041, 1, 20),
          :total_amount => 2200.0,
          :name => 'dodavka softveru',
          :identifier => 'ass',
          :contract_crz_id => 123,
          :crz_id => 123456
      )
       appendix.to_indexable[:supplier_age].should be_nil
    end
  end
end
