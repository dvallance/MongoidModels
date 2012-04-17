module MongoidModels
 
  Markup = Struct.new(:name, :process_content)
  SUPPORTED_MARKUP = [
    Markup.new("text", :copy),
    Markup.new("html", :copy),
    Markup.new("slim", :tilt_process)
  ]

  class Document
    include Mongoid::Document
    store_in :documents
    belongs_to :user, :class_name => "MongoidModels::User"
    
    
    field :title, type: String
    field :markup, type: String
    field :content, type: String
    field :processed_content, type: String

    attr_accessible :title, :markup, :content, :processed_content

    validates_presence_of :title, :markup, :content
    validates_inclusion_of :markup, in: SUPPORTED_MARKUP.collect(&:name), message: "Supplied markup is not in the list of accepted types #{SUPPORTED_MARKUP}"

    # will be performed if validations pass
    before_save { self.processed_content = Document.process_markup(self.markup, self.content) } 

    class << self
      def process_markup(markup, content)
        mu = SUPPORTED_MARKUP.select{|m| m.name == markup}.try(:first)
        raise ::ArgumentError, "Markup type not supported" unless mu
        case mu.process_content
        when :tilt_process
          begin
            template = ::Tilt[mu.name.to_s].new { content }
            return template.render
          rescue Exception => e
            return "Problem processing markup #{e.message}"
          end
        when :copy
          return content
        end
      end
    end

  end # class Document
end # module MongoidModels

