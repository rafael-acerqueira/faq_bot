require_relative './../spec_helper.rb'

describe InterpretService do
  before :each do
    @company = create(:company)
  end

  describe '#list' do
    it "With zero faqs, return don't find message" do
      response = InterpretService.call('list', {})
      expect(response).to match("Nada encontrado")
    end

    it "With two faqs, find questions and answer in response" do
      faq1 = create(:faq, company: @company)
      faq2 = create(:faq, company: @company)

      response = InterpretService.call('list', {})

      expect(response).to match(faq1.question)
      expect(response).to match(faq1.answer)

      expect(response).to match(faq2.question)
      expect(response).to match(faq2.answer)
    end
  end

  describe '#search' do
    it "With empty query, return don't find message" do
      response = InterpretService.call('search', {"query": ''})
      expect(response).to match("Nada encontrado")
    end

    it "With valid query, find question and answer in response" do
      faq = create(:faq, company: @company)

      response = InterpretService.call('search', {"query" => faq.question.split(" ").sample})

      expect(response).to match(faq.question)
      expect(response).to match(faq.answer)
    end
  end

  describe '#search by category' do
    it "With invalid hashtag, return don't find message" do
      response = InterpretService.call('search_by_hashtag', {"query": ''})
      expect(response).to match("Nada encontrado")
    end

    it "With valid hashtag, find question and answer in response" do
      faq = create(:faq, company: @company)
      hashtag = create(:hashtag, company: @company)
      create(:faq_hashtag, faq: faq, hashtag: hashtag)

      response = InterpretService.call('search_by_hashtag', {"query" => hashtag.name})

      expect(response).to match(faq.question)
      expect(response).to match(faq.answer)
    end
  end

  describe '#create' do
    before do
      @question = FFaker::Lorem.sentence
      @answer = FFaker::Lorem.sentence
      @hashtags = "#{FFaker::Lorem.word}, #{FFaker::Lorem.word}"
    end

    it "Without hashtag params, receive a error" do
      response = InterpretService.call('create', {"question.original" => @question, "answer.original" => @answer})
      expect(response).to match("Hashtag Obrigatória")
    end

    it "With valid params, receive success message" do
      response = InterpretService.call('create', {"question.original" => @question, "answer.original" => @answer, "hashtags.original" => @hashtags})
      expect(response).to match("Criado com sucesso")
    end

    it "With valid params, find question and anwser in database" do
      response = InterpretService.call('create', {"question.original" => @question, "answer.original" => @answer, "hashtags.original" => @hashtags})
      expect(Faq.last.question).to match(@question)
      expect(Faq.last.answer).to match(@answer)
    end

    it "With valid params, hashtags are created" do
      response = InterpretService.call('create', {"question.original" => @question, "answer.original" => @answer, "hashtags.original" => @hashtags})
      expect(@hashtags.split(/[\s,]+/).first).to match(Hashtag.first.name)
      expect(@hashtags.split(/[\s,]+/).last).to match(Hashtag.last.name)
    end
  end

  describe '#remove' do
    it "With valid ID, remove Faq" do
      faq = create(:faq, company: @company)
      response = InterpretService.call('remove', {"id" => faq.id})
      expect(response).to match("Deletado com sucesso")
    end

    it "With invalid ID, receive error message" do
      response = InterpretService.call('remove', {"id" => rand(1..9999)})
      expect(response).to match("Questão inválida, verifique o Id")
    end
  end

  describe '#list_links' do
    it "With zero links, return don't find message" do
      response = InterpretService.call('list_links', {})
      expect(response).to match("Nenhum link cadastrado")
    end

    it "With two links, find title and url in response" do
      link1 = create(:link)
      link2 = create(:link)

      response = InterpretService.call('list_links', {})

      expect(response).to match(link1.title)
      expect(response).to match(link1.url)

      expect(response).to match(link2.title)
      expect(response).to match(link2.url)
    end
  end

  describe '#search_link' do
    it "With empty query, return don't find message" do
      response = InterpretService.call('search_link', {"query": ''})
      expect(response).to match("Nenhum link cadastrado")
    end

    it "With valid query, find title and url in response" do
      link = create(:link)

      response = InterpretService.call('search_link', {"query" => link.title.split(" ").sample})

      expect(response).to match(link.title)
      expect(response).to match(link.url)
    end
  end

  describe '#search link by hashtag' do
    it "With invalid hashtag, return don't find message" do
      response = InterpretService.call('search_link_by_hashtag', {"query": ''})
      expect(response).to match("Nenhum link cadastrado")
    end

    it "With valid hashtag, find title and url in response" do
      link = create(:link)
      hashtag = create(:hashtag)
      create(:link_hashtag, link: link, hashtag: hashtag)

      response = InterpretService.call('search_link_by_hashtag', {"query" => hashtag.name})

      expect(response).to match(link.title)
      expect(response).to match(link.url)
    end
  end

  describe '#create_link' do
    before do
      @title = FFaker::Lorem.sentence
      @url = FFaker::Internet.http_url
      @hashtags = "#{FFaker::Lorem.word}, #{FFaker::Lorem.word}"
    end

    it "Without hashtag params, receive a error" do
      response = InterpretService.call('create_link', {"title.original" => @title, "url.original" => @url})
      expect(response).to match("Hashtag Obrigatória")
    end

    it "With valid params, receive success message" do
      response = InterpretService.call('create_link', {"title.original" => @title, "url.original" => @url, "hashtags.original" => @hashtags})
      expect(response).to match("Criado com sucesso")
    end

    it "With valid params, find title and anwser in database" do
      response = InterpretService.call('create_link', {"title.original" => @title, "url.original" => @url, "hashtags.original" => @hashtags})
      expect(Link.last.title).to match(@title)
      expect(Link.last.url).to match(@url)
    end

    it "With valid params, hashtags are created" do
      response = InterpretService.call('create_link', {"title.original" => @title, "url.original" => @url, "hashtags.original" => @hashtags})
      expect(@hashtags.split(/[\s,]+/).first).to match(Hashtag.first.name)
      expect(@hashtags.split(/[\s,]+/).last).to match(Hashtag.last.name)
    end
  end

  describe '#remove_link' do
    it "With valid ID, remove Link" do
      link = create(:link)
      response = InterpretService.call('remove_link', {"id" => link.id})
      expect(response).to match("Deletado com sucesso")
    end

    it "With invalid ID, receive error message" do
      response = InterpretService.call('remove_link', {"id" => rand(1..9999)})
      expect(response).to match("Link inválido, verifique o ID")
    end
  end
end
