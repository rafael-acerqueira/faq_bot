require_relative './../../spec_helper.rb'

describe LinkModule::ListService do

  describe '#call' do
    it "with list command: With zero links, return don't find message" do
      @listService = LinkModule::ListService.new({}, 'list_links')

      response = @listService.call()
      expect(response).to match("Nenhum link cadastrado")
    end

    it "With two links, find title and url in response" do
      @listService = LinkModule::ListService.new({}, 'list_links')

      link1 = create(:link)
      link2 = create(:link)

      response = @listService.call()

      expect(response).to match(link1.title)
      expect(response).to match(link1.url)

      expect(response).to match(link2.title)
      expect(response).to match(link2.url)
    end

    it "with search command: With empty query, return don't find message" do
      @listService = LinkModule::ListService.new({'query' => ''}, 'search_link')

      response = @listService.call()
      expect(response).to match("Nenhum link cadastrado")
    end

    it "with search command: With valid query, find title and url in response" do
      link = create(:link)

      @listService = LinkModule::ListService.new({'query' => link.title.split(" ").sample}, 'search_link')

      response = @listService.call()

      expect(response).to match(link.title)
      expect(response).to match(link.url)
    end

    it "with search_link_by_hashtag command: With invalid hashtag, return don't find message" do
      @listService = LinkModule::ListService.new({'query' => ''}, 'search_link_by_hashtag')

      response = @listService.call()
      expect(response).to match("Nenhum link cadastrado")
    end

    it "with search_link_by_hashtag command: With valid hashtag, find title and answer in url" do
      link = create(:link)
      hashtag = create(:hashtag)
      create(:link_hashtag, link: link, hashtag: hashtag)

      @listService = LinkModule::ListService.new({'query' => hashtag.name}, 'search_link_by_hashtag')

      response = @listService.call()

      expect(response).to match(link.title)
      expect(response).to match(link.url)
    end
  end
end
