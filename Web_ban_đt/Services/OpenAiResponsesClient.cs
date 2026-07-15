using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Options;

namespace TechStoreWeb.Services
{
    public class OpenAiResponsesClient : ILlmClient
    {
        private readonly HttpClient _httpClient;
        private readonly ChatbotOptions _options;
        private readonly ILogger<OpenAiResponsesClient> _logger;

        public OpenAiResponsesClient(HttpClient httpClient, IOptions<ChatbotOptions> options, ILogger<OpenAiResponsesClient> logger)
        {
            _httpClient = httpClient;
            _options = options.Value;
            _logger = logger;
        }

        public async Task<string?> CompleteAsync(string systemPrompt, string userPrompt, CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(_options.ApiKey))
            {
                return null;
            }

            var endpoint = ResolveEndpoint(_options.ApiUrl);
            var useChatCompletions = endpoint.Contains("/chat/completions", StringComparison.OrdinalIgnoreCase);
            var request = useChatCompletions
                ? CreateChatCompletionsRequest(systemPrompt, userPrompt)
                : CreateResponsesRequest(systemPrompt, userPrompt);

            using var httpRequest = new HttpRequestMessage(HttpMethod.Post, endpoint);
            httpRequest.Headers.Authorization = new AuthenticationHeaderValue("Bearer", _options.ApiKey);
            httpRequest.Content = new StringContent(JsonSerializer.Serialize(request), Encoding.UTF8, "application/json");

            try
            {
                using var response = await _httpClient.SendAsync(httpRequest, cancellationToken);
                var body = await response.Content.ReadAsStringAsync(cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("LLM provider returned {StatusCode}: {Body}", response.StatusCode, body);
                    return null;
                }

                return useChatCompletions ? ExtractChatCompletionsText(body) : ExtractResponsesText(body);
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "Cannot call LLM provider.");
                return null;
            }
        }

        private object CreateChatCompletionsRequest(string systemPrompt, string userPrompt)
        {
            return new
            {
                model = _options.Model,
                messages = new object[]
                {
                    new { role = "system", content = systemPrompt },
                    new { role = "user", content = userPrompt }
                },
                temperature = 0.3
            };
        }

        private object CreateResponsesRequest(string systemPrompt, string userPrompt)
        {
            return new
            {
                model = _options.Model,
                input = new object[]
                {
                    new
                    {
                        role = "system",
                        content = new object[] { new { type = "input_text", text = systemPrompt } }
                    },
                    new
                    {
                        role = "user",
                        content = new object[] { new { type = "input_text", text = userPrompt } }
                    }
                }
            };
        }

        private static string ResolveEndpoint(string apiUrl)
        {
            var trimmed = apiUrl.TrimEnd('/');
            if (trimmed.EndsWith("/v1", StringComparison.OrdinalIgnoreCase))
            {
                return $"{trimmed}/chat/completions";
            }

            return apiUrl;
        }

        private static string? ExtractChatCompletionsText(string json)
        {
            using var document = JsonDocument.Parse(json);
            if (!document.RootElement.TryGetProperty("choices", out var choices) || choices.ValueKind != JsonValueKind.Array)
            {
                return null;
            }

            var first = choices.EnumerateArray().FirstOrDefault();
            if (first.ValueKind == JsonValueKind.Undefined)
            {
                return null;
            }

            if (first.TryGetProperty("message", out var message) &&
                message.TryGetProperty("content", out var content))
            {
                return content.GetString();
            }

            return first.TryGetProperty("text", out var text) ? text.GetString() : null;
        }

        private static string? ExtractResponsesText(string json)
        {
            using var document = JsonDocument.Parse(json);
            if (document.RootElement.TryGetProperty("output_text", out var outputText))
            {
                return outputText.GetString();
            }

            if (!document.RootElement.TryGetProperty("output", out var output) || output.ValueKind != JsonValueKind.Array)
            {
                return null;
            }

            var builder = new StringBuilder();
            foreach (var item in output.EnumerateArray())
            {
                if (!item.TryGetProperty("content", out var content) || content.ValueKind != JsonValueKind.Array)
                {
                    continue;
                }

                foreach (var contentItem in content.EnumerateArray())
                {
                    if (contentItem.TryGetProperty("text", out var text))
                    {
                        builder.AppendLine(text.GetString());
                    }
                }
            }

            var result = builder.ToString().Trim();
            return string.IsNullOrWhiteSpace(result) ? null : result;
        }
    }
}
