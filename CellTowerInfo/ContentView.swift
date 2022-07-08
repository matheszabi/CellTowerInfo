//
//  ContentView.swift
//  CellTowerInfo
//
//

import SwiftUI
import CoreTelephony

struct ContentView: View {
    
    var networkInfo = getMccMnc()
    
    var body: some View {
        VStack(spacing: 10.0){
            
            Text("Telephony Network Info!").padding()
            
            Text("Carrier Name: "+networkInfo.carrierName).padding()
            
            Text("Mobile Country Code: "+networkInfo.mcc).padding()
            
            Text("Mobile Network Code: "+networkInfo.mnc).padding()
            
            
            Spacer()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}

func getMccMnc() -> (mcc: String, mnc: String, carrierName: String) {
    let bgTask = UIApplication.shared.beginBackgroundTask {
        print("BackgroundTask Expired")
    }
    
    let networkInfo = CTTelephonyNetworkInfo()
    var carrier: [String:CTCarrier]? = nil
    
    if #available(iOS 13.0, *) {
        guard let str = networkInfo.dataServiceIdentifier
        else {
            UIApplication.shared.endBackgroundTask(bgTask)
            return ("","", "")
        }
        
        carrier = networkInfo.serviceSubscriberCellularProviders
        let ctCarrier = carrier?[str]
        guard let _ = ctCarrier?.mobileCountryCode, let _ = ctCarrier?.mobileNetworkCode, let _ = ctCarrier?.carrierName
                
        else {
            UIApplication.shared.endBackgroundTask(bgTask)
            return ("","", "")}
        
        
        UIApplication.shared.endBackgroundTask(bgTask)
        // https://www.mcc-mnc.com/
        // mcc = 226 => Romania
        // mnc = 05 => Digi Mobil
        // carrierName:String = "Carrier" - in my case doesn't have the correct value.
        return ((ctCarrier?.mobileCountryCode ?? ""), (ctCarrier?.mobileNetworkCode ?? ""), (ctCarrier?.carrierName ?? ""))
        
    }
}
