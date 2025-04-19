#!/usr/bin/env python3
import argparse
import os

KBD_PATH_T490 = "sysfs/leds/tpacpi::kbd_backlight"
KBD_PATH_FW = "sysfs/leds/chromeos::kbd_backlight"


def main() -> None:
    """
    Check if i3lock/swaylock is running and manage the keyboard backlight accordingly.
    """
    parser = argparse.ArgumentParser(
        description="Control keyboard backlight based on swaylock status"
    )
    parser.add_argument(
        "--system",
        choices=["t490", "fw"],
        default="fw",
        help="Name of the system/device",
    )
    parser.add_argument(
        "--lock",
        choices=["i3lock", "swaylock"],
        default="swaylock",
        help="Name of the lock service program",
    )
    args = parser.parse_args()

    with os.popen("pgrep swaylock") as pipe:
        if pipe.read():
            kbd_path = KBD_PATH_FW if args.system == "fw" else KBD_PATH_T490
            with os.popen(f"light -Grs {kbd_path}") as pipe:
                current_brightness = pipe.read().strip()
                if current_brightness != "0":
                    os.system(f"light -Srs {kbd_path} 0")


if __name__ == "__main__":
    main()
