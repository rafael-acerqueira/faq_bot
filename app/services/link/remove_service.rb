module LinkModule
  class RemoveService
    def initialize(params)
      @params = params
      @id = params["id"]
    end

    def call
      link = Link.where(id: @id).last
      return "Link inválido, verifique o Id" unless link

      Link.transaction do
        # Deleta as tags associadas que não estejam associadas a outros links
        link.hashtags.each do |h|
          if h.links.count <= 1
            h.delete
          end
        end
        link.delete
        "Deletado com sucesso"
      end
    end
  end
end