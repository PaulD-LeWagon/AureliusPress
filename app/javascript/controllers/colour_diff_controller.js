import { Controller } from "@hotwired/stimulus"
import Color from "color"
/**
 * Calculates the percentage point difference in lightness between two colours.
 *
 * @param {string} color1Hex - The hex value of the first colour (e.g., '#000').
 * @param {string} color2Hex - The hex value of the second colour (e.g., '#fff').
 * @returns {number} The percentage point difference.
 */
function getHSLDifference(color1Hex = "#000", color2Hex = "#FFF", dp = 10) {
  const hsl1 = Color(color1Hex).hsl().color
  const hsl2 = Color(color2Hex).hsl().color
  return {
    h: (hsl2[0] - hsl1[0]).toFixed(dp),
    s: (hsl2[1] - hsl1[1]).toFixed(dp),
    l: (hsl2[2] - hsl1[2]).toFixed(dp),
  }
}

const redPalette = {
  "red-50": "#faeeeb",
  "red-100": "#f8dcd6",
  "red-150": "#f6cabf",
  "red-200": "#f5b7a8",
  "red-250": "#f5a390",
  "red-300": "#f38f79",
  "red-350": "#f17961",
  "red-400": "#f06048",
  "red-450": "#ee402e",
  "red-500": "#d93526",
  "red-550": "#c52f21",
  "red-600": "#af291d",
  "red-650": "#9b2318",
  "red-700": "#861d13",
  "red-750": "#72170f",
  "red-800": "#5c160d",
  "red-850": "#45150c",
  "red-900": "#30130a",
  "red-950": "#1c0d06",
}

const inputColour = { "tyrian-purple": "#66023c" }

const newPalette = {}

const ratios = {
  50: { h: "6.878", s: "-11.304", l: "50.000" },
  100: { h: "5.466", s: "-0.471", l: "45.490" },
  150: { h: "6.878", s: "4.038", l: "40.588" },
  200: { h: "6.566", s: "8.077", l: "35.882" },
  250: { h: "6.165", s: "12.167", l: "31.176" },
  300: { h: "5.698", s: "12.257", l: "26.275" },
  350: { h: "4.878", s: "12.417", l: "21.176" },
  400: { h: "3.449", s: "13.544", l: "16.078" },
  450: { h: "0.503", s: "13.651", l: "10.588" },
  500: { h: "-0.094", s: "-1.108", l: "4.902" },
  550: { h: "0.000", s: "0.000", l: "0.000" },
  600: { h: "-0.190", s: "0.264", l: "-5.098" },
  650: { h: "-0.084", s: "1.880", l: "-10.000" },
  700: { h: "0.095", s: "3.859", l: "-15.098" },
  750: { h: "-0.273", s: "5.440", l: "-19.804" },
  800: { h: "1.713", s: "3.934", l: "-24.510" },
  850: { h: "4.352", s: "-0.934", l: "-29.216" },
  900: { h: "9.089", s: "-5.787", l: "-33.725" },
  950: { h: "13.969", s: "-6.598", l: "-38.431" },
}

// Connects to data-controller="colour-diff"
export default class extends Controller {
  static targets = ["color1", "color2", "calculateButton", "result", "code"]
  connect() {
    // let output = ""
    // const baseColor = redPalette[550]
    // for (const [key, value] of Object.entries(redPalette)) {
    //   const difference = getHSLDifference(baseColor, value, 3)
    //   output += `${key}: ${JSON.stringify(difference)}<br>`
    // }
    // this.resultTarget.innerHTML = output
    this.generatePalette()
  }

  generatePalette() {
    for (const [key, value] of Object.entries(ratios)) {
      const newColor = Color(inputColour["tyrian-purple"]).hsl().color
      newColor[0] += parseFloat(value.h)
      newColor[1] += parseFloat(value.s)
      newColor[2] += parseFloat(value.l)
      newPalette[`tyrian-purple-${key}`] = Color.hsl(newColor).hex()
    }
    this.codeTarget.innerHTML = JSON.stringify(newPalette)
    this.generateHtmlPalette(newPalette)
    this.generateHtmlPalette(redPalette)
  }

  generateHtmlPalette(theNewPalette) {
    const paletteContainer = document.createElement("div")
    paletteContainer.classList.add("palette")

    for (const [key, value] of Object.entries(theNewPalette)) {
      const colorSwatch = document.createElement("div")
      colorSwatch.classList.add("color-swatch")
      colorSwatch.style.backgroundColor = value
      colorSwatch.textContent = key
      paletteContainer.appendChild(colorSwatch)
    }

    this.resultTarget.appendChild(paletteContainer)
  }

  onClickCalculate() {
    this.#calculateDifference()
  }

  #calculateDifference() {
    const color1 = this.color1Target.value
    const color2 = this.color2Target.value
    const difference = getHSLDifference(color1, color2, 3)
    this.resultTarget.textContent = `Difference: ${JSON.stringify(difference)}`
  }
}
