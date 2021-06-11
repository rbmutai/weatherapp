

import Foundation
import SystemConfiguration

open class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
//        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
//            
//        }
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    class func isWifiEnabled() -> Bool {
        var addresses = [String]()

        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return false }
        guard let firstAddr = ifaddr else { return false }

        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            addresses.append(String(cString: ptr.pointee.ifa_name))
        }

        var counts:[String:Int] = [:]

        for item in addresses {
            counts[item] = (counts[item] ?? 0) + 1
        }

        freeifaddrs(ifaddr)
        guard let count = counts["awdl0"] else { return false }
        return count > 1
    }
}
