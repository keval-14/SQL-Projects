using OWINAuthenticationAPI.Models;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Formatting;

namespace OWINAuthenticationAPI
{
    class Program
    {
        static void Main(string[] args)
        {
            string baseAddress = "http://localhost:4312";
            using (var client = new HttpClient())
            {
                var form = new Dictionary<string, string>
               {
                   {"grant_type", "password"},
                   {"username", "jignesh"},
                   {"password", "12345"},
               };
                var tokenResponse = client.PostAsync(baseAddress + "/oauth/token", new FormUrlEncodedContent(form)).Result;
                //var token = tokenResponse.Content.ReadAsStringAsync().Result;
                var token = tokenResponse.Content.ReadAsAsync<Owintest>(new[] { new JsonMediaTypeFormatter() }).Result;
                if (string.IsNullOrEmpty(token.Error))
                {
                    Console.WriteLine("Token issued is: {0}", token.AccessToken);
                }
                else
                {
                    Console.WriteLine("Error : {0}", token.Error);
                }
                Console.Read();
            }
        }
    }
}