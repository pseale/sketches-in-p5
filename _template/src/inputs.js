function convertBooleanValue(urlParams, key) {
  const value = urlParams.get(key);
  return String(value).toLocaleLowerCase() === "true";
}

module.exports = function getInputs() {
  // get stuff from the outside world
  return {};
};
