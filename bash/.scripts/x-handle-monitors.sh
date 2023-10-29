#! /usr/bin/bash
# set -x

usage() { 
    echo "Usage: $0 [-w <window manager>] [-h]" 1>&2; 
    exit 1; 
}

while getopts "w:h" flag;
do
    case "${flag}" in
        w) 
            win_manager=${OPTARG}
            [[ $win_manager = "bspwm" ]] || usage
            ;;
        *) 
            usage
            ;;
    esac
done

# Fixed order of monitors
MONITOR_ARR=("HDMI-A-0" "DP-1-0" "eDP")
WORKSPACES=("I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" "X")
WORKSPACE_COUNT=10

num_monitors="$(xrandr --query | grep ' connected' | wc -l)"

if [[ $num_monitors = "1" ]]; then 
    echo "Only internal monitor connected"
    if [[ $win_manager == "bspwm" ]]; then 
        bspc monitor -d "${WORKSPACES[*]}"
    fi
    exit 0;
fi

# If lid is closed, disable eDP
if [[ $(cat /proc/acpi/button/lid/LID0/state | grep closed) ]]; then
    echo "Lid down. Disabling eDP."
    lid_closed="true"
    unset "MONITOR_ARR[2]"
    ((num_monitors--))
    xrandr --output eDP --off
    echo "New monitor list: ${MONITOR_ARR[@]}"
else
    xrandr --output "eDP" --auto
fi

# Enable all connected monitors
for i in ${!MONITOR_ARR[@]}; do
    if [[ $(xrandr -q | grep "${MONITOR_ARR[$i]} connected") ]]; then
	xrandr --output "${MONITOR_ARR[$i]}" --auto
	# sleep 1
    fi
done

monitor_present=()

disp_ptr=0
for i in ${!MONITOR_ARR[@]}; do
    if [[ $(xrandr -q | grep "${MONITOR_ARR[$i]} connected") ]]; then
        echo "${MONITOR_ARR[$i]} is connected"
        # xrandr --output "${MONITOR_ARR[$i]}" --auto
	monitor_present+=("${MONITOR_ARR[$i]}")

        # Arrange monitor output
        if [[ $num_monitors == "3" ]] || [[ $lid_closed == "true" ]]; then
            if [[ ${MONITOR_ARR[$i]} = "HDMI-A-0" ]]; then 
                xrandr --output "HDMI-A-0" --left-of "DP-1-0"
            fi
            if [[ ${MONITOR_ARR[$i]} = "eDP" ]]; then 
                xrandr --output "eDP" --right-of "DP-1-0"
            fi
        elif [[ $num_monitors = "2" ]]; then
            if [[ ${MONITOR_ARR[$i]} != "eDP" ]]; then 
                xrandr --output ${MONITOR_ARR[$i]} --left-of "eDP"
            fi
        fi

        if [[ $win_manager == "bspwm" ]]; then 
            # Find workspaces for current monitor
            curr_mon_workspaces=()
            for (( j=disp_ptr ; j < WORKSPACE_COUNT ; j+=num_monitors )); do
                curr_mon_workspaces+=("${WORKSPACES[$j]}")
            done
            ((disp_ptr++))
            echo "Assigning workspace ${curr_mon_workspaces[*]} to monitor ${MONITOR_ARR[$i]}"
            bspc monitor "${MONITOR_ARR[$i]}" -d "${curr_mon_workspaces[*]}"
        fi
    fi
done

if [[ $win_manager == "bspwm" ]]; then 
    echo "Reordering display sequence: ${monitor_present[*]}"
    bspc wm --reorder-monitors "${monitor_present[*]}"
fi
