# frozen_string_literal: true

class Match
  def by_puuid(puuid)
    response = conn.get("/tft/match/v1/matches/by-puuid/#{puuid}/ids")
    JSON.parse(response.body)
  end
  
  def by_id(id)
    response = conn.get("/tft/match/v1/matches/#{id}")
    JSON.parse(response.body)
  end

  def conn
    Faraday.new(
      url: 'https://americas.api.riotgames.com',
      headers: {'X-Riot-Token' => ENV['RIOT_API_KEY']}
    )
  end
end
