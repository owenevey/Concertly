import Foundation

class DeviceIdManager {
    static func getDeviceId() -> String {
        if let deviceId = UserDefaults.standard.string(forKey: "deviceId") {
            return deviceId
        }

        let newDeviceId = UUID().uuidString
        UserDefaults.standard.set(newDeviceId, forKey: "deviceId")

        return newDeviceId
    }
}
