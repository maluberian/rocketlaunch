#/bin/bash

GIT_REPO="https://github.com/maluberian/rocketlaunch.git"
GIT_LOCAL_DIR="/tmp/rocketlaunch"

PROFILE="/home/pi/.profile"
PROFILE_TMP="/tmp/.profile.tmp"

RC_FILE="/etc/rc.local"
RC_TMP="/tmp/rc.tmp"

# clone repository
if [[ -d $GIT_LOCAL_DIR ]]
then
	rm -rf $GIT_LOCAL_DIR
fi
git clone https://github.com/maluberian/rocketlaunch.git /tmp/rocketlaunch

# copy files to the right spots
cp /tmp/rocketlaunch/rocketlaunch.py /home/pi
cp /tmp/rocketlaunch/rocketlaunch.sb /home/pi
chown pi:pi /home/pi/rocketlaunch.*

# setup the rc.local
cp $RC_FILE $RC_TMP

sed -e "/^exit.*/Q" $RC_FILE > $RC_TMP
mv $RC_TMP $RC_FILE
sed -e "s/.*amixer.*//" $RC_FILE > $RC_TMP
mv $RC_TMP $RC_FILE
sed -e "s/.*rocketlaunch.*//" $RC_FILE > $RC_TMP
mv $RC_TMP $RC_FILE

echo -e "amixer -c 0 set PCM playback 100% unmute" >> $RC_FILE
echo -e "/usr/bin/python /home/pi/rocketlaunch.py &" >> $RC_FILE
echo >> $RC_FILE
echo "exit 0" >> $RC_FILE

# setup HOME profile to run 
sed -e "s/.*rocketlaunch.*//" $PROFILE > $PROFILE_TMP
mv $PROFILE_TMP $PROFILE
echo -e "/usr/bin/scratch /home/pi/rocketlaunch.sb &" >> $PROFILE




