#make file executeable using bin/bash and changing permissions
#! \bin\bash
# use "chmod to give user 'x' permissions"
chmod u+x rx_poc.sh

#variable declaration
city=Casablanca

#weather data
curl -s wttr.in/$city?T --output weatherOutput.log


#extract Current Temperature and save to variable
obs_temp=$(curl -s wttr.in/$city?T | grep -m 1 '°.' | grep -Eo -e '-?[[:digit:]].*')
echo "The current Temperature of $city: $obs_temp"

# To extract the forecast tempearature for noon tomorrow
fc_temp=$(curl -s wttr.in/$city?T | head -23 | tail -1 | grep '°.' | cut -d 'C' -f2 | grep -Eo -e '-?[[:digit:]].*')
echo "The forecasted temperature for noon tomorrow for $city : $fc_temp C"

#creating time stamp variables
hour=$(TZ='Morocco/Casablanca' date -u +%H) 
day=$(TZ='Morocco/Casablanca' date -u +%d) 
month=$(TZ='Morocco/Casablanca' date +%m)
year=$(TZ='Morocco/Casablanca' date +%Y)

#store and print data gathered to the given variables
record=$(echo -e "$year\t$month\t$day\t$obs_temp\t$fc_temp C")
echo $record>>rx_poc.log


# using date and date -u to get the time to be able to run the file at noon Casablanca time
date
date -u

#edit crontab file
crontab -e

#store job to run at specified time
0 8 * * * /home/project/rx_poc.sh


# use "./rx_poc.sh" to test the output