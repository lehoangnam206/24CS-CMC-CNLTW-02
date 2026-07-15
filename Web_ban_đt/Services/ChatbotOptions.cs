namespace TechStoreWeb.Services
{
    public class ChatbotOptions
    {
        public string Provider { get; set; } = "OpenAI";
        public string Model { get; set; } = "gpt-4o";
        public string? ApiKey { get; set; }
        public string ApiUrl { get; set; } = "https://api.yescale.io/v1/chat/completions";
        public int MaxRetrievedChunks { get; set; } = 8;
    }
}
