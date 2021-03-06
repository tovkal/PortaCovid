//
//  NoQRView.swift
//  PortaCovid
//
//  Created by Andrés Pizá Bückmann on 5/12/21.
//

import SwiftUI
import EUDCC

struct NoQRView: View {
    @State private var isShowingScanner = false
    @Binding var certificate: EUDCC?

    var body: some View {
        VStack {
            Text("no_qr.text.add_certificate".localized)
                .font(.title)
                .padding()
            Button("\(Image(systemName: "qrcode.viewfinder")) \("no_qr.buttons.scan_qr".localized)") {
                isShowingScanner = true
            }
            .font(.title2)
        }
        .sheet(isPresented: $isShowingScanner) {
            isShowingScanner = false
        } content: {
            scannerView
        }
    }

    var scannerView: some View {
        CodeScannerView(
            codeTypes: [.qr],
            simulatedData: Constants.sampleQR,
            completion: self.handleScan
        )
    }

    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        isShowingScanner = false

        switch result {
        case .success(let data):
            self.certificate = DataStore.shared.storeCertificate(data)
        case .failure(let error):
            print(error)
        }
    }
}

struct NoQRView_Previews: PreviewProvider {
    static var previews: some View {
        NoQRView(certificate: Binding.constant(nil))
    }
}
