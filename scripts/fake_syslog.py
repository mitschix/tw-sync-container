# faking a syslog inside the docker container since the syncall guy forces me (using his own logging wrapper ) ):
# https://github.com/bergercookie/bubop/blob/master/bubop/logging.py#L94
# written with copilot - since it is just a hacky workaround
import os
import socket

SOCKET_PATH = "/tmp/devlog"

# Remove existing socket if present
if os.path.exists(SOCKET_PATH):
    os.remove(SOCKET_PATH)

# Create a Unix domain socket
sock = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)
sock.bind(SOCKET_PATH)

print("Fake syslog server listening on /dev/log...")

while True:
    try:
        data, _ = sock.recvfrom(4096)
        print("Received log:", data.decode(errors="ignore"))
    except KeyboardInterrupt:
        break
