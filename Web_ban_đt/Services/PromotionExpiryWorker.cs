namespace TechStoreWeb.Services
{
    /// <summary>
    /// Định kỳ tính lại giá khuyến mại để chương trình tự bắt đầu khi tới StartDate
    /// và tự gỡ khi qua EndDate mà không cần admin bấm tay.
    /// </summary>
    public class PromotionExpiryWorker : BackgroundService
    {
        private static readonly TimeSpan Interval = TimeSpan.FromMinutes(10);

        private readonly IServiceScopeFactory _scopeFactory;
        private readonly ILogger<PromotionExpiryWorker> _logger;

        public PromotionExpiryWorker(IServiceScopeFactory scopeFactory, ILogger<PromotionExpiryWorker> logger)
        {
            _scopeFactory = scopeFactory;
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    using var scope = _scopeFactory.CreateScope();
                    var promotionService = scope.ServiceProvider.GetRequiredService<IPromotionService>();
                    await promotionService.SyncAsync(stoppingToken);
                }
                catch (OperationCanceledException)
                {
                    break;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Không đồng bộ được khuyến mại.");
                }

                try
                {
                    await Task.Delay(Interval, stoppingToken);
                }
                catch (OperationCanceledException)
                {
                    break;
                }
            }
        }
    }
}
