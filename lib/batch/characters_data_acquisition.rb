require "digest/md5"
require "open-uri"
require "json"

public_api_key = ENV["MARVEL_PUBLICK_API_KEY"]
private_api_key = ENV["MARVEL_PRIVATE_API_KEY"]
timestamp = Time.now.to_i.to_s
hash = Digest::MD5.hexdigest("#{timestamp}#{private_api_key}#{public_api_key}")

limit = 20
offset = 0
count = 1

results = []

unless public_api_key && private_api_key
  puts "APIキーが設定されていません"
end

loop do
  detail_query = URI.encode_www_form(
    ts: timestamp,
    apikey: public_api_key,
    hash: hash,
    offset: offset,
    limit: limit
  )
  characters_url = "https://gateway.marvel.com:443/v1/public/characters?#{detail_query}"

  characters_page = URI.open(characters_url).read
  characters_data = JSON.parse(characters_page)

  characters_data["data"]["results"].each do |character|
    results << {
      name: character["name"],
      description: character["description"],
      path: character["thumbnail"]["path"],
      extension: character["thumbnail"]["extension"]
    }
  end

  puts "ページ#{count}のデータを取得しました"

  offset += limit
  break if offset >= characters_data["data"]["total"]

  count += 1
end

results.each do |result|
  Character.create!(
    name: result[:name],
    description: result[:description],
    path: result[:path],
    extension: result[:extension]
  )
end

puts "全てのデータをデータベースに保存しました"