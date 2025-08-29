import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "select" ]

  connect() {
    console.log("Timezone auto-detection started")
    this.detectAndSetTimezone()
  }

  detectAndSetTimezone() {
    // Get the browser's timezone using Intl API
    const browserTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone
    console.log(`Browser detected timezone: ${browserTimezone}`)

    if (browserTimezone && this.hasSelectTarget) {
      // Find the option that matches the detected timezone
      const options = this.selectTarget.options
      
      // Extract the city name from the browser timezone (e.g., "America/Bogota" -> "Bogota")
      const cityName = browserTimezone.split('/').pop().replace(/_/g, ' ')
      
      for (let i = 0; i < options.length; i++) {
        // The timezone options in Rails are in format like "(GMT-05:00) Bogota"
        // We need to check if the option text includes our city name
        // Also check for the full timezone path for better matching
        if (options[i].text.includes(cityName) || 
            options[i].value === browserTimezone ||
            options[i].text.includes(browserTimezone.replace('_', ' '))) {
          this.selectTarget.selectedIndex = i
          console.log(`Timezone auto-detected and set to: ${options[i].text}`)
          break
        }
      }
    }
  }
}
