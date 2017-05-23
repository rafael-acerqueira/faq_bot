class InterpretService
  def self.call action, params
    case action
    when "list", "search", "search_by_hashtag"
      FaqModule::ListService.new(params, action).call()
    when "create"
      FaqModule::CreateService.new(params).call()
    when "remove"
      FaqModule::RemoveService.new(params).call()
    when "help"
      HelpService.call()
    when "list_links", "search_link", "search_link_by_hashtag"
      LinkModule::ListService.new(params, action).call()
    when "create_link"
      LinkModule::CreateService.new(params).call()
    when "remove_link"
      LinkModule::RemoveService.new(params).call()
    else
      "Não compreendi o seu desejo"
    end
  end
end
