require_relative './../../spec_helper.rb'

describe LinkModule::RemoveService do
  describe '#call' do
    it "With valid ID, remove Link" do
      link = create(:link)
      @removeService = LinkModule::RemoveService.new({"id" => link.id})
      response = @removeService.call()

      expect(response).to match("Deletado com sucesso")
    end

    it "With invalid ID, receive error message" do
      @removeService = LinkModule::RemoveService.new({"id" => rand(1..9999)})
      response = @removeService.call()

      expect(response).to match("Link inválido, verifique o ID")
    end
  end
end
