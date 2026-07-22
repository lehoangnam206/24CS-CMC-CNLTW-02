using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TechStoreWeb.Data;
using TechStoreWeb.Models.Chatbot;
using TechStoreWeb.Services;

namespace TechStoreWeb.Controllers
{
    [Route("chatbot")]
    public class ChatbotController : Controller
    {
        private const string VisitorSessionKey = "ChatbotVisitorId";
        private readonly AppDbContext _context;
        private readonly IChatbotService _chatbotService;

        public ChatbotController(AppDbContext context, IChatbotService chatbotService)
        {
            _context = context;
            _chatbotService = chatbotService;
        }

        [HttpGet("history")]
        public async Task<IActionResult> History(CancellationToken cancellationToken)
        {
            var identity = await ResolveCustomerIdentityAsync(cancellationToken);
            var history = await _chatbotService.GetHistoryAsync(identity.CustomerKey, identity.UserId, cancellationToken);
            return Json(history);
        }

        [HttpPost("ask")]
        [IgnoreAntiforgeryToken]
        public async Task<IActionResult> Ask([FromBody] ChatbotAskRequest? request, CancellationToken cancellationToken)
        {
            var identity = await ResolveCustomerIdentityAsync(cancellationToken);
            var response = await _chatbotService.AskAsync(identity.CustomerKey, identity.UserId, request ?? new ChatbotAskRequest(), cancellationToken);
            return Json(response);
        }

        private async Task<(string CustomerKey, int? UserId)> ResolveCustomerIdentityAsync(CancellationToken cancellationToken)
        {
            var sessionUserId = HttpContext.Session.GetInt32("UserId");
            if (sessionUserId != null)
            {
                var exists = await _context.Users.AnyAsync(u => u.UserId == sessionUserId.Value, cancellationToken);
                if (exists)
                {
                    return ($"user:{sessionUserId.Value}", sessionUserId.Value);
                }
            }

            var visitorId = HttpContext.Session.GetString(VisitorSessionKey);
            if (string.IsNullOrWhiteSpace(visitorId))
            {
                visitorId = Guid.NewGuid().ToString("N");
                HttpContext.Session.SetString(VisitorSessionKey, visitorId);
            }

            return ($"guest:{visitorId}", null);
        }
    }
}
