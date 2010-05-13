# :nodoc: This code is heavily based on the Mongoid::Associations classes
# BelongsToRelated and HasManyRelated.
module Mongoid 
  module Associations #:nodoc:
    # Weak references to multiple Mongoid::Documents through an array of
    # BSON::ObjectID stored in this document.
    class ReferencesMany < Proxy
      def initialize(document, options, target = nil)
        @document, @options = document, options
        @target = target || load_target
        extends(options)
      end

      # Append one or more documents to our association.
      def <<(*objects)
        objects.flatten.each do |object|
          object.save! if object.new_record?
          @target << object
        end
        @document.send("#{options.foreign_key}=", @target.map {|t| t.id })
      end

      protected

      # Look up the objects we're referencing.
      def load_target
        foreign_keys = @document.send(@options.foreign_key)

        # Mongoid's 'find' command doesn't really work right when passed 0
        # or 1 keys, so we need to special-case it.
        case foreign_keys.length
        when 0: []
        when 1: [options.klass.find(foreign_keys.first)]
        else    options.klass.find(foreign_keys)
        end
      end

      class << self
        # Preferred method for creating the new +HasManyRelated+ association.
        def instantiate(document, options, target = nil)
          new(document, options, target)
        end

        # Returns the macro used to create the association.
        def macro
          :references_many
        end

        # Perform an update of the relationship of the parent and child.
        def update(target, document, options)
          target_ids = target.map do |t|
            t.save! if t.new_record?
            t.id
          end
          document.send("#{options.foreign_key}=", target_ids)
          instantiate(document, options, target)
        end
      end
    end
  end
end
