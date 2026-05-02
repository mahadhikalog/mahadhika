/**
 * Google Tag Manager Plugin for Vue.js
 * Provides easy integration with GTM for tracking page views and custom events
 */

class GTMPlugin {
  constructor() {
    this.gtm_id = null
    this.dataLayer = window.dataLayer || []
  }

  /**
   * Initialize GTM with container ID
   * @param {string} gtmId - GTM Container ID (e.g., 'GTM-XXXXXXX')
   */
  init(gtmId) {
    this.gtm_id = gtmId
    
    // Ensure dataLayer exists
    window.dataLayer = window.dataLayer || []
    
    // Push initial configuration
    this.push({
      'gtm.start': new Date().getTime(),
      event: 'gtm.js'
    })
  }

  /**
   * Push data to dataLayer
   * @param {Object} data - Data to push to dataLayer
   */
  push(data) {
    this.dataLayer.push(data)
  }

  /**
   * Track page view
   * @param {string} pagePath - Current page path
   * @param {string} pageTitle - Current page title
   */
  trackPageView(pagePath, pageTitle) {
    this.push({
      event: 'page_view',
      page_path: pagePath,
      page_title: pageTitle,
      page_location: window.location.href
    })
  }

  /**
   * Track custom event
   * @param {string} eventName - Name of the event
   * @param {Object} parameters - Event parameters
   */
  trackEvent(eventName, parameters = {}) {
    this.push({
      event: eventName,
      ...parameters
    })
  }

  /**
   * Track button click
   * @param {string} buttonName - Name/ID of the button
   * @param {string} location - Location where button was clicked
   */
  trackButtonClick(buttonName, location = '') {
    this.trackEvent('button_click', {
      button_name: buttonName,
      button_location: location
    })
  }

  /**
   * Track form submission
   * @param {string} formName - Name/ID of the form
   * @param {string} formType - Type of form (contact, newsletter, etc.)
   */
  trackFormSubmission(formName, formType = '') {
    this.trackEvent('form_submit', {
      form_name: formName,
      form_type: formType
    })
  }

  /**
   * Track service interest
   * @param {string} serviceName - Name of the service
   * @param {string} action - Action taken (view, click, etc.)
   */
  trackServiceInterest(serviceName, action = 'view') {
    this.trackEvent('service_interest', {
      service_name: serviceName,
      action: action
    })
  }

  /**
   * Track contact interaction
   * @param {string} contactMethod - Method of contact (phone, email, form)
   * @param {string} contactType - Type of contact (inquiry, support, etc.)
   */
  trackContactInteraction(contactMethod, contactType = '') {
    this.trackEvent('contact_interaction', {
      contact_method: contactMethod,
      contact_type: contactType
    })
  }
}

// Create plugin instance
const gtm = new GTMPlugin()

// Vue plugin definition
const GTMPluginVue = {
  install(app, options = {}) {
    // Initialize GTM if ID is provided
    if (options.gtmId) {
      gtm.init(options.gtmId)
    }

    // Make GTM available globally
    app.config.globalProperties.$gtm = gtm
    app.provide('gtm', gtm)
  }
}

export default GTMPluginVue
export { gtm }
