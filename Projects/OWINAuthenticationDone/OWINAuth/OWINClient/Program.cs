using OWINAuth;
using System.Net.Http.Headers;

using (HttpClient httpClient1 = new HttpClient())
{
    httpClient1.BaseAddress = new Uri(baseAddress);
    httpClient1.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", token.AccessToken);
    HttpResponseMessage response = httpClient1.GetAsync("api/TestMethod").Result;
    if (response.IsSuccessStatusCode)
    {
        System.Console.WriteLine("Success");
    }
    string message = response.Content.ReadAsStringAsync().Result;
    System.Console.WriteLine("URL responese : " + message);
}