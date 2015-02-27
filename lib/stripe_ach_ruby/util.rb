module StripeAch
  class Util
    
    def self.url(*args)
      args.each{|r| r.to_s}.join('/');
    end

    def self.symbolize_names(object)
      case object
      when Hash
        new_hash = {}
        object.each do |key, value|
        key = (key.to_sym rescue key) || key
        new_hash[key] = symbolize_names(value)
      end
      new_hash
      when Array
        object.map { |value| symbolize_names(value) }
      else
        object
      end
    end
  end
end

