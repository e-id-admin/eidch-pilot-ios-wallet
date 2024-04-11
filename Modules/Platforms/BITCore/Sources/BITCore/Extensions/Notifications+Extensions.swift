import Foundation

extension NSNotification.Name {

  public static let receivedMessages = NSNotification.Name("ReceivedMessages")
  public static let startPollingMessages = NSNotification.Name("StartPollingMessages")
  public static let didLogin = NSNotification.Name("DidLogin")
  public static let loginRequired = NSNotification.Name("LoginRequired")
  public static let willEnterForeground = NSNotification.Name("willEnterForeground")

}
