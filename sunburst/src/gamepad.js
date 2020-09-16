let gamepad;

export function gamepadConnected(e) {
  gamepad = navigator.getGamepads()[e.gamepad.index];
}

export function gamepadDisconnected(e) {
  if (!gamepad) return;

  if (gamepad.index !== e.gamepad.index) return;

  gamepad = null;
}
