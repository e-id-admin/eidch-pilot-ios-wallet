import Foundation

extension Notification.Name {

  public static let receivedMessages = Notification.Name("ReceivedMessages")
  public static let startPollingMessages = Notification.Name("StartPollingMessages")
  public static let didLogin = Notification.Name("DidLogin")
  public static let loginRequired = Notification.Name("LoginRequired")
  public static let willEnterForeground = Notification.Name("willEnterForeground")
  public static let userInactivityTimeout = Notification.Name("userInactivityTimeout")

  public static let biometricsAlertPresented = Notification.Name("biometricsAlertPresented")
  public static let biometricsAlertFinished = Notification.Name("biometricsAlertFinished")

}
