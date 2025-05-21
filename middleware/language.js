const { translateText } = require('../i18n/translation-service');

// Default translations for common messages
const defaultMessages = {
  en: {
    userNotFound: "User not found",
    userIdExists: "User ID already exists",
    userAdded: "User added successfully",
    paymentAdded: "Payment added successfully",
    userDeleted: "User deleted successfully",
    userMovedToTrash: "User moved to trash successfully",
    userRestored: "User restored successfully",
    userPermanentlyDeleted: "User permanently deleted",
    invalidCredentials: "Invalid credentials",
    paymentExists: "Payment for this month already exists",
    pendingPaymentExists: "A pending payment request already exists for this month",
    transactionIdExists: "Transaction ID already exists",
    paymentRequestSubmitted: "Payment request submitted successfully",
    paymentApproved: "Payment approved successfully",
    paymentRejected: "Payment rejected successfully",
    languageUpdated: "Language updated successfully",
    transactionNotFound: "Transaction not found",
    userNotDeleted: "User is not deleted",
    userAlreadyDeleted: "User is already deleted",
    userNotInTrash: "User is not in trash",
    welcomeMessage: "Welcome to Nanjundeshwara Stores, {name}!",
    paymentRecorded: "Your payment of ₹{amount} for month {month} has been recorded",
    paymentApprovedNotification: "Your payment of ₹{amount} for month {month} has been approved",
    paymentRejectedNotification: "Your payment of ₹{amount} for month {month} has been rejected",
    deviceRegistered: "Device registered successfully",
    userDeleted: "User is deleted"
  }
};

// Language middleware
module.exports = async (req, res, next) => {
  // Get language from query, header, or default to English
  const lang = req.query.lang || req.headers['accept-language']?.split(',')[0]?.split('-')[0] || 'en';
  
  // Store language in request and response locals
  req.lang = lang;
  res.locals.lang = lang;
  
  // Add translation function to response locals
  res.locals.t = async (key, params = {}) => {
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
  
  next();
};