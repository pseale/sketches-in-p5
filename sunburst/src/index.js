import * as sketch from "./sketch";
import defaults from "./defaults";
import { gamepadConnected, gamepadDisconnected } from "./gamepad";

window.onload = () => {
  window.addEventListener("gamepadconnected", gamepadConnected, false);
  window.addEventListener("gamepaddisconnected", gamepadDisconnected, false);

  sketch.init(defaults(p5));
};
