sudo systemctl stop chrony
sudo systemctl stop gpsd
sleep 2
sudo systemctl start gpsd
sudo systemctl start chrony
