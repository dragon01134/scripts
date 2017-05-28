#!/usr/bin/python
import re
#TODO- Added exception handling

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
	BAT0_udev_parm = get_udev_parameters('/sys/class/power_supply/BAT0')
	AC_udev_parm = get_udev_parameters('/sys/class/power_supply/AC')
	if int(AC_udev_parm['POWER_SUPPLY_ONLINE']):
		print "AC line is connected"
		return None
	else:
		print "AC line is not connected"
		if (int(BAT0_udev_parm['POWER_SUPPLY_CAPACITY']) <= 30 ) or 
		(int(BAT0_udev_parm['POWER_SUPPLY_CAPACITY']) > 20 ):
			#TODO- Send notification
		else if (int(BAT0_udev_parm['POWER_SUPPLY_CAPACITY']) <= 20):
			#TODO- Send poweroff command 



def main():
	print "main"




if __name__ == '__main__':
 	 #get_udev_parameters('/sys/class/power_supply/AC')
 	 do_need_poweroff()  