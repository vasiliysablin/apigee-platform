require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class MortalKombat
  include ApigeePlatform::Associations
  attr_accessor :mk_id
  has_many :characters

  def self.primary_key
    :mk_id
  end

  def self.find(*args)
    x = self.new
    x.mk_id = 9
    if args.first == :all
      [x]
    else
      x
    end
  end
end

class MortalKombatCharacter
  include ApigeePlatform::Associations
  attr_accessor :char_id, :mk_id

  belongs_to :mortal_kombat
  has_many :locations, :through => 'maps'

  def initialize(*args)
    @params = args
  end

  def self.prefix_options
    {:version => :mk_id} 
  end  

  def self.find(*args)
    x = self.new
    x.char_id = 'Jax'
    if args.first == :all
      [x]
    else
      x
    end
  end

  def maps
    [ 
      OpenStruct.new(:attributes => {:name => 'Kuatan'}), 
      OpenStruct.new(:attributes => {:name => 'Street'}), 
      OpenStruct.new(:attributes => {:name => 'Swamp'})]
  end
end

class MortalKombatCharacterLocation
  attr_accessor :name
  def initialize(params, prefix_params={})
    params.each{|k,v| instance_variable_set("@#{k}", v)}
  end

  def self.prefix_options 
    {:char_id => :char_id}
  end

  def self.instantiate_record(params, prefix_params={})
    self.new(params, prefix_params)
  end
end


describe 'class with has_many association' do 
  subject { MortalKombat.new }
  it 'can find all nested objects' do 
    subject.should respond_to(:characters)
    subject.characters.should be_kind_of(Array)
  end

  it 'has method to find subobject' do 
    subject.should respond_to(:character)
  end

  it 'is able to find subobject' do 
    subject.character('Jax').should be_kind_of(MortalKombatCharacter)
  end

  it 'return children' do 
    subject.characters.first.should be_kind_of(MortalKombatCharacter)
  end

  it 'can create subobject by getting requesting object without id' do
    subject.character.should be_kind_of(MortalKombatCharacter)
  end

  it 'has method for creating subobject' do 
    subject.create_character.should be_kind_of(MortalKombatCharacter)
  end

  it 'sets prefix parameters for subobject' do 
    subject.instance_variable_set(:@mk_id, 10)
    pp = subject.create_character.instance_variable_get(:@params)
    pp.should include({:mk_id=>10})
  end
end

describe 'class with belongs_to association' do 
  subject { MortalKombatCharacter.new }
  it 'has method to get parent' do
    subject.should respond_to(:mortal_kombat)
  end

  it 'return object of correct class when getting parent' do 
    subject.mortal_kombat.should be_kind_of(MortalKombat)
  end

end

describe 'class with belongs_to(:through => ..) association' do 
  subject { MortalKombatCharacter.new }
  it 'has method to nested collection' do
    subject.should respond_to(:locations)
  end

  it 'returns nested objects from method passed in \'through\' ' do 
    subject.locations.count.should == subject.maps.count
    subject.locations.map(&:name).to_set.should == subject.maps.map{|el| el.attributes[:name]}.to_set
  end

end

