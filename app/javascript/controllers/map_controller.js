import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })

    this.markers = []
    this.#addMarkersToMap()
    this.#fitMapToMarkers()
    this.#bindHoverEvents()
  }

  #addMarkersToMap() {
    this.markersValue.forEach((markerData) => {
      const markerElement = document.createElement("img")
      markerElement.src = "/assets/Green_Marker.png"
      markerElement.style.width = "30px"

      const marker = new mapboxgl.Marker({ element: markerElement })
        .setLngLat([markerData.lng, markerData.lat])
        .addTo(this.map)

      this.markers.push({ id: markerData.id, marker, element: markerElement })
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([marker.lng, marker.lat]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 13, duration: 0 })
  }

  #bindHoverEvents() {
    document.querySelectorAll("[data-marker-id]").forEach((card) => {
      const markerId = parseInt(card.dataset.markerId)

      card.addEventListener("mouseenter", () => {
        const marker = this.markers.find(m => m.id === markerId)
        if (marker) marker.element.src = "/assets/Red_Marker.png"
      })

      card.addEventListener("mouseleave", () => {
        const marker = this.markers.find(m => m.id === markerId)
        if (marker) marker.element.src = "/assets/Green_Marker.png"
      })
    })
  }
}
