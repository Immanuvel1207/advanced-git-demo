const axios = require('axios');

// Cache to store translations and reduce API calls
const translationCache = {};

// Function to generate a cache key
const getCacheKey = (text, sourceLang, targetLang) => {
  return `${sourceLang}:${targetLang}:${text}`;
};

// LibreTranslate API - free and open source
const translateText = async (text, targetLang, sourceLang = 'en') => {
  // Return original text if source and target languages are the same
  if (sourceLang === targetLang) {
    return text;
  }

  // Check cache first
  const cacheKey = getCacheKey(text, sourceLang, targetLang);
  if (translationCache[cacheKey]) {
    return translationCache[cacheKey];
  }

  try {
    // Using LibreTranslate API (you can self-host or use a public instance)
    const response = await axios.post('https://libretranslate.de/translate', {
      q: text,
      source: sourceLang,
      target: targetLang,
      format: 'text'
    }, {
      headers: {
        'Content-Type': 'application/json'
      }
    });

    if (response.data && response.data.translatedText) {
      // Store in cache
      translationCache[cacheKey] = response.data.translatedText;
      return response.data.translatedText;
    }
    
    return text; // Return original text if translation fails
  } catch (error) {
    console.error('Translation error:', error.message);
    
    // Fallback to Google Translate API (no API key required, but limited usage)
    try {
      const googleUrl = `https://translate.googleapis.com/translate_a/single?client=gtx&sl=${sourceLang}&tl=${targetLang}&dt=t&q=${encodeURIComponent(text)}`;
      const googleResponse = await axios.get(googleUrl);
      
      if (googleResponse.data && googleResponse.data[0] && googleResponse.data[0][0]) {
        const translatedText = googleResponse.data[0][0][0];
        translationCache[cacheKey] = translatedText;
        return translatedText;
      }
    } catch (googleError) {
      console.error('Google translation error:', googleError.message);
    }
    
    return text; // Return original text if all translation attempts fail
  }
};

// Function to translate an entire object of key-value pairs
const translateObject = async (obj, targetLang, sourceLang = 'en') => {
  const result = {};
  
  for (const key in obj) {
    if (typeof obj[key] === 'string') {
      result[key] = await translateText(obj[key], targetLang, sourceLang);
    } else {
      result[key] = obj[key]; // Keep non-string values as is
    }
  }
  
  return result;
};

module.exports = {
  translateText,
  translateObject
};