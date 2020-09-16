function convertBooleanValue(urlParams, key) {
  const value = urlParams.get(key);
  return String(value).toLocaleLowerCase() === "true";
}

export default function getInputs() {
  // get stuff from the outside world
  const urlParams = new URLSearchParams(window.location.search);
  const colorIndexFromQueryString = Number(urlParams.get("c") || 0);
  const magnitudeFromQueryString = Number(urlParams.get("m") || 5);
  const raysFromQueryString = Number(urlParams.get("rays") || 32);
  const rotationSpeedFromQueryString = Number(urlParams.get("speed") || 1);
  const showBanner = !convertBooleanValue(urlParams, "hideBanner");
  const showBorder = convertBooleanValue(urlParams, "showBorder");

  const redWhite = ["rgb(188, 45, 0)", "rgb(255, 255, 255, 0)"];
  const yellowWhite = ["rgb(255, 255, 0)", "rgb(255)"];
  const yellow12 = ["rgb(255, 255, 0)", "rgb(240, 240, 0)"];
  const redYellow = ["rgb(255, 0, 0)", "rgb(255, 255, 0)"];
  const cmyk = ["rgb(255, 255, 0)", "rgb(255, 0, 255)", "rgb(0, 255, 255)"];
  const colorSchemes = [redWhite, yellowWhite, yellow12, redYellow, cmyk];
  const colorScheme = colorSchemes[colorIndexFromQueryString];
  const tColor = "rgb(0)";
  const tOutlineColor = "rgb(255)";

  return {
    colorScheme,
    color: tColor,
    magnitude: magnitudeFromQueryString,
    outlineColor: tOutlineColor,
    rays: raysFromQueryString,
    rotationSpeed: rotationSpeedFromQueryString * 0.004,
    showBanner,
    showBorder,
  };
}
