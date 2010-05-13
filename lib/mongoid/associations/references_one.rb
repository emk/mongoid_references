# :nodoc: This code is copied almost verbatim from
# Mongoid::Associations::BelongsToRelated.
module Mongoid 
  module Associations #:nodoc:
    # A weak reference to another Mongoid::Document through a
    # BSON::ObjectID stored in this document.
    class ReferencesOne < Proxy
      def initialize(document, foreign_key, options, target = nil)
        @options = options
        @target = target || options.klass.find(foreign_key)
        extends(options)
      end

      class << self
        # Instantiate a new +ReferencesOne+ or return nil if the foreign
        # key is nil.
        def instantiate(document, options, target = nil)
          foreign_key = document.send(options.foreign_key)
          foreign_key.blank? ? nil : new(document, foreign_key, options, target)
        end
        
        # Returns the macro used to create the association.
        def macro
          :references_one
        end
        
        # Perform an update of the relationship of the parent and child.
        def update(target, document, options)
          document.send("#{options.foreign_key}=", target ? target.id : nil)
          instantiate(document, options, target)
        end
      end
    end
  end
end
