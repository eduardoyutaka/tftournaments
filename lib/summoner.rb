# frozen_string_literal: true

class Summoner
  def by_name(summoner_name)
    response = conn.get("tft/summoner/v1/summoners/by-name/#{summoner_name}")
    JSON.parse(response.body)
  end

  def by_puuid(puuid)
    response = conn.get("tft/summoner/v1/summoners/by-puuid/#{puuid}")
    JSON.parse(response.body)
  end

  def conn
    Faraday.new(
      url: 'https://br1.api.riotgames.com',
      headers: {'X-Riot-Token' => ENV['RIOT_API_KEY']}
    )
  end
end
