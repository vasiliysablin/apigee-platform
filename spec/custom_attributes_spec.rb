require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'custom attrs' do 
  it 'make data accessible as hash elements' do 
    obj = OpenStruct.new :attributes => {'attributes' => [{'name' => 'name', 'value' => 'Kitana'}]}
    c = ApigeePlatform::CustomAttributes.new obj 
    c['name'].should == obj.attributes['attributes'].first['value']
  end

  it 'sets new values in source object' do 
    obj = OpenStruct.new :attributes => {'attributes' => []}
    c = ApigeePlatform::CustomAttributes.new obj 
    c['name'] = 'Johnny Cage'
    obj.attributes['attributes'].first['name'].should == 'name'
    obj.attributes['attributes'].first['value'].should == 'Johnny Cage'
  end

  it 'return names of data variables' do 
    obj = OpenStruct.new :attributes => {'attributes' => [
      {'name' => 'world',   'value' => 'MK'}, 
      {'name' => 'fighter', 'value' => 'Kano'}
    ]}
    c = ApigeePlatform::CustomAttributes.new obj 
    c.keys.to_set.should == ["world", "fighter"].to_set
  end

  it 'can delete data from source object' do 
    obj = OpenStruct.new :attributes => {'attributes' => [{'name' => 'name', 'value' => 'Kitana'}]}
    c = ApigeePlatform::CustomAttributes.new obj 
    c.delete('name')
    obj.attributes['attributes'].should be_empty
  end

end