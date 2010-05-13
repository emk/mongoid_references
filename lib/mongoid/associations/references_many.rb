# :nodoc: This code is heavily based on the Mongoid::Associations classes
# BelongsToRelated and HasManyRelated.
module Mongoid 
  module Associations #:nodoc:
    # Weak references to multiple Mongoid::Documents through an array of
    # BSON::ObjectID stored in this document.
    class ReferencesMany < Proxy
      def initialize(document, foreign_keys, options, target = nil)
        @options = options
        @target = target || (foreign_keys.empty? ? [] :
                             options.klass.find(foreign_keys))
        extends(options)
      end

      class << self
        # Preferred method for creating the new +HasManyRelated+ association.
        def instantiate(document, options, target = nil)
          foreign_keys = document.send(options.foreign_key)
          new(document, foreign_keys, options, target)
        end

        # Returns the macro used to create the association.
        def macro
          :references_many
        end

        # Perform an update of the relationship of the parent and child.
        def update(target, document, options)
          document.send("#{options.foreign_key}=", target.map {|t| t.id })
          instantiate(document, options, target)
        end
      end
    end
  end
end
