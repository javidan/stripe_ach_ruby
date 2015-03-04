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


    def hash_to_ostruct(hash, options = {})
      convert_to_ostruct_recursive(hash, options)
    end
       
  private
    def convert_to_ostruct_recursive(obj, options)
      result = obj
      if result.is_a? Hash
        result = result.dup.with_sym_keys
        result.each do |key, val|
        result[key] = convert_to_ostruct_recursive(val, options) unless options[:exclude].try(:include?, key)
      end
     
      result = OpenStruct.new result
     
      elsif result.is_a? Array
       result = result.map { |r| convert_to_ostruct_recursive(r, options) }
      end
        return result
      end 
    end
end

