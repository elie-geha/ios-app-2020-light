import Foundation
import Moya

enum UndergroundTarget {
    case authenticateUser(name: String, userid: String, acessToken: String, photourl: String, isfb: Bool)
    case sharedApplication(userid: String, country: String, city: String)

    case getBannerImagesAPI(country: Country, city: City)
    case getPromotionsAPI(type: PlaceType, country: Country, city: City)
    case getPlaces(type: PlaceType, country: Country, city: City)
    case getMetroListForStoreAPI(type: PlaceType, country: Country, city: City)
    case getCountriesList
    case getCitiesList
}

extension UndergroundTarget: TargetType {
    var headers: [String: String]? {
        return nil
    }
    
    var baseURL: URL {
        return URL(string: AppConstants.API.URL_BASE)!
    }
    
    var path: String {
        switch self {
        case .authenticateUser:
            return "registerUser"
        case .sharedApplication(_, let country, let city):
            return "\(country)/\(city)/sharedApplication"
        case .getBannerImagesAPI(let country, let city):
            return "\(country.name)/\(city.name)/getbannerimages"
        case .getPlaces(_, let country, let city):
            return "\(country.name)/\(city.name)/getPlaces"
        case .getPromotionsAPI(_, let country, let city):
            return "\(country.name)/\(city.name)/getplacesforar"
        case .getMetroListForStoreAPI(_, let country, let city):
            return "\(country.name)/\(city.name)/getMetroListForStore"
        case .getCitiesList:
            return "getcities"
        case .getCountriesList:
            return "getCountry"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .authenticateUser, .sharedApplication:
            return .post
        default:
            return .get
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .authenticateUser(let name, let userid, let acessToken, let photourl, let isfb):
            return .requestParameters(parameters: [
                "name": name,
                "userid": userid,
                "token": acessToken,
                "pictureUrl": photourl,
                "isfb": isfb
                ], encoding: URLEncoding.default)
            
        case .sharedApplication(let userid, _, _):
            return .requestParameters(parameters: ["userid": userid], encoding: URLEncoding.default)

        case .getBannerImagesAPI(_, _),
             .getCountriesList,
            .getCitiesList:
            return .requestPlain
        
        case .getPromotionsAPI(let type, _, _),
             .getMetroListForStoreAPI(let type, _, _),
             .getPlaces(let type, _, _):
            return .requestParameters(parameters: ["type": type.apiValue], encoding: URLEncoding.default)
        }
    }
}

