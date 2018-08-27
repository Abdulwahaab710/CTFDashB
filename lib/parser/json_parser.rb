# frozen_string_literal: true

require 'open-uri'

module Parser
  class JsonParser
    def initialize(challenges, token)
      @challenges = challenges
      @token = token
      create_challenges
    end

    private

    attr_reader :challenges

    def create_challenges
      challenges.each do |challenge|
        challenge_root_url = challenge[:url]
        challenge = challenge[:challenge_file]
        challenge_obj = find_or_create_challenge(
          title: challenge['title'], category: find_or_create_category(challenge['category']),
          description: challenge['description'], points: challenge['points'].to_i,
          max_tries: challenge['max_tries'], link: challenge['link'],
          flag: challenge['flag'], active: false
        )
        # add_files_challenge(challenge_obj, challenge['files'], challenge_root_url)
      end
    end

    def add_files_challenge(challenge, files, url)
      return if files.empty?
      file_urls = files.map { |f| { url: build_challenge_file_url(url, f), filename: f } }
      downloaded_files = file_urls.map { |f| { io: open(f[:url]), filename: f[:filename].gsub('./', '') } }
      downloaded_files.each do |file|
        challenge.challenge_files.attach(
          file
        )
      end
    end

    def find_or_create_category(name)
      Category.find_or_create_by(name: name)
    end

    def find_or_create_challenge(**challenge_params)
      challenge = Challenge.find_or_create_by(title: challenge_params[:title], category: challenge_params[:category])
      challenge.update(challenge_params)
      challenge
    end

    def build_challenge_file_url(challenge_root_url, file)
      file_path = extract_path(challenge_root_url).gsub('challenge_file_url', file.gsub('./', ''))
      url = "https://api.github.com/repos/h4tt/H4TT-2.2/contents/#{file_path}?access_token=#{@token}"
      byebug if JSON.parse(open(url).string).first['download_url'].nil?
      JSON.parse(open(url).string).first['download_url']
    end

    def extract_path(url)
      url[%r{/(h4tt\/H4TT-2\.2\/)([a-z0-9]+\/)([a-z_\-A-Z%0-9\/]+)?/}, 3]
    end
  end
end
