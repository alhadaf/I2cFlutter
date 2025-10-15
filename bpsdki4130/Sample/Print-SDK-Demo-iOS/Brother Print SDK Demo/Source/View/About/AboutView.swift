//
//  AboutView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2022/12/19.
//

import SwiftUI

struct AboutView: View {
    @ObservedObject var dataSource: AboutViewModel
    var body: some View {
        let info = NSLocalizedString("app_version", comment: "") + dataSource.appVer + "\n" +
        NSLocalizedString("sdk_version", comment: "") + dataSource.sdkVer
        Text(info)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView(dataSource: .init())
    }
}
