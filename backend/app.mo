import Debug "mo:base/Debug";
import Error "mo:base/Error";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Int "mo:base/Int";
import Blob "mo:base/Blob"; // Blob kept for future extensions

actor WeatherAPI {
  // Define a type for weather data response
  public type WeatherData = {
    temperature: Float;
    humidity: Float;
    description: Text;
    location: Text;
    timestamp: Int;
  };

  // Default weather data
  let defaultWeather: WeatherData = {
    temperature = 0.0;
    humidity = 0.0;
    description = "Unknown";
    location = "Unknown";
    timestamp = 0;
  };

  // Function to fetch weather data (SIMULATED for now)
  public func getWeather(city: Text) : async WeatherData {
    Debug.print("Fetching weather data for " # city);
    
    return {
      temperature = 25.0; // Example temperature
      humidity = 60.0;    // Example humidity
      description = "Sunny"; 
      location = city;
      timestamp = Time.now();
    };
  };

  // Cache the weather data with a timestamp
  private var cachedWeather: WeatherData = defaultWeather;
  private var lastUpdate: Int = 0;
  private let cacheValidityPeriod: Int = 3600 * 1000 * 1000 * 1000; // 1 hour in nanoseconds

  // Get weather with caching
  public func getCachedWeather(city: Text) : async WeatherData {
    let currentTime = Time.now();
    
    // Check if cache is valid or if a different city was requested
    if (currentTime - lastUpdate > cacheValidityPeriod or cachedWeather.location != city) {
      cachedWeather := await getWeather(city);
      lastUpdate := currentTime;
    };
    
    return cachedWeather;
  };
}
