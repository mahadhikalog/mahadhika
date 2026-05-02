# Google Tag Manager Setup Guide

This guide will help you set up Google Tag Manager (GTM) for your Mahadhika Logistik Indonesia website.

## Your Configuration
- **Website Domain**: www.mahadhika.com
- **GA4 Measurement ID**: G-TTF6X6V7RV
- **GTM Container ID**: GTM-5B5BKRH4

## Prerequisites

1. A Google account
2. Access to Google Tag Manager
3. Your website domain: www.mahadhika.com

## Step 1: Create a GTM Container

1. Go to [Google Tag Manager](https://tagmanager.google.com/)
2. Click "Create Account" if you don't have one
3. Create a new container:
   - **Container Name**: `Mahadhika Logistik Website`
   - **Target Platform**: Web
   - **Container URL**: `www.mahadhika.com`

4. Accept the GTM Terms of Service
5. Copy your Container ID (format: `GTM-XXXXXXX`)

## Step 2: Update Your Application

### Update GTM Container ID

✅ **All files have been updated with your GTM Container ID: GTM-5B5BKRH4**

The following files have been automatically updated:

1. **index.html** (lines 9 and 23): ✅ Updated
2. **src/main.js** (line 14): ✅ Updated  
3. **src/config/gtm.js** (line 8): ✅ Updated

Your GTM Container ID `GTM-5B5BKRH4` is now properly configured in all files.

## Step 3: Configure GTM Tags

### 1. Google Analytics 4 (GA4) Setup

1. In your GTM container, go to **Tags** → **New**
2. Click **Tag Configuration** → **Google Analytics: GA4 Configuration**
3. Enter your GA4 Measurement ID: `G-TTF6X6V7RV`
4. Set **Triggering** to **All Pages**
5. Save and name your tag: `GA4 Configuration`

### 2. Google Analytics 4 Event Tag

1. Create a new tag: **Google Analytics: GA4 Event**
2. Configure:
   - **Configuration Tag**: Select your GA4 Configuration tag
   - **Event Name**: `page_view`
   - **Event Parameters**: 
     - `page_path`: `{{Page Path}}`
     - `page_title`: `{{Page Title}}`
     - `page_location`: `{{Page URL}}`
3. Set **Triggering** to **All Pages**
4. Save and name: `GA4 Page View`

### 3. Custom Event Tags

Create additional tags for custom events:

#### Button Click Tracking
- **Tag Type**: Google Analytics: GA4 Event
- **Event Name**: `button_click`
- **Event Parameters**:
  - `button_name`: `{{Button Name}}`
  - `button_location`: `{{Button Location}}`

#### Form Submission Tracking
- **Tag Type**: Google Analytics: GA4 Event
- **Event Name**: `form_submit`
- **Event Parameters**:
  - `form_name`: `{{Form Name}}`
  - `form_type`: `{{Form Type}}`

#### Service Interest Tracking
- **Tag Type**: Google Analytics: GA4 Event
- **Event Name**: `service_interest`
- **Event Parameters**:
  - `service_name`: `{{Service Name}}`
  - `action`: `{{Action}}`

## Step 4: Configure Triggers

### 1. Custom Event Triggers

Create triggers for your custom events:

1. Go to **Triggers** → **New**
2. Configure triggers for:
   - `button_click` events
   - `form_submit` events
   - `service_interest` events
   - `contact_interaction` events

### 2. Built-in Variables

Enable these built-in variables in GTM:
- **Page** → **Page URL**
- **Page** → **Page Hostname**
- **Page** → **Page Path**
- **Page** → **Page Title**
- **Page** → **Referrer**

## Step 5: Test Your Implementation

### 1. Preview Mode

1. In GTM, click **Preview**
2. Enter your website URL
3. Test various interactions:
   - Navigate between pages
   - Click service cards
   - Submit the contact form
   - Click navigation buttons

### 2. Verify Events

Check that these events are firing:
- `page_view` - When navigating between pages
- `button_click` - When clicking navigation or service cards
- `form_submit` - When submitting the contact form
- `service_interest` - When clicking on service cards

### 3. Google Analytics Real-time Reports

1. Go to your GA4 property
2. Navigate to **Reports** → **Realtime**
3. Verify that events are being received

## Step 6: Publish Your Container

1. In GTM, click **Submit**
2. Add a version name: `Initial setup with custom events`
3. Add a description: `Added GA4 configuration and custom event tracking for Mahadhika Logistik website`
4. Click **Publish**

## Step 7: Verify Production Setup

1. Deploy your website with the updated GTM Container ID
2. Test the live website
3. Check GA4 real-time reports to confirm tracking is working

## Available Events

Your website now tracks these events:

### Automatic Events
- **page_view**: Fired on every page navigation
  - Parameters: `page_path`, `page_title`, `page_location`

### Custom Events
- **button_click**: Fired when clicking navigation or interactive elements
  - Parameters: `button_name`, `button_location`

- **form_submit**: Fired when submitting the contact form
  - Parameters: `form_name`, `form_type`

- **service_interest**: Fired when clicking on service cards
  - Parameters: `service_name`, `action`

- **contact_interaction**: Fired for contact-related interactions
  - Parameters: `contact_method`, `contact_type`

## Troubleshooting

### Common Issues

1. **Events not firing**: Check that your GTM Container ID is correct
2. **GA4 not receiving data**: Verify your GA4 Measurement ID in GTM
3. **Preview mode not working**: Ensure your website is accessible and GTM script is loaded

### Debug Tools

1. **GTM Preview Mode**: Use GTM's built-in preview to test events
2. **Browser Developer Tools**: Check console for GTM-related errors
3. **GA4 Debug View**: Use GA4's debug view to see real-time events
4. **Google Tag Assistant**: Browser extension to verify GTM implementation

## Support

If you encounter issues:
1. Check the browser console for errors
2. Verify all Container IDs are correctly updated
3. Test in GTM Preview mode
4. Check GA4 real-time reports

## Next Steps

After successful setup:
1. Set up conversion goals in GA4
2. Configure custom dimensions if needed
3. Set up enhanced ecommerce tracking (if applicable)
4. Create custom reports and dashboards
