import Foundation
import OpenWeatherMap


class WeatherManager: NSObject {
    static let shared = WeatherManager()
    static let API_KEY = "15a5654a58f6e0dbd6b1ee160786128a"
    private let weatherService = OpenWeatherMapService(apiKey: API_KEY)
    
    func fetchCurrent(completion: @escaping (CityWeather?) -> Void) {
        self.weatherService.currentWeatherAt(cityName: "London, UK") { success, forecast in
            DispatchQueue.main.async {
                guard let forecast = forecast, success == true else {
                    completion(nil)
                    return
                }
                completion(forecast)
            }
        }
    }
    
}
