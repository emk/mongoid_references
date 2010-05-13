require 'mongoid'

# Require our new association types.
require 'mongoid/associations/references_one'
require 'mongoid/associations/references_many'

module Mongoid
  module Associations
    module ClassMethods
      def references_one(name, options = {}, &block)
        opts = optionize(name, options, fk(name, options), &block)
        associate(Associations::ReferencesOne, opts)
        field(opts.foreign_key, :type => Mongoid.use_object_ids ? BSON::ObjectID : String)
      end

      def references_many(name, options = {}, &block)
        opts = optionize(name, options, fk_plural(name, options), &block)
        associate(Associations::ReferencesMany, opts)
        field(opts.foreign_key, :type => Array)
      end

      protected

      # Find a plural foreign key.  Our goal is to generate 'wheel_ids'
      # instead of 'wheels_id'.
      def fk_plural(name, options)
        options[:foreign_key] ||
          name.to_s.singularize.foreign_key.to_s.pluralize.to_sym
      end
    end
  end
end
