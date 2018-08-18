# frozen_string_literal: true

require_relative 'error'

module Scraper
  class GithubScraper
    def initialize(filename: 'challenge.json', format: 'json', repo: nil, access_token: nil)
      @filename = filename
      @format = format
      @repo = repo
      @access_token = access_token
      validate_params
    end

    def challenges
      files = send_request(build_url)
      files_url = extract_challenge_files(files)
      files_details = download_challenge_files(files_url)
      files_raw_url = extract_download_files(files_details)
      download_files(files_raw_url)
    end

    private

    def validate_params
      raise FileNameIsMissing if @filename.nil?
      raise FormatIsMissing if @format.nil?
      raise RepoIsMissing if @repo.nil?
    end

    def download_files(files)
      challenge_files = []
      files.each do |url|
        url.to_s
        challenge_files << {
          challenge_file: JSON.parse(send_request(url, parse: false)),
          url: challenge_root_url(url)
        }
      end
      challenge_files
    end

    def extract_download_files(response)
      response.map { |f| URI.parse((f['download_url']).to_s) if f['download_url'] }
    end

    def build_url
      URI.parse("https://api.github.com/search/code?#{url_query}")
    end

    def send_request(uri, parse: true)
      res = get_reguest(uri)
      res = parse_response(res) if parse
      res
    end

    def get_reguest(uri)
      res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Get.new(uri)
        http.request(req)
      end
      res.body
    end

    def parse_response(response)
      JSON.parse(response)
    end

    def extract_challenge_files(files)
      files['items'].map { |f| URI.parse("#{f['url']}&access_token=#{@access_token}") if f['url'] }
    end

    def download_challenge_files(urls)
      files = []
      urls.each do |url|
        files << send_request(url)
      end
      files
    end

    def challenge_root_url(path)
      path.to_s.gsub(@filename, 'challenge_file_url')
    end

    def url_query
      "q=filename:#{@filename}+language:#{@format}+repo:#{@repo}&access_token=#{@access_token}"
    end
  end
end
