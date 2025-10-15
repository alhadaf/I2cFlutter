//
//  PrinterSettingItem+Extension.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/9.
//

import BRLMPrinterKit
import Foundation

extension PrinterSettingItem {
    static func allCases() -> [PrinterSettingItem] {
        return [
            .PSI_NET_BOOTMODE, .PSI_NET_INTERFACE, .PSI_NET_USED_IPV6, .PSI_NET_PRIORITY_IPV6, .PSI_NET_IPV4_BOOTMETHOD,
            .PSI_NET_STATIC_IPV4ADDRESS, .PSI_NET_SUBNETMASK, .PSI_NET_GATEWAY, .PSI_NET_DNS_IPV4_BOOTMETHOD,
            .PSI_NET_PRIMARY_DNS_IPV4ADDRESS, .PSI_NET_SECOND_DNS_IPV4ADDRESS, .PSI_NET_IPV6_BOOTMETHOD, .PSI_NET_STATIC_IPV6ADDRESS,
            .PSI_NET_PRIMARY_DNS_IPV6ADDRESS, .PSI_NET_SECOND_DNS_IPV6ADDRESS, .PSI_NET_IPV6ADDRESS_LIST,
            .PSI_NET_COMMUNICATION_MODE, .PSI_NET_SSID, .PSI_NET_CHANNEL, .PSI_NET_AUTHENTICATION_METHOD,
            .PSI_NET_ENCRYPTIONMODE, .PSI_NET_WEPKEY, .PSI_NET_PASSPHRASE, .PSI_NET_USER_ID, .PSI_NET_PASSWORD,
            .PSI_NET_NODENAME, .PSI_WIRELESSDIRECT_KEY_CREATE_MODE, .PSI_WIRELESSDIRECT_SSID, .PSI_WIRELESSDIRECT_NETWORK_KEY,
            .PSI_BT_ISDISCOVERABLE, .PSI_BT_DEVICENAME, .PSI_BT_BOOTMODE, .PSI_PRINTER_POWEROFFTIME, .PSI_PRINTER_POWEROFFTIME_BATTERY,
            .PSI_PRINT_JPEG_HALFTONE, .PSI_PRINT_JPEG_SCALE, .PSI_PRINT_DENSITY, .PSI_PRINT_SPEED, .PSI_BT_AUTO_CONNECTION
        ]
    }
    var name: String {
        switch self {
        case .PSI_NET_BOOTMODE:
            return "PSI_NET_BOOTMODE"
        case .PSI_NET_INTERFACE:
            return "PSI_NET_INTERFACE"
        case .PSI_NET_USED_IPV6:
            return "PSI_NET_USED_IPV6"
        case .PSI_NET_PRIORITY_IPV6:
            return "PSI_NET_PRIORITY_IPV6"
        case .PSI_NET_IPV4_BOOTMETHOD:
            return "PSI_NET_IPV4_BOOTMETHOD"
        case .PSI_NET_STATIC_IPV4ADDRESS:
            return "PSI_NET_STATIC_IPV4ADDRESS"
        case .PSI_NET_SUBNETMASK:
            return "PSI_NET_SUBNETMASK"
        case .PSI_NET_GATEWAY:
            return "PSI_NET_GATEWAY"
        case .PSI_NET_DNS_IPV4_BOOTMETHOD:
            return "PSI_NET_DNS_IPV4_BOOTMETHOD"
        case .PSI_NET_PRIMARY_DNS_IPV4ADDRESS:
            return "PSI_NET_PRIMARY_DNS_IPV4ADDRESS"
        case .PSI_NET_SECOND_DNS_IPV4ADDRESS:
            return "PSI_NET_SECOND_DNS_IPV4ADDRESS"
        case .PSI_NET_IPV6_BOOTMETHOD:
            return "PSI_NET_IPV6_BOOTMETHOD"
        case .PSI_NET_STATIC_IPV6ADDRESS:
            return "PSI_NET_STATIC_IPV6ADDRESS"
        case .PSI_NET_PRIMARY_DNS_IPV6ADDRESS:
            return "PSI_NET_PRIMARY_DNS_IPV6ADDRESS"
        case .PSI_NET_SECOND_DNS_IPV6ADDRESS:
            return "PSI_NET_SECOND_DNS_IPV6ADDRESS"
        case .PSI_NET_IPV6ADDRESS_LIST:
            return "PSI_NET_IPV6ADDRESS_LIST"
        case .PSI_NET_COMMUNICATION_MODE:
            return "PSI_NET_COMMUNICATION_MODE"
        case .PSI_NET_SSID:
            return "PSI_NET_SSID"
        case .PSI_NET_CHANNEL:
            return "PSI_NET_CHANNEL"
        case .PSI_NET_AUTHENTICATION_METHOD:
            return "PSI_NET_AUTHENTICATION_METHOD"
        case .PSI_NET_ENCRYPTIONMODE:
            return "PSI_NET_ENCRYPTIONMODE"
        case .PSI_NET_WEPKEY:
            return "PSI_NET_WEPKEY"
        case .PSI_NET_PASSPHRASE:
            return "PSI_NET_PASSPHRASE"
        case .PSI_NET_USER_ID:
            return "PSI_NET_USER_ID"
        case .PSI_NET_PASSWORD:
            return "PSI_NET_PASSWORD"
        case .PSI_NET_NODENAME:
            return "PSI_NET_NODENAME"
        case .PSI_WIRELESSDIRECT_KEY_CREATE_MODE:
            return "PSI_WIRELESSDIRECT_KEY_CREATE_MODE"
        case .PSI_WIRELESSDIRECT_SSID:
            return "PSI_WIRELESSDIRECT_SSID"
        case .PSI_WIRELESSDIRECT_NETWORK_KEY:
            return "PSI_WIRELESSDIRECT_NETWORK_KEY"
        case .PSI_BT_ISDISCOVERABLE:
            return "PSI_BT_ISDISCOVERABLE"
        case .PSI_BT_DEVICENAME:
            return "PSI_BT_DEVICENAME"
        case .PSI_BT_BOOTMODE:
            return "PSI_BT_BOOTMODE"
        case .PSI_PRINTER_POWEROFFTIME:
            return "PSI_PRINTER_POWEROFFTIME"
        case .PSI_PRINTER_POWEROFFTIME_BATTERY:
            return "PSI_PRINTER_POWEROFFTIME_BATTERY"
        case .PSI_PRINT_JPEG_HALFTONE:
            return "PSI_PRINT_JPEG_HALFTONE"
        case .PSI_PRINT_JPEG_SCALE:
            return "PSI_PRINT_JPEG_SCALE"
        case .PSI_PRINT_DENSITY:
            return "PSI_PRINT_DENSITY"
        case .PSI_PRINT_SPEED:
            return "PSI_PRINT_SPEED"
        case .PSI_BT_POWERSAVEMODE:
            return "PSI_BT_POWERSAVEMODE"
        case .PSI_BT_SSP:
            return "PSI_BT_SSP"
        case .PSI_BT_AUTHMODE:
            return "PSI_BT_AUTHMODE"
        case .PSI_BT_AUTO_CONNECTION:
            return "PSI_BT_AUTO_CONNECTION"
        @unknown default:
            return "unknown"
        }
    }

}
