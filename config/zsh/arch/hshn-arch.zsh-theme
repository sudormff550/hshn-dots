PROMPT="󰣇 [%5~] %#:"
RPROMPT=" "

# Track when a command starts
function preexec() {
    timer=${timer:-$SECONDS}
}

# Calculate duration and set RPROMPT when the command finishes
function precmd() {
    if [ $timer ]; then
        local elapsed=$(( SECONDS - timer ))
        # Only show the timer if it took 1 second or longer (optional)
        if [ $elapsed -gt 0 ]; then
            RPROMPT="   ${elapsed}s%f"
        else
            RPROMPT=""
        fi
        unset timer
    else
        RPROMPT=""
    fi
}
