public class MobileAppTestController {

    public String userAgent { get; set; }

    public MobileAppTestController() {
        userAgent = ApexPages.currentPage().getHeaders().get('User-Agent');
        
    }
}