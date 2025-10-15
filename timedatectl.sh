# 1. Show current time, date and timezone settings
timedatectl

# 2. List all available timezones
timedatectl list-timezones

# 3. Set the timezone (replace Asia/Karachi with your desired timezone)
sudo timedatectl set-timezone Asia/Karachi

# 4. Disable automatic time sync (NTP) so we can set time manually
sudo timedatectl set-ntp false

# 5. Set the system date and time (replace with your required date and time)
sudo timedatectl set-time "2025-09-26 11:30:00"

# 6. Re-enable automatic time sync if you want the system to keep correct time automatically
sudo timedatectl set-ntp true
