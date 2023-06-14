using OWINClient;
using System.Net.Http.Formatting;
using System.Net.Http.Headers;

string baseAddress = "https://localhost:44381";
using (var client = new HttpClient())
{
    var form = new Dictionary<string, string>
               {
                   {"grant_type", "password"},
                   {"username", "jignesh"},
                   {"password", "user123456"},
               };
    var tokenResponse = client.PostAsync(baseAddress + "/oauth/token", new FormUrlEncodedContent(form)).Result;
    //var token = tokenResponse.Content.ReadAsStringAsync().Result;
    var token = tokenResponse.Content.ReadAsAsync<Token>(new[] { new JsonMediaTypeFormatter() }).Result;
    if (string.IsNullOrEmpty(token.Error))
    {
        Console.WriteLine("Token issued is: {0}", token.AccessToken);
    }
    else
    {
        Console.WriteLine("Error : {0}", token.Error);
    }
    Console.Read();
    using (HttpClient httpClient1 = new HttpClient())
    {
        httpClient1.BaseAddress = new Uri("https://localhost:44381");
        httpClient1.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", token.AccessToken);
        HttpResponseMessage response = httpClient1.GetAsync("api/TestMethod").Result;
        if (response.IsSuccessStatusCode)
        {
            System.Console.WriteLine("Success");
        }
        string message = response.Content.ReadAsStringAsync().Result;
        System.Console.WriteLine("URL responese : " + message);
    }
}
