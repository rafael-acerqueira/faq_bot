module LinkModule
  class CreateService
    def initialize(params)
      @title = params["title.original"]
      @url = params["url.original"]
      @hashtags = params["hashtags.original"]
    end

    def call
      Link.transaction do
        link = Link.create(title: @title, url: @url)
        return "Hashtag Obrigatória" if @hashtags.nil?
        @hashtags.split(/[\s,]+/).each do |hashtag|
          link.hashtags << Hashtag.create(name: hashtag)
        end
      end
      "Criado com sucesso"
    end
  end
end
