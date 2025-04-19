#!/usr/bin/env python3
import os

LID = "LID0"
BAT = "BAT1"
LOW_BATTERY_THRESHOLD = 0.10


def main() -> None:
    """
    Get lid status, battery status, and charge percentage, and use those to determine if the
    battery is below the threshold and if so then suspend.
    """
    # load the system information
    with open(f"/proc/acpi/button/lid/{LID}/state", "r") as f:
        lid_status = f.readline().split(":")[-1].strip().lower()
    with open(f"/sys/class/power_supply/{BAT}/status", "r") as f:
        battery_status = f.readline().strip().lower()
    with open(f"/sys/class/power_supply/{BAT}/charge_full", "r") as f:
        energy_full = int(f.readline().strip())
    with open(f"/sys/class/power_supply/{BAT}/charge_now", "r") as f:
        energy_now = int(f.readline().strip())

    # check if the system should suspend
    charge = energy_now / energy_full
    if (lid_status == "closed" and battery_status == "discharging") or (
        charge <= LOW_BATTERY_THRESHOLD
    ):
        os.execv("/usr/bin/systemctl", ["systemctl", "suspend"])


if __name__ == "__main__":
    main()
