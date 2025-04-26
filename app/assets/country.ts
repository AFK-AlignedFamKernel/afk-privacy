const COUNTRY_DATA: Record<string, { name: string; currency: string; currencySymbol: string; currencyCode: string; flag: string; isoCode: string }> = {  
    "USA": {
        "name": "United States",
        "currency": "USD",
        "currencySymbol": "$",
        "currencyCode": "USD",
        "flag": "🇺🇸",
        "isoCode": "USA"
    },
    "GBR": {
        "name": "United Kingdom", 
        "currency": "GBP",
        "currencySymbol": "£",
        "currencyCode": "GBP",
        "flag": "🇬🇧",
        "isoCode": "GBR"
    },
    "CAN": {
        "name": "Canada",
        "currency": "CAD", 
        "currencySymbol": "$",
        "currencyCode": "CAD",
        "flag": "🇨🇦",
        "isoCode": "CAN"
    },
    "AUS": {
        "name": "Australia",
        "currency": "AUD",
        "currencySymbol": "$",
        "currencyCode": "AUD",
        "flag": "🇦🇺",
        "isoCode": "AUS"
    },
    "NZL": {
        "name": "New Zealand",
        "currency": "NZD",
        "currencySymbol": "$",
        "currencyCode": "NZD",
        "flag": "🇳🇿",
        "isoCode": "NZL"
    },
    "FRA": {
        "name": "France",
        "currency": "EUR",
        "currencySymbol": "€",
        "currencyCode": "EUR",
        "flag": "🇫🇷",
        "isoCode": "FRA"
    },
    "DEU": {
        "name": "Germany",
        "currency": "EUR",
        "currencySymbol": "€", 
        "currencyCode": "EUR",
        "flag": "🇩🇪",
        "isoCode": "DEU"
    },
    "ITA": {
        "name": "Italy",
        "currency": "EUR",
        "currencySymbol": "€",
        "currencyCode": "EUR",
        "flag": "🇮🇹",
        "isoCode": "ITA"
    },
    "ESP": {
        "name": "Spain",
        "currency": "EUR",
        "currencySymbol": "€",
        "currencyCode": "EUR",
        "flag": "🇪🇸",
        "isoCode": "ESP"
    },
    "JPN": {
        "name": "Japan",
        "currency": "JPY",
        "currencySymbol": "¥",
        "currencyCode": "JPY",
        "flag": "🇯🇵",
        "isoCode": "JPN"
    },
    "KOR": {
        "name": "South Korea",
        "currency": "KRW",
        "currencySymbol": "₩",
        "currencyCode": "KRW",
        "flag": "🇰🇷",
        "isoCode": "KOR"
    },
    "CHN": {
        "name": "China",
        "currency": "CNY",
        "currencySymbol": "¥",
        "currencyCode": "CNY",
        "flag": "🇨🇳",
        "isoCode": "CHN"
    },
    "SGP": {
        "name": "Singapore",
        "currency": "SGD",
        "currencySymbol": "$",
        "currencyCode": "SGD",
        "flag": "🇸🇬",
        "isoCode": "SGP"
    },
    "CHE": {
        "name": "Switzerland",
        "currency": "CHF",
        "currencySymbol": "Fr",
        "currencyCode": "CHF",
        "flag": "🇨🇭",
        "isoCode": "CHE"
    },
    "SWE": {
        "name": "Sweden",
        "currency": "SEK",
        "currencySymbol": "kr",
        "currencyCode": "SEK",
        "flag": "🇸🇪",
        "isoCode": "SWE"
    },
    "NOR": {
        "name": "Norway",
        "currency": "NOK",
        "currencySymbol": "kr",
        "currencyCode": "NOK",
        "flag": "🇳🇴",
        "isoCode": "NOR"
    },
    "DNK": {
        "name": "Denmark",
        "currency": "DKK",
        "currencySymbol": "kr",
        "currencyCode": "DKK",
        "flag": "🇩🇰",
        "isoCode": "DNK"
    },
    "IND": {
        "name": "India",
        "currency": "INR",
        "currencySymbol": "₹",
        "currencyCode": "INR",
        "flag": "🇮🇳",
        "isoCode": "IND"
    },
    "BRA": {
        "name": "Brazil",
        "currency": "BRL",
        "currencySymbol": "R$",
        "currencyCode": "BRL",
        "flag": "🇧🇷",
        "isoCode": "BRA"
    },
    "RUS": {
        "name": "Russia",
        "currency": "RUB",
        "currencySymbol": "₽",
        "currencyCode": "RUB",
        "flag": "🇷🇺",
        "isoCode": "RUS"
    },
    "MEX": {
        "name": "Mexico",
        "currency": "MXN",
        "currencySymbol": "$",
        "currencyCode": "MXN",
        "flag": "🇲🇽",
        "isoCode": "MEX"
    },
    "ZAF": {
        "name": "South Africa",
        "currency": "ZAR",
        "currencySymbol": "R",
        "currencyCode": "ZAR",
        "flag": "🇿🇦",
        "isoCode": "ZAF"
    },
    "SAU": {
        "name": "Saudi Arabia",
        "currency": "SAR",
        "currencySymbol": "﷼",
        "currencyCode": "SAR",
        "flag": "🇸🇦",
        "isoCode": "SAU"
    },
    "ARE": {
        "name": "United Arab Emirates",
        "currency": "AED",
        "currencySymbol": "د.إ",
        "currencyCode": "AED",
        "flag": "🇦🇪",
        "isoCode": "ARE"
    }
}

export default COUNTRY_DATA;