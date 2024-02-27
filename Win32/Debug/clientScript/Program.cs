using System.Net.Sockets;
using System.Text;

class Client
{
    static void Main(string[] args)
    // read the request
    {
        if (args.Length > 0)
        {
            switch (args[0])
            {
                case "marketplace":
                    AppendFile("history.txt", string.Join(" ", args));
                    RequestMarketplace();
                    UnAppendFile("history.txt");
                    break;
                case "balance":
                    AppendFile("history.txt", string.Join(" ", args));
                    if (args.Length > 1)
                    {
                        RequestBalance(args[1]);
                        UnAppendFile("history.txt");
                    }
                    break;
                case "send_undelivered":
                    SendUnprocessedRequests();
                    break;
                case "clear_history":
                    ClearHistory();
                    break;
                case "show_history":
                    ShowHistory();
                    break;
                case "request_profile":
                    AppendFile("history.txt", string.Join(" ", args));
                    if (args.Length > 2)
                    {
                        RequestProfile(args[1], args[2]);
                        UnAppendFile("history.txt");
                    }
                    else
                    {
                        Console.WriteLine("Expected: request_profile [student code] [password]");
                    }
                    break;
                default:
                    break;
            }
        }
    }

    private static void ShowHistory()
    {
        string[] history = ReadFile("history.txt");

        foreach (string line in history)
        {
            Console.WriteLine(line);
        }
    }

    private static void RequestProfile(string studentCode, string password)
    // Request a new profile
    {
        try
        {
            TcpClient client = new("127.0.0.1", 12345);
            NetworkStream clientStream = client.GetStream();

            byte[] data = Encoding.ASCII.GetBytes($"profile_request {studentCode} {password}");
            clientStream.Write(data, 0, data.Length);

            byte[] receive = new byte[1024];
            int bytesRead = clientStream.Read(receive, 0, receive.Length);
            string responce = Encoding.ASCII.GetString(receive, 0, bytesRead);

            Log(Convert.ToBoolean(responce) ? "Request approved" : "Request rejected");

            client.Close();
        }
        catch (Exception)
        {
            throw;
        }
    }

    static void ClearHistory()
    {
        WriteFile("history.txt", "");
    }

    static void SendUnprocessedRequests()
    // Send all the requests that the server missed
    {
        int total = 0;
        string[] unprocessedRequests = ReadFile("history.txt");

        foreach (string unprocessedRequest in unprocessedRequests)
        {
            Main(unprocessedRequest.Split(" "));
            total += 1;
        }
        ClearHistory();
        Log($"Sent {total} unprocessed requests");
    }

    static void RequestBalance(string studentCode)
    // ask the server for the current client's balance
    {
        try
        {
            TcpClient client = new("127.0.0.1", 12345);
            NetworkStream clientStream = client.GetStream();

            byte[] data = Encoding.ASCII.GetBytes($"balance {studentCode}");
            clientStream.Write(data, 0, data.Length);

            byte[] receive = new byte[1024];
            int bytesRead = clientStream.Read(receive, 0, receive.Length);
            string responce = Encoding.ASCII.GetString(receive, 0, bytesRead);

            WriteFile("balance.csv", responce);
            Log("Received balance");

            client.Close();
        }
        catch (Exception)
        {
            throw;
        }
    }

    static void RequestMarketplace()
    // request the current marketplace
    {
        try
        {
            TcpClient client = new("127.0.0.1", 12345);
            NetworkStream clientStream = client.GetStream();

            byte[] data = Encoding.ASCII.GetBytes("marketplace");
            clientStream.Write(data, 0, data.Length);

            byte[] receive = new byte[1024];
            int bytesRead = clientStream.Read(receive, 0, receive.Length);
            string responce = Encoding.ASCII.GetString(receive, 0, bytesRead);

            WriteFile("marketplace.csv", responce);
            Log("Received marketplace");
            client.Close();
        }
        catch (Exception)
        {
            throw;
        }
    }

    static void WriteFile(string filePath, string content)
    {
        try
        {
            File.WriteAllText(filePath, content);
        }
        catch (Exception e)
        {
            Log($"An error occurred: {e.Message}");
        }
    }

    static void AppendFile(string filePath, string content)
    {
        try
        {
            File.AppendAllText(filePath, content + "\n");
        }
        catch (Exception e)
        {
            Console.WriteLine($"An error occurred: {e.Message}");
        }
    }

    static string[] ReadFile(string path)
    {
        try
        {
            return File.ReadAllLines(path);
        }
        catch (Exception e)
        {
            Log($"An error occurred: {e.Message}");
            return [];
        }
    }

    static void UnAppendFile(string path)
    {
        try
        {
            string[] fileContent = ReadFile(path);
            fileContent = fileContent.Take(fileContent.Length - 2).ToArray();
            WriteFile(path, string.Join("\n", fileContent));
        }
        catch (Exception e)
        {
            Log($"An error occurred: {e.Message}");
        }
    }

    static void Log(string logMessage)
    {
        string msg = $"[{DateTime.Now}] " + logMessage;
        AppendFile("client.log", msg);
        Console.WriteLine(msg);
    }
}
