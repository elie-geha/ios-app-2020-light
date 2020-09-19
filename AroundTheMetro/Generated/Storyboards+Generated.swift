// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum Authorization: StoryboardType {
    internal static let storyboardName = "Authorization"

    internal static let initialScene = InitialSceneType<AroundTheMetro.AuthorizationViewController>(storyboard: Authorization.self)

    internal static let registrationViewController = SceneType<AroundTheMetro.RegistrationViewController>(storyboard: Authorization.self, identifier: "RegistrationViewController")
  }
  internal enum Home: StoryboardType {
    internal static let storyboardName = "Home"

    internal static let initialScene = InitialSceneType<AroundTheMetro.HomeViewController>(storyboard: Home.self)

    internal static let locateMetroViewController = SceneType<AroundTheMetro.LocateMetroViewController>(storyboard: Home.self, identifier: "LocateMetroViewController")

    internal static let metroPlanViewController = SceneType<AroundTheMetro.MetroPlanViewController>(storyboard: Home.self, identifier: "MetroPlanViewController")

    internal static let homeViewController = SceneType<AroundTheMetro.HomeViewController>(storyboard: Home.self, identifier: "homeViewController")
  }
  internal enum Menu: StoryboardType {
    internal static let storyboardName = "Menu"

    internal static let initialScene = InitialSceneType<AroundTheMetro.MenuViewController>(storyboard: Menu.self)

    internal static let changeCityViewController = SceneType<AroundTheMetro.ChangeCityViewController>(storyboard: Menu.self, identifier: "ChangeCityViewController")
  }
  internal enum OnBoarding: StoryboardType {
    internal static let storyboardName = "OnBoarding"

    internal static let onBoardingViewController = SceneType<AroundTheMetro.OnBoardingViewController>(storyboard: OnBoarding.self, identifier: "OnBoardingViewController")
  }
  internal enum Places: StoryboardType {
    internal static let storyboardName = "Places"

    internal static let allPlacesListViewController = SceneType<AroundTheMetro.AllPlacesListViewController>(storyboard: Places.self, identifier: "AllPlacesListViewController")

    internal static let metroListViewController = SceneType<AroundTheMetro.MetroListViewController>(storyboard: Places.self, identifier: "MetroListViewController")

    internal static let placeDetailViewController = SceneType<AroundTheMetro.PlaceDetailViewController>(storyboard: Places.self, identifier: "PlaceDetailViewController")

    internal static let placesViewController = SceneType<AroundTheMetro.PlacesViewController>(storyboard: Places.self, identifier: "PlacesViewController")
  }
  internal enum Profile: StoryboardType {
    internal static let storyboardName = "Profile"

    internal static let profileViewController = SceneType<AroundTheMetro.ProfileViewController>(storyboard: Profile.self, identifier: "ProfileViewController")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: BundleToken.bundle)
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
