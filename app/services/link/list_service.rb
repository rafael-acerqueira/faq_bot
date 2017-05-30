module LinkModule
  class ListService
    def initialize(params, action)
      @action = action
      @query = params["query"]
    end

    def call
      if @action == "search"
        links = Link.search(@query)
      elsif @action == "search_link_by_hashtag"
        links = Link.all.select { |link| link.hashtags.pluck(:name).include?(@query)}
      else
        links = Link.all
      end

      response = "*Lista de Links Salvos* \n\n"
      links.each do |l|
        response += "*#{l.id}* - "
        response += "*#{l.title}*\n"
        response += ">#{l.url}\n"
        l.hashtags.each do |h|
          response += "_##{h.name}_ "
        end
        response += "\n\n"
      end
      (links.count > 0)? response : "Nenhum link cadastrado"
    end
  end
end
