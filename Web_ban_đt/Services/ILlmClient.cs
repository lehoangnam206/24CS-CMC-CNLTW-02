namespace TechStoreWeb.Services
{
    public interface ILlmClient
    {
        Task<string?> CompleteAsync(string systemPrompt, string userPrompt, CancellationToken cancellationToken);
    }
}
