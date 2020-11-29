import showAlert
import Alamofire

public protocol SearchCityErrorParser: Error {
	@discardableResult
	func parser(searchCityError: Error) -> Error
}

public class ErrorHandler: SearchCityErrorParser, showAlert {
	public init() {}
	public func parser(searchCityError: Error) -> Error {
		guard let error = searchCityError.asAFError else { return searchCityError }
		let description = "☂️⚠️ -> " + (error.errorDescription ?? "")
		switch true {
		case error.isResponseSerializationError:
			showAlert(message: "Incorrect city")
			print(description)
		case error.isSessionTaskError:
			showAlert(message: "No conection")
			print(description)
		case error.isCreateURLRequestError:
			print(description)
		case error.isInvalidURLError:
			print(description)
		case error.isCreateUploadableError:
			print(description)
		default:
			print(description)
		}
		return error
	}
}
