module Parseable
  extend ActiveSupport::Concern
  include ActiveModel::Model

  def initialize(attributes= {})
    @raw_data ||= attributes
    new_attributes = attributes.select{ |k,v| respond_to?(:"#{k}=")}
    super(new_attributes)
  end

  def not_found?
    @raw_data.empty?
  end

  def raw_data
    @raw_data
  end

  def data_fetch(field)
    raw_data.fetch(field.to_s, nil)
  end

  module ClassMethods
    def source_to_collection(source, klass = nil)
      return [] if source.blank?
      klass ||= self
      source.map{ |data| klass.new(data) }
    end

    def has_one(field, options={})
      define_method( field ) do
        source = data_fetch(field)
        #get klass
        klass = options[:class] || field.to_s.singularize.camelize.constantize
        klass.new(source)
      end
    end

    def has_many(field, options={})
      define_method( field ) do
        source = data_fetch(field)
        #get klass
        klass = options[:class] || field.to_s.singularize.camelize.constantize
        self.class.source_to_collection(source, klass)
      end
    end
  end
end
