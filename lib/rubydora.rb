# Fedora Commons REST API module
require 'active_model'
require 'deprecation'

module Rubydora
  autoload :Datastream, "rubydora/datastream"
  autoload :Repository, "rubydora/repository"
  autoload :ResourceIndex, "rubydora/resource_index"
  autoload :FedoraUrlHelpers, "rubydora/fedora_url_helpers"
  autoload :RestApiClient, "rubydora/rest_api_client"
  autoload :ModelsMixin, "rubydora/models_mixin"
  autoload :RelationshipsMixin, "rubydora/relationships_mixin"
  autoload :DigitalObject, "rubydora/digital_object"
  autoload :Callbacks, "rubydora/callbacks"
  autoload :ArrayWithCallback, "rubydora/array_with_callback"
  autoload :Transactions, "rubydora/transactions"
  autoload :AuditTrail, "rubydora/audit_trail"

  require 'csv'
  require 'time'
  require 'hooks'

  if CSV.const_defined? :Reader
    require 'fastercsv'
  end
  require 'restclient'
  require 'nokogiri'

  require 'rubydora/version'

  # Connect to Fedora Repository
  # @return Rubydora::Repository
  def self.connect *args
    Repository.new *args
  end

  # Connect to the default Fedora Repository
  # @return Rubydora::Repository
  def self.repository
    @repository ||= self.connect(self.default_config)
  end

  # Set the default Fedora Repository
  # @param [Rubydora::Repository] repository
  # @return Rubydora::Repository
  def self.repository= repository
    @repository = repository
  end

  # Default repository connection information
  # TODO: read ENV variables?
  # @return Hash
  def self.default_config
    {:validateChecksum=>false}
  end

  class RubydoraError < StandardError; end

  class FedoraInvalidRequest < RubydoraError; end

  class RecordNotFound < RubydoraError; end 

end
