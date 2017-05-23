module LinkModule
  class ListService
    def initialize(params, action)
      @action = action
      @query = params["query"]
    end

    def call
      if @action == "search"
        links = Link.search(@query)
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
