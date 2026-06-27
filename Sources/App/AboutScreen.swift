// AboutScreen.swift
import SwiftUI

struct AboutScreen: View {
    var body: some View {
        NavigationStack {
            Group {
                VStack {
                    Divider()
                    Text(
                    """
                    This app, version v0.5, is released under an MIT license, copyright Nathaniel Flores, et al. 
                    
                    It is based heavily off of the [Party UP! Android app](https://github.com/9001/party-up), and is a direct iOS port of that with a goal of maintaining feature-parity.
                    
                    If you have a substantial interest in contributing code/translations, have ideas on how to improve this app, or find any bugs, consider emailing me at [me@nsf.name](mailto:me@nsf.name) or opening an issue on [GitHub](https://github.com/nsf-name/party-up-ios)!
                    
                    *"So help yourselves, and don't send me any money." - Tom Lehrer*
                    """
                    )
                    .padding([.leading,.trailing],16)
                    Spacer()
                }
            }
            .navigationSubtitle(Text("v0.5 (dev version)"))
            .navigationTitle(Text("About"))
        }
    }
}

