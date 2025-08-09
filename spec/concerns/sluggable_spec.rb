# spec/concerns/sluggable_spec.rb
require "rails_helper"
require "active_record"

RSpec.describe Sluggable, type: :concern do
  # --- Dummy ActiveRecord Model Setup ---
  let(:dummy_model) do
    Class.new(ApplicationRecord) do
      self.table_name = :dummy_sluggable_models

      include Sluggable

      def self.model_name
        @_model_name ||= ActiveModel::Name.new(self, nil, "DummySluggableModel")
      end

      attribute :name, :string
      attribute :slug, :string
      attribute :alt_title, :string
      attribute :creator_id, :integer
      attribute :status, :string
      attribute :privacy_setting, :string

      validates :creator_id, presence: true
      validates :status, presence: true
      validates :privacy_setting, presence: true
      validates :name, presence: true, if: -> { self.class.slug_source_attribute == :name }
    end
  end

  before(:all) do
    ActiveRecord::Base.connection.create_table :dummy_sluggable_models, force: true do |t|
      t.string :name
      t.string :slug
      t.string :alt_title
      t.integer :creator_id
      t.string :status
      t.string :privacy_setting
    end
  end

  after(:all) do
    ActiveRecord::Base.connection.drop_table :dummy_sluggable_models
  end

  after(:each) do
    dummy_model.delete_all
  end

  let(:dummy_creator) {
    AureliusPress::User.create!(
      email: "test_user_#{SecureRandom.hex(6)}@example.com",
      password: "password123",
      first_name: "Test",
      last_name: "User",
    )
  }

  # --- Sluggable Concern Core Behaviour Tests ---

  describe "concern behaviour and configuration" do
    it "sets slug_source_attribute to :name by default" do
      expect(dummy_model.slug_source_attribute).to eq(:name)
    end

    it "allows overriding the slug_source_attribute with slugged_by" do
      custom_source_model = Class.new(ApplicationRecord) do
        self.table_name = :dummy_sluggable_models
        def self.model_name
          @_model_name ||= ActiveModel::Name.new(self, nil, "CustomSourceDummy")
        end
        include Sluggable
        slugged_by :alt_title
        attribute :name, :string
        attribute :slug, :string
        attribute :alt_title, :string
        attribute :creator_id, :integer
        attribute :status, :string
        attribute :privacy_setting, :string
        validates :alt_title, presence: true
        validates :creator_id, presence: true
        validates :status, presence: true
        validates :privacy_setting, presence: true
      end
      expect(custom_source_model.slug_source_attribute).to eq(:alt_title)
    end
  end

  describe "slug generation and management" do
    it "generates a slug from the name attribute on creation" do
      instance = dummy_model.create!(name: "My Test Item", creator_id: dummy_creator.id, status: :active, privacy_setting: :public_group)
      expect(instance.slug).to eq("my-test-item")
      expect(instance).to be_valid # Implicitly tests presence and uniqueness
    end

    it "generates a slug from custom source attribute (alt_title)" do
      custom_source_model = Class.new(ApplicationRecord) do
        self.table_name = :dummy_sluggable_models
        def self.model_name
          @_model_name ||= ActiveModel::Name.new(self, nil, "CustomSourceModel")
        end
        include Sluggable
        slugged_by :alt_title
        attribute :name, :string
        attribute :slug, :string
        attribute :alt_title, :string
        attribute :creator_id, :integer
        attribute :status, :string
        attribute :privacy_setting, :string
        validates :alt_title, presence: true
        validates :creator_id, presence: true
        validates :status, presence: true
        validates :privacy_setting, presence: true
      end

      instance = custom_source_model.create!(alt_title: "Another Custom Title", name: "Ignored", creator_id: dummy_creator.id, status: :active, privacy_setting: :public_group)
      expect(instance.slug).to eq("another-custom-title")
      expect(instance).to be_valid
    end

    it "handles special characters and spaces in the source name" do
      instance = dummy_model.create!(name: "A Book! With (Special) Characters & Stuff", creator_id: dummy_creator.id, status: :active, privacy_setting: :public_group)
      expect(instance.slug).to eq("a-book-with-special-characters-stuff")
      expect(instance).to be_valid
    end

    it "appends a counter for duplicate slugs case-insensitively" do
      dummy_model.create!(name: "Duplicate Item", creator_id: dummy_creator.id, status: :active, privacy_setting: :public_group) # slug: duplicate-item
      second_instance = dummy_model.create!(name: "duplicate item", creator_id: dummy_creator.id, status: :active, privacy_setting: :public_group) # slug: duplicate-item-1
      third_instance = dummy_model.create!(name: "DUPLICATE ITEM", creator_id: dummy_creator.id, status: :active, privacy_setting: :public_group) # slug: duplicate-item-2

      expect(second_instance.slug).to eq("duplicate-item-1")
      expect(third_instance.slug).to eq("duplicate-item-2")
      expect(second_instance).to be_valid
      expect(third_instance).to be_valid
    end

    it "respects an explicitly set slug on creation" do
      instance = dummy_model.create!(name: "Original Name", slug: "my-chosen-slug", creator_id: dummy_creator.id, status: :active, privacy_setting: :public_group)
      expect(instance.slug).to eq("my-chosen-slug")
      expect(instance).to be_valid
    end

    it "regenerates the slug when the source attribute changes" do
      instance = dummy_model.create!(name: "Old Name", creator_id: dummy_creator.id, status: :active, privacy_setting: :public_group)
      expect(instance.slug).to eq("old-name")

      instance.name = "New Name for Item"
      instance.save!
      expect(instance.slug).to eq("new-name-for-item")
      expect(instance).to be_valid
    end

    it "regenerates slug from source if explicitly blanked out on update" do
      instance = dummy_model.create!(name: "Existing Item", creator_id: dummy_creator.id, status: :active, privacy_setting: :public_group)
      expect(instance.slug).to eq("existing-item")

      instance.slug = nil # Explicitly blank out
      instance.save!
      expect(instance.slug).to eq("existing-item") # Should regenerate from name
      expect(instance).to be_valid
    end

    it "parameterises an explicitly changed slug on update" do
      instance = dummy_model.create!(name: "Original", slug: "manual-slug", creator_id: dummy_creator.id, status: :active, privacy_setting: :public_group)
      expect(instance.slug).to eq("manual-slug")

      instance.slug = "Another Manually Set Slug!"
      instance.save!
      expect(instance.slug).to eq("another-manually-set-slug")
      expect(instance).to be_valid
    end

    it "does not regenerate slug if unrelated attributes change and slug is already set" do
      instance = dummy_model.create!(name: "Steady Item", creator_id: dummy_creator.id, status: :active, privacy_setting: :public_group)
      original_slug = instance.slug
      expect(original_slug).to eq("steady-item")

      instance.status = "archived" # Unrelated attribute change
      instance.save!
      expect(instance.slug).to eq(original_slug) # Slug should not have changed
      expect(instance).to be_valid
    end

    it "raises a validation error if the source attribute is blank and no explicit slug provided" do
      # Mock name to be nil, so slug remains blank after callbacks
      instance = dummy_model.new(name: nil, creator_id: dummy_creator.id, status: :active, privacy_setting: :public_group)

      expect { instance.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(instance.errors[:slug]).to include("can't be blank")
    end
  end
end
