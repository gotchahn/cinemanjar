module Parseable
  extend ActiveSupport::Concern
  include ActiveModel::Model

  def initialize(attributes= {})
    new_attributes = attributes.select{ |k,v| respond_to?(:"#{k}=")}
    super(new_attributes)
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
  end
end
