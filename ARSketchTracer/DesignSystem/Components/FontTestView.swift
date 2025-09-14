import SwiftUI

struct FontTestScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Text("Font Test - Merriweather Typography")
                        .font(DS.Typography.title)
                        .foregroundColor(DS.Color.textPrimary)
                    
                    Text("Available Fonts:")
                        .font(DS.Typography.headline)
                        .foregroundColor(DS.Color.textPrimary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(UIFont.familyNames.sorted(), id: \.self) { family in
                            Text(family)
                                .font(.system(size: 12))
                                .foregroundColor(DS.Color.textSecondary)
                        }
                    }
                }
                
                Divider()
                    .background(DS.Color.border)
                
                Group {
                    Text("Typography Scale Test")
                        .font(DS.Typography.headline)
                        .foregroundColor(DS.Color.textPrimary)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Title - Large Display Text")
                            .font(DS.Typography.title)
                            .foregroundColor(DS.Color.textPrimary)
                        
                        Text("Headline - Section Headers")
                            .font(DS.Typography.headline)
                            .foregroundColor(DS.Color.textPrimary)
                        
                        Text("Subtitle - Secondary Headers")
                            .font(DS.Typography.subtitle)
                            .foregroundColor(DS.Color.textPrimary)
                        
                        Text("Body - Regular paragraph text content")
                            .font(DS.Typography.body)
                            .foregroundColor(DS.Color.textPrimary)
                        
                        Text("Button Text")
                            .font(DS.Typography.button)
                            .foregroundColor(DS.Color.textPrimary)
                        
                        Text("Caption - Small descriptive text")
                            .font(DS.Typography.caption)
                            .foregroundColor(DS.Color.textSecondary)
                        
                        Text("Footnote - Very small text")
                            .font(DS.Typography.footnote)
                            .foregroundColor(DS.Color.textTertiary)
                    }
                }
            }
            .padding()
        }
        .background(DS.Color.background)
    }
}

#if DEBUG
struct FontTestScreen_Previews: PreviewProvider {
    static var previews: some View {
        FontTestScreen()
    }
}
#endif
