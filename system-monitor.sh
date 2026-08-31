#!/data/data/com.termux/files/usr/bin/bash

while true; do
    clear

    echo "╔════════════════════════════════╗"
    echo "║       FLUKE // JARVIS         ║"
    echo "║       SYSTEM MONITOR           ║"
    echo "╠════════════════════════════════╣"

    # RAM
    TOTAL=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)
    AVAILABLE=$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)

    USED=$((TOTAL - AVAILABLE))

    TOTAL_GB=$(awk "BEGIN {printf \"%.2f\", $TOTAL/1024/1024}")
    USED_GB=$(awk "BEGIN {printf \"%.2f\", $USED/1024/1024}")
    AVAILABLE_GB=$(awk "BEGIN {printf \"%.2f\", $AVAILABLE/1024/1024}")

    echo "║ RAM      $USED_GB / $TOTAL_GB GB"
    echo "║ AVAILABLE       $AVAILABLE_GB GB"

    # SWAP
    SWAP_TOTAL=$(awk '/SwapTotal:/ {print $2}' /proc/meminfo)
    SWAP_FREE=$(awk '/SwapFree:/ {print $2}' /proc/meminfo)

    SWAP_USED=$((SWAP_TOTAL - SWAP_FREE))

    SWAP_GB=$(awk "BEGIN {printf \"%.2f\", $SWAP_USED/1024/1024}")
    SWAP_TOTAL_GB=$(awk "BEGIN {printf \"%.2f\", $SWAP_TOTAL/1024/1024}")

    echo "║ SWAP          $SWAP_GB / $SWAP_TOTAL_GB GB"

    echo "╠════════════════════════════════╣"

    # CPU
    echo "║ CPU CORES"

    for CPU in /sys/devices/system/cpu/cpu[0-9]*; do

        CORE=$(basename "$CPU")

        CUR=$(cat "$CPU/cpufreq/scaling_cur_freq" 2>/dev/null)
        MAX=$(cat "$CPU/cpufreq/scaling_max_freq" 2>/dev/null)

        if [ -n "$CUR" ]; then

            CUR_GHZ=$(awk "BEGIN {printf \"%.2f\", $CUR/1000000}")
            MAX_GHZ=$(awk "BEGIN {printf \"%.2f\", $MAX/1000000}")

            echo "║ $CORE   $CUR_GHZ GHz / $MAX_GHZ GHz"

        else

            echo "║ $CORE   N/A"

        fi

    done

    echo "╠════════════════════════════════╣"

    # STORAGE
    STORAGE=$(df -k /data/user/0 2>/dev/null | tail -1)

    TOTAL_STORAGE=$(echo "$STORAGE" | awk '{print $2}')
    USED_STORAGE=$(echo "$STORAGE" | awk '{print $3}')
    FREE_STORAGE=$(echo "$STORAGE" | awk '{print $4}')

    TOTAL_STORAGE_GB=$(awk "BEGIN {printf \"%.0f\", $TOTAL_STORAGE/1024/1024}")
    USED_STORAGE_GB=$(awk "BEGIN {printf \"%.0f\", $USED_STORAGE/1024/1024}")
    FREE_STORAGE_GB=$(awk "BEGIN {printf \"%.0f\", $FREE_STORAGE/1024/1024}")

    echo "║ STORAGE"
    echo "║ USED        $USED_STORAGE_GB GB"
    echo "║ FREE        $FREE_STORAGE_GB GB"
    echo "║ TOTAL       $TOTAL_STORAGE_GB GB"

    echo "╠════════════════════════════════╣"

    # UPTIME
    echo "║ UPTIME"

    uptime

    echo "╚════════════════════════════════╝"

    sleep 1
done
