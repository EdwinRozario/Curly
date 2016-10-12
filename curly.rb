# frozen_string_literal: true
require 'addressable/uri'
require 'json'
require 'pry'

# Curly class
# Initialize with the domain name, fomart and any common parameter
# used in every api call like an api_key
class Curly
  attr_accessor :domain, :format, :constant_params

  def initialize(domain, format, params)
    @domain = domain
    @format = format
    @constant_params = params
  end

  def get(path, params = {})
    complete_url = "'#{domain}/#{path}.#{format}?#{make_params(constant_params.merge(params))}'"
    call(complete_url, 'GET')
  end

  def post(path, data)
    complete_url = "-X POST -H 'Content-Type: application/json' -d '#{data.to_json}' '#{domain}/#{path}.#{format}?#{make_params(constant_params)}'"
    call(complete_url, 'POST')
  end

  def patch(path, data)
    complete_url = "-X PATCH -H 'Content-Type: application/json' -d '#{data.to_json}' '#{domain}/#{path}.#{format}?#{make_params(constant_params)}'"
    call(complete_url, 'PATCH')
  end

  def make_params(params)
    nested_query = ''
    params.each do |param, value|
      if value.is_a? Hash
        params.delete(param)
        nested_query += "&#{param}\\[#{value.keys.first}\\]=#{value[value.keys.first]}"
      end
    end

    uri = Addressable::URI.new
    uri.query_values = params
    nested_query.empty? ? uri.query : "#{uri.query}#{nested_query}"
  end

  def call(data, method)
    response = `curl -s #{data}`
    puts "#{method}: #{data}"

    response_value = JSON.parse(response)
    puts "RESPONSE: #{response_value}"
    p '-------------------------------------------------------------------------------------------------------------------------'
    response_value
  end
end

# curly = Curly.new('http://localhost:3000', :json, api_key: 'RYAVDhaqNsCyyYtssLFE')

curly = Curly.new('http://api.dnz0a.digitalnz.org', :json, api_key: '387d16c7596c9cfff190d14a81ec189a')

# curly.post('stories/57fe9883297b1f1f63000630/story_items',
#            { block: { type: 'text', sub_type: 'heading',
#                           content: { value: 'Value text here' },
#                           meta: {} } })

curly.get('records', { and: { category: 'Images' } })


# TEST CALLS
# curly.get('stories')
# curly.get('stories/57fd697769ae851c55000000')
# curly.get('stories/57fd697769ae851c55000000/story_items')
# curly.get('stories/57fd697769ae851c55000000/story_items/57fd885169ae851eed000000')
# curly.post('stories', { name: 'New Story For Test'})
# curly.post('stories/57fd697769ae851c55000000/story_items', {})
# curly.post('stories/57fd697769ae851c55000000/story_items', { block: {}})
# curly.post('stories/57fd697769ae851c55000000/story_items',
#            { block: { type: 'texting', sub_type: 'header' } })

# curly.post('stories/57fd697769ae851c55000000/story_items',
#            { block: { type: 'text', sub_type: 'heading' } })

# curly.post('stories/57fd697769ae851c55000000/story_items',
#            { block: { type: 'text', sub_type: 'heading',
#                           content: {}, meta: {} } })

# curly.post('stories/57fd697769ae851c55000000/story_items',
#            { block: { type: 'text', sub_type: 'heading',
#                           content: { value: 'Value text here' },
#                           meta: {} } })

# curly.patch('stories/57fd697769ae851c55000000/story_items/57fd885169ae851eed000000', {
#   item: { type: 'text', sub_type: 'heading',
#                           content: { value: 'Updated Text Again' },
#                           meta: {} }
#   })


# curly.post('stories/57fe9883297b1f1f63000630/story_items',
#            { block: { type: 'text', sub_type: 'heading',
#                           content: { value: 'This is the new heading' },
#                           meta: {} } })



