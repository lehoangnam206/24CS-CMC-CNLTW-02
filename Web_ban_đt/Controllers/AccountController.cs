using Microsoft.AspNetCore.Mvc;

namespace TechStoreWeb.Controllers
{
    public class AccountController : Controller
    {
        public IActionResult Login() => View();
        public IActionResult Register() => View();
    }
}