require 'summoner'
require 'match'

class PlacementsController < ApplicationController
  def index
    puuid = Summoner.new.by_name(summoner_name)['puuid']
    match_ids = Match.new.by_puuid(puuid)
    matches = match_ids.take(3).map { |match_id| Match.new.by_id(match_id) }
    matches_participants = matches.map { |match| match['info']['participants'] }

    result =
      matches_participants.reduce({}) do |acc, match_participants|
        placements_by_puuid = match_participants.reduce({}) do |acc, match_participant|
          acc.merge(match_participant['puuid'] => match_participant['placement'])
        end

        placements_by_puuid.reduce(acc) do |acc, (k, v)|
          acc[k] = acc[k].nil? ? [v] : acc[k] + [v]
          acc
        end
      end

    summoners = result.keys.map { |puuid| Summoner.new.by_puuid(puuid) }
    result.keys.each do |puuid|
      summoner = summoners.find { |summoner| summoner['puuid'] == puuid }

      result[summoner['name']] = result.delete puuid
    end

    response = result.reduce([]) do |acc, (k, v)|
      scores = v.map { |placement| to_score(placement) }
      acc.push({
        "name" => k,
        "placements" => v,
        "scores" => scores,
        "total_score" => scores.sum
      })
    end

    render status: :ok, json: response
  end

  private

  def summoner_name
    params[:summoner_name]
  end

  def to_score(placement)
    case placement
    when 1
      10
    when 2
      8
    when 3
      7
    when 4
      6
    when 5
      4
    when 6
      3
    when 7
      2
    when 8
      1
    end
  end
end
