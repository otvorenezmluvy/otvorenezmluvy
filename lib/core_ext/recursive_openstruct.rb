# use optimized OpenStruct without slow method creation
class OpenStruct
  def initialize(hash = {})
    @table = hash.with_indifferent_access
  end

  def method_missing(method, *args)
    member = method.to_s
    if member.chomp!('=')
      @table[member] = args[0]
    else
      @table[member]
    end
  end

  def respond_to?(member)
    @table.include?(member)
  end
end

# http://www.fngtps.com/2007/using-openstruct-as-mock-for-activerecord/
OpenStruct.__send__(:define_method, :id) { @table[:id] }

# http://www.rubyquiz.com/quiz81.html
class NilClass
  def to_openstruct
    self
  end
end

class Object
  def to_openstruct
    self
  end
end

class Array
  def to_openstruct
    map(&:to_openstruct)
  end
end

class Hash
  def to_openstruct
    mapped = {}
    each { |key, value| mapped[key] = value.to_openstruct }
    OpenStruct.new(mapped)
  end
end
