require_relative './../../spec_helper.rb'

describe LinkModule::CreateService do
  before do
    @title = FFaker::Lorem.sentence
    @url = FFaker::Internet.http_url
    @hashtags = "#{FFaker::Lorem.word}, #{FFaker::Lorem.word}"
  end

  describe '#call' do
    it "Without hashtag params, will receive a error" do
      @createService = LinkModule::CreateService.new({"title.original" => @title, "url.original" => @url})

      response = @createService.call()
      expect(response).to match("Hashtag Obrigatória")
    end

    it "With valid params, receive success message" do
      @createService = LinkModule::CreateService.new({"title.original" => @title, "url.original" => @url, "hashtags.original" => @hashtags})

      response = @createService.call()
      expect(response).to match("Criado com sucesso")
    end

    it "With valid params, find title and anwser in database" do
      @createService = LinkModule::CreateService.new({"title.original" => @title, "url.original" => @url, "hashtags.original" => @hashtags})

      response = @createService.call()
      expect(Link.last.title).to match(@title)
      expect(Link.last.url).to match(@url)
    end

    it "With valid params, hashtags are created" do
      @createService = LinkModule::CreateService.new({"title.original" => @title, "url.original" => @url, "hashtags.original" => @hashtags})

      response = @createService.call()
      expect(@hashtags.split(/[\s,]+/).first).to match(Hashtag.first.name)
      expect(@hashtags.split(/[\s,]+/).last).to match(Hashtag.last.name)
    end
  end
end
