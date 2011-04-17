module Rubydora
  module RelationshipsMixin

    # FIXME: This should probably be defined on the DigitalObject
    RELS_EXT = {"annotations"=>"info:fedora/fedora-system:def/relations-external#hasAnnotation",
                "has_metadata"=>"info:fedora/fedora-system:def/relations-external#hasMetadata",
                "description_of"=>"info:fedora/fedora-system:def/relations-external#isDescription_of",
                "part_of"=>"info:fedora/fedora-system:def/relations-external#isPart_of",
                "descriptions"=>"info:fedora/fedora-system:def/relations-external#hasDescription",
                "dependent_of"=>"info:fedora/fedora-system:def/relations-external#isDependent_of",
                "constituents"=>"info:fedora/fedora-system:def/relations-external#hasConstituent",
                "parts"=>"info:fedora/fedora-system:def/relations-external#hasPart",
                "memberOfCollection"=>"info:fedora/fedora-system:def/relations-external#isMemberOfCollection",
                "member_of"=>"info:fedora/fedora-system:def/relations-external#isMember_of",
                "equivalents"=>"info:fedora/fedora-system:def/relations-external#hasEquivalent",
                "derivations"=>"info:fedora/fedora-system:def/relations-external#hasDerivation",
                "derivation_of"=>"info:fedora/fedora-system:def/relations-external#isDerivation_of",
                "subsets"=>"info:fedora/fedora-system:def/relations-external#hasSubset",
                "annotation_of"=>"info:fedora/fedora-system:def/relations-external#isAnnotation_of",
                "metadata_for"=>"info:fedora/fedora-system:def/relations-external#isMetadataFor",
                "dependents"=>"info:fedora/fedora-system:def/relations-external#hasDependent",
                "subset_of"=>"info:fedora/fedora-system:def/relations-external#isSubset_of",
                "constituent_of"=>"info:fedora/fedora-system:def/relations-external#isConstituent_of",
                "collection_members"=>"info:fedora/fedora-system:def/relations-external#hasCollectionMember",
                "members"=>"info:fedora/fedora-system:def/relations-external#hasMember"}

    def self.included(base)

        # FIXME: ugly, but functional..
        RELS_EXT.each do |name, property|
          base.class_eval <<-RUBY
            def #{name.to_s} refetch = false
              relationships[:#{name}] = nil if refetch
              relationships[:#{name}] ||= relationship('#{property}')
            end
          RUBY
        end
    end

    def relationship predicate
      arr = ArrayWithCallback.new(repository.find_by_sparql_relationship(fqpid, predicate))
      arr.hooks << lambda { |arr, diff| relationship_changed(predicate, diff, arr) } 

      arr
    end

    def relationship_changed predicate, diff, arr = []
      diff[:+] ||= []
      diff[:-] ||= []

      diff[:+].each do |o| 
        repository.add_relationship :subject => fqpid, :predicate => predicate, :object => o.fqpid
      end        

      diff[:-].each do |o| 
        repository.purge_relationship :subject => fqpid, :predicate => predicate, :object => o.fqpid
      end        
    end

    def relationships
      @relationships ||= {}
    end
  end
end
