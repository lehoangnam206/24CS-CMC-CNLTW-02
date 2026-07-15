using TechStoreWeb.Models.Chatbot;

namespace TechStoreWeb.Services
{
    public interface IChatbotService
    {
        Task<ChatbotAskResponse> AskAsync(string customerKey, int? userId, ChatbotAskRequest request, CancellationToken cancellationToken);
        Task<IReadOnlyList<ChatbotHistoryItemDto>> GetHistoryAsync(string customerKey, int? userId, CancellationToken cancellationToken);
    }
}
