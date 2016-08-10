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
cp /tmp/rocketlaunch/rocketlaunch.common.sh /home/pi/.rocketlaunch.common.sh
chown pi:pi /home/pi/.rocketlaunch.common.sh
chown pi:pi /home/pi/rocketlaunch.*

source /home/pi/.rocketlaunch.common.sh

# setup the rc.local
if [[ ! -e $RC_SAVE ]]
then
	cp $RC_FILE $RC_SAVE
fi
cp $RC_FILE $RC_TMP

sed -e "/^exit.*/Q" $RC_FILE > $RC_TMP
sudo mv $RC_TMP $RC_FILE
sed -e "s/.*amixer.*//" $RC_FILE > $RC_TMP
sudo mv $RC_TMP $RC_FILE
sed -e "s/.*rocketlaunch.*//" $RC_FILE > $RC_TMP
sudo mv $RC_TMP $RC_FILE

sudo echo -e "amixer cset numid=3 1" >> $RC_FILE
sudo echo -e "amixer -c 0 set PCM playback 100% unmute" >> $RC_FILE
sudo echo >> $RC_FILE
sudo echo "exit 0" >> $RC_FILE

# setup HOME profile to run 
if [[ ! -e $PROFILE_SAVE ]]
then
	cp $PROFILE $PROFILE_SAVE
fi
sed -e "s/.*rocketlaunch.*//" $PROFILE > $PROFILE_TMP
mv $PROFILE_TMP $PROFILE
echo -e "if [[ -e $LAUNCH_FILE ]]" >> $PROFILE
echo -e "then" >> $PROFILE
echo -e "\t/usr/bin/scratch /home/pi/rocketlaunch.sb && /usr/bin/python /home/pi/rocketlaunch.py" >> $PROFILE
echo -e "\trm $$LAUNCH_FILE" >> $PROFILE
echo -e "fi" >> $PROFILE
echo  >> $PROFILE
echo -e "alias runlaunch='touch $LAUNCH_FILE'" >> $PROFILE
echo -e "alias cancellaunch='rm $LAUNCH_FILE'" >> $PROFILE
chown pi:pi /home/pi/.profile

source $PROFILE

rm -rf $GIT_LOCAL_DIR
