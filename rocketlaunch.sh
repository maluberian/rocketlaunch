#/bin/bash

GIT_REPO="https://github.com/maluberian/rocketlaunch.git"
GIT_LOCAL_DIR="/tmp/rocketlaunch"

# install default requirements
sudo pip install scratchpy

# clone repository
if [[ -d $GIT_LOCAL_DIR ]]
then
	rm -rf $GIT_LOCAL_DIR
fi
git clone https://github.com/maluberian/rocketlaunch.git /tmp/rocketlaunch

# copy files to the right spots
cp /tmp/rocketlaunch/rocketlaunch.py /home/pi
cp /tmp/rocketlaunch/rocketlaunch.sb /home/pi
cp /tmp/rocketlaunch/uninstall.rocketlaunch.sh /home/pi/.uninstall.rocketlaunch.sh
chown pi:pi /home/pi/.uninstall.rocketlaunch.sh
cp /tmp/rocketlaunch/profile.launch /home/pi/.profile.launch
chown pi:pi /home/pi/.profile.launch
chown pi:pi /home/pi/rocketlaunch.*

# setup HOME profile to run 
if [[ ! -e /home/pi/.profile.save ]]
then
	cp /home/pi/.profile /home/pi/.profile.save
fi
echo -e >> /home/pi/.profile
echo -e "alias runlaunch='touch $LAUNCH_FILE; cat /home/pi/.profile.launch > /home/pi/.profile'" >> /home/pi/.profile
echo -e "alias cancellaunch='rm $LAUNCH_FILE; cat /home/pi/.profile.normal > /home/pi/.profile'" >> /home/pi/.profile
cp /home/pi/.profile /home/pi/.profile.normal
chown pi:pi /home/pi/.profile

source /home/pi/.profile

rm -rf $GIT_LOCAL_DIR
