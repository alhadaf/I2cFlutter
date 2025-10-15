//
//  PrinterSelectionView.swift
//  Brother Print SDK Demo
//
//  Created by debug on 2025/04/16.
//

import SwiftUI

struct PrinterSelectionView: View {
    @Binding var printerInfo: DiscoveredPrinterInfo?
    @State private var showPasswordDialog = false
    @State private var passwordInput = ""
    var selectPrinterAction: () -> Void

    var body: some View {
        Section {
            Button(action: {
                selectPrinterAction()
            }) {
                VStack(alignment: .leading) {
                    Text(printerInfo?.printerItemData.modelName ?? NSLocalizedString("select_printer_message", comment: ""))
                        .foregroundColor(.black)
                    Text(printerInfo?.printerItemData.channelInfo ?? "").font(.footnote).foregroundColor(.gray)
                }
            }
            if printerInfo != nil {
                Button(action: {
                    showPasswordDialog = true
                }) {
                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("password_input", comment: ""))
                            .foregroundColor(.black)
                        Text(printerInfo?.password ?? "").font(.footnote).foregroundColor(.gray)
                    }
                }
                .sheet(isPresented: $showPasswordDialog) {
                    PasswordInputDialog(password: $passwordInput, onDone: {
                        if passwordInput.isEmpty {
                            printerInfo?.password = nil
                        } else {
                            printerInfo?.password = passwordInput
                        }
                        showPasswordDialog = false
                    }, onCancel: {
                        showPasswordDialog = false
                    })
                }
            }
        } header: {
            Text("printer").foregroundColor(.gray)
        }
    }
}

struct PasswordInputDialog: View {
    @Binding var password: String
    var onDone: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack {
            Text("Enter Password")
                .font(.headline)
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            HStack {
                Button("Cancel") {
                    onCancel()
                }
                Spacer()
                Button("OK") {
                    onDone()
                }
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    PrinterSelectionView(printerInfo: .constant(DiscoveredPrinterInfo()), selectPrinterAction: {})
}
