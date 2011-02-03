#!/usr/bin/python2.5
#

# import ping, socket
# try:
#     delay = ping.do_one('www.google.com', timeout=2)
# except socket.error, e:
#     print "Ping Error:", e

from threading import Thread
import subprocess
from Queue import Queue

num_threads = 4
queue = Queue()
ips = ["odm.huronhs.com", "10.13.2.1"]
#wraps system ping command
def pinger(i, q):
    """Pings subnet"""
    while True:
        ip = q.get()
        print "Thread %s: Pinging %s" % (i, ip)
        ret = subprocess.call("ping -c 1 %s" % ip,
                        shell=True,
                        stdout=open('/dev/null', 'w'),
                        stderr=subprocess.STDOUT)
        if ret == 0:
            print "%s: is alive" % ip
        else:
            print "%s: did not respond" % ip
        q.task_done()
#Spawn thread pool
for i in range(num_threads):

    worker = Thread(target=pinger, args=(i, queue))
    worker.setDaemon(True)
    worker.start()
#Place work in queue
for ip in ips:
    queue.put(ip)
#Wait until worker threads are done to exit    
queue.join()