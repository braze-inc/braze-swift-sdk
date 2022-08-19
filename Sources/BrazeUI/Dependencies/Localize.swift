import Foundation

enum LocalizationSet: String {
  case inAppMessage = "InAppMessageLocalizable"
  case contentCard = "ContentCardsLocalizable"
  case newsFeed
}

func localize(_ key: String, for localizationSet: LocalizationSet) -> String {
  // Look for a possible override in main bundle
  let override = Bundle.main.localizedString(forKey: key, value: nil, table: nil)
  if override != key {
    return override
  }

  return resourcesBundle?.localizedString(forKey: key, value: nil, table: localizationSet.rawValue)
    ?? key
}
