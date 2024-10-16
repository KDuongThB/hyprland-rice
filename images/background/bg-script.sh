#!/usr/bin/sh
# Setup wallaper directory and monitor names.
dir="${HOME}/.config/images/background"
monitor1="eDP-1"
monitor2="DP-1"
monitor3="HDMI-A-2"

cd $dir

echo "$dir"

# Get a list of the .png files in the directory.
readarray -d '' papers < <(find "$dir" \( -name '*.png' -o -name '*.jpeg' -o -name '*.jpg' \) -print0)
cd ~/.config/hypr/

# Get the length of the list of files.
length=${#papers[@]}

first=$((1 + $RANDOM % $length - 1))

function dif_random {
  second=$((1 + $RANDOM % $length - 1))

  # Check to see if the second random index is equal
  # to the first, if so, find a new one.
  if [ $1 -eq $second ]
  then
    dif_random "$1"
  else
    return $second
  fi
}

# Make sure that there is more than one file.
# This avoids an infite loop.
if [ $length -gt 1 ] 
then
  dif_random "$first"
  second=$?
else
  second=$first
fi

# Use the random indexes to get the two filenames
paper_one=${papers[$first]}
paper_two=${papers[$second]}

# Check to see if hyprpaper is running
if pgrep -x "hyprpaper" > /dev/null
then
  # If hyprpaper is running, select two new preloaded wallpapers
  hyprctl hyprpaper wallpaper "${monitor1},${paper_one}"
  hyprctl hyprpaper wallpaper "${monitor2},${paper_two}"
else
  # Remove the old conf file.
  rm -f hyprpaper.conf

  # If it's not running, generate a new hyprpaper.conf
  for p in "${papers[@]}";
  do
      echo "preload = ${p}" >> hyprpaper.conf
  done

  echo "wallpaper = ${monitor1},${paper_one}" >>  hyprpaper.conf
  echo "wallpaper = ${monitor2},${paper_two}" >> hyprpaper.conf
  echo "wallpaper = ${monitor3},${paper_one}" >> hyprpaper.conf

  # Start hyprpaper
  hyprpaper &
  disown
fi