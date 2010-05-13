require 'mongoid'

# Require our new association types.
require 'mongoid/associations/references_one'

module Mongoid
  module Associations
    module ClassMethods
      def references_one(name, options = {}, &block)
        opts = optionize(name, options, fk(name, options), &block)
        associate(Associations::ReferencesOne, opts)
        field(opts.foreign_key, :type => Mongoid.use_object_ids ? BSON::ObjectID : String)
      end
    end
  end
end
