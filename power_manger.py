#!/usr/bin/python
import re
from gi.repository import Notify
from subprocess import call
import time
import os

#TODO- Add exception handling
TIMER_INTERVAL=3
CRIT_POWER_PER=90
THR_POWER_PER=99
notifyMsgBuf=''

NORMAL = 1
SEND_NOTIFICATION = 2
BELOW_CRITICAL = 3
state=0

#Global for notification
notify=None




def get_udev_parameters(udev_file_path=None):
	"""This function get udev parameter from given path """
	if udev_file_path is None:
		print "udev_file_path is None"
		return None
	parm_dict = dict()
	udev_file = open(udev_file_path+"/uevent",'r')

	for line in udev_file.readlines():
	#	print line
		matchObj = re.match(r'(.*)=(.*)',line,re.M|re.I)
		if matchObj:
			print("1:"+str(matchObj.group(1))+" 2:"+matchObj.group(2))
			parm_dict[matchObj.group(1).strip()] = matchObj.group(2).strip()

	udev_file.close()
	return parm_dict


def do_need_poweroff():
	"""This function decide if poweroff is needed or not."""
	global CRIT_POWER_PER
	global THR_POWER_PER
	global NORMAL
	global SEND_NOTIFICATION
	global BELOW_CRITICAL
	BAT0_udev_parm = get_udev_parameters('/sys/class/power_supply/BAT0')
	AC_udev_parm = get_udev_parameters('/sys/class/power_supply/AC')
	ret=0
	msg=''
	if int(AC_udev_parm['POWER_SUPPLY_ONLINE']):
		#print "AC line is connected"
		msg="AC line is connected"
		ret=NORMAL
	else:
		#print "AC line is not connected"
		if (int(BAT0_udev_parm['POWER_SUPPLY_CAPACITY']) <= THR_POWER_PER ) and (int(BAT0_udev_parm['POWER_SUPPLY_CAPACITY']) > CRIT_POWER_PER ):
			#TODO- Send notification
			msg="Battery is below Threshold level(%d%%)"%int(BAT0_udev_parm['POWER_SUPPLY_CAPACITY'])
			ret=SEND_NOTIFICATION
		elif ( int(BAT0_udev_parm['POWER_SUPPLY_CAPACITY'] ) <= CRIT_POWER_PER ):
			#TODO- Send poweroff command 
			msg="Battery is below Critical level(%d%%) Need to shutdown system"%int(BAT0_udev_parm['POWER_SUPPLY_CAPACITY'] )
			ret=BELOW_CRITICAL
	return ret,msg

def is_state_changed(st=None):
	global state
	if st:
		if state == st:
			return False
		else:
			state=st
			return True
	else:
		print "st is None"
def init_logging():
	dir_name=os.getenv('HOME')+"/log"
	print "inside logging" + dir_name
	if not os.path.isdir(dir_name):
		os.mkdir(dir_name)
		
def log_actvity(msg=None,st=None):
	print st
	if is_state_changed(st):
		print "changes"
		if msg:
			file_name=os.getenv('HOME')+"/log/poweroff.log"
			try:
				log_file=open(file_name,'a')
			except:
				print "Error:In opening log file"
				return
			msg = str(time.asctime())+"::"+msg+"\n"
			print msg
			log_file.write(msg)
			log_file.close()
		else:
			print "invalid argument"
	else:
		print "State doesn't Changes"



def send_notification(message=None,st=None):
	global notify
	if message:
		log_actvity(message,st);
		if notify:
			notify.close()
		notify = Notify.Notification.new("Warning",message)
		notify.show()
		time.sleep(1)

def do_poweroff(msg=None,st=None):
	poweroff_cmd='poweroff'
	if msg is None:
		msg="shuting down the PC without,Unknown cause"
	log_actvity(msg,st)
	print "Calling poweroff"
	#call([poweroff_cmd],shell=True)


def main():
	init_logging()
	Notify.init(__name__)
	global NORMAL
	global SEND_NOTIFICATION
	global BELOW_CRITICAL
	global TIMER_INTERVAL
	global state
	print "main"
	while True:
		ret,msg=do_need_poweroff()
		print msg
		print str(ret)
		if ret :
			if ret != NORMAL:
				if ret == SEND_NOTIFICATION:
					send_notification(msg,st=ret)
				elif ret == BELOW_CRITICAL:
					do_poweroff(msg,st=ret)
			elif ret == NORMAL:
				log_actvity(msg,st=ret)
		else:
			print "BUG:Control shouldn't come here"
		time.sleep(TIMER_INTERVAL)





if __name__ == '__main__':
 	 #get_udev_parameters('/sys/class/power_supply/AC')
# 	 do_need_poweroff()  
	main()







