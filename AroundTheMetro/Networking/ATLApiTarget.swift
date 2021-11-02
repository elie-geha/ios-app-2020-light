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
	case getJobs(page: Int, location: String, keyword: String)
}

extension UndergroundTarget: TargetType {
    var headers: [String: String]? {
        return nil
    }
    
    var baseURL: URL {
		switch self {
		case .getJobs(_, _, _):
			return URL(string: "http://jobs.aroundthemetro.com")!
		default:
			return URL(string: AppConstants.API.urlBase)!
		}
    }
    
    var path: String {
        switch self {
        case .authenticateUser:
            return "registerUser"
        case .sharedApplication(_, let country, let city):
            return "\(country)/\(city)/sharedApplication"
        case .getBannerImagesAPI(let country, let city):
            return "\(country.name)/\(city.plistName ?? city.name)/getbannerimages"
        case .getPlaces(_, let country, let city):
            return "\(country.name)/\(city.plistName ?? city.name)/getPlaces"
        case .getPromotionsAPI(_, let country, let city):
            return "\(country.name)/\(city.plistName ?? city.name)/getplacesforar"
        case .getMetroListForStoreAPI(_, let country, let city):
            return "\(country.name)/\(city.plistName ?? city.name)/getMetroListForStore"
        case .getCitiesList:
            return "getcities"
        case .getCountriesList:
            return "getCountry"
		case .getJobs(_, _, _):
			return "/index.php"
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
		case .getJobs(let page,let location, let keyword):
			return .requestParameters(parameters: ["code" : "am9ic1BvcnRhbEFwaQ==","Keyword":keyword, "Location":location,"Page":page], encoding: URLEncoding.queryString)
        }
    }
}

