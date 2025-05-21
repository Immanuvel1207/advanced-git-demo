const { translateText } = require('./translation-service');

// Default translations for common messages
const defaultMessages = {
  en: {
    welcomeMessage: "Welcome to Nanjundeshwara Stores, {name}!",
    paymentRecorded: "Your payment of ₹{amount} for month {month} has been recorded",
    paymentApprovedNotification: "Your payment of ₹{amount} for month {month} has been approved",
    paymentRejectedNotification: "Your payment of ₹{amount} for month {month} has been rejected"
  }
};

// Function to translate a message with parameter replacement
const translate = async (key, lang = 'en', params = {}) => {
  // Get the message from default messages or use the key itself
  let message = defaultMessages.en[key] || key;
  
  // If language is not English, translate the message
  if (lang !== 'en') {
    message = await translateText(message, lang, 'en');
  }
  
  // Replace parameters in the message
  if (params) {
    Object.keys(params).forEach(param => {
      message = message.replace(`{${param}}`, params[param]);
    });
  }
  
  return message;
};

module.exports = {
  translate
};