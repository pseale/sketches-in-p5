const p5module = require("p5");

let width = Math.floor(window.innerWidth);
let height = Math.floor(window.innerHeight);
let canvas = null;
let inputs;

let offset = 0;

let sketch = (p5) => {
  p5.setup = () => {
    p5.frameRate(60);
    canvas = document.getElementsByTagName("canvas")[0];
    p5.createCanvas(width, height);
  };

  p5.draw = () => {
    p5.clear();
    resizeIfNecessary();

    offset += -inputs.rotationSpeed; // positive rotation speed should be interpreted as clockwise rotation

    p5.noStroke();
    const radiusX = width / 2;
    const radiusY = height / 2;
    const midpointX = radiusX;
    const midpointY = radiusY * 1.39; // the midpoint of the sunburst is a little lower than midway down the screen
    const magnitude = inputs.magnitude;
    for (let i = 0; i < inputs.rays; i++) {
      const startAngle = (i * (2 * Math.PI)) / inputs.rays + offset;
      const endAngle =
        i + 1 === inputs.rays
          ? offset
          : ((i + 1) * (2 * Math.PI)) / inputs.rays + offset;
      const startX = magnitude * radiusX * Math.sin(startAngle) + midpointX;
      const startY = magnitude * radiusX * Math.cos(startAngle) + midpointY;
      const endX = magnitude * radiusX * Math.sin(endAngle) + midpointX;
      const endY = magnitude * radiusX * Math.cos(endAngle) + midpointY;

      const c = inputs.colorScheme[i % inputs.colorScheme.length];
      if (inputs.showBorder) {
        p5.stroke(p5.color(55));
        p5.strokeWeight(5);
      }
      p5.fill(c);
      p5.triangle(midpointX, midpointY, startX, startY, endX, endY);
      if (inputs.showBorder) {
        p5.noStroke();
      }
    }
  };
};

function resizeIfNecessary() {
  const newWidth = Math.floor(window.innerWidth); // Math.floor to support high-DPI displays
  const newHeight = Math.floor(window.innerHeight); // Math.floor to support high-DPI displays
  if (width !== newWidth || height !== newHeight) {
    width = newWidth;
    height = newHeight;
    canvas.width = width;
    canvas.height = height;
    canvas.style.width = width;
    canvas.style.height = height;
  }
}

module.exports.init = function init(i) {
  inputs = i;
  // ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~
  new p5module(sketch);
  // ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~
};
