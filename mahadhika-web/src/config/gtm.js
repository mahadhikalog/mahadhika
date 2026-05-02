/**
 * Google Tag Manager Configuration
 * 
 * This file contains the configuration for GTM integration.
 * Replace the placeholder values with your actual GTM Container ID.
 */

export const gtmConfig = {
  // Replace 'GTM-XXXXXXX' with your actual GTM Container ID
  // Your domain: www.mahadhika.com
  // Your GA4 tag: G-TTF6X6V7RV
  containerId: 'GTM-5B5BKRH4',
  
  // GA4 Configuration
  ga4: {
    measurementId: 'G-TTF6X6V7RV',
    domain: 'www.mahadhika.com'
  },
  
  // Environment configuration
  environment: {
    // Set to 'production' for live site, 'development' for local testing
    mode: import.meta.env.MODE === 'production' ? 'production' : 'development',
    
    // Enable/disable GTM based on environment
    enabled: true
  },
  
  // Custom events configuration
  events: {
    // Page view tracking
    pageView: {
      enabled: true,
      eventName: 'page_view'
    },
    
    // Button click tracking
    buttonClick: {
      enabled: true,
      eventName: 'button_click'
    },
    
    // Form submission tracking
    formSubmission: {
      enabled: true,
      eventName: 'form_submit'
    },
    
    // Service interest tracking
    serviceInterest: {
      enabled: true,
      eventName: 'service_interest'
    },
    
    // Contact interaction tracking
    contactInteraction: {
      enabled: true,
      eventName: 'contact_interaction'
    }
  }
}

export default gtmConfig
