#!/bin/python3

import paramiko
from scp import SCPClient
from sys import argv
from os import system

HOST='name/ip'
PORT = 0
USER='user'
PASS = argv[1]
SOURCE_PATH = '/path/to/file/'
TARGET_PATH = '/path/to/destination/'
BACKFILES = argv[2:]

def scp_to_backup(host, port, user, password, source, target):
        ssh_client = paramiko.SSHClient()
        ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy)
        ssh_client.connect(host, port , user, password)
        scpclient = SCPClient(ssh_client.get_transport(),socket_timeout=15.0)

        try:
            scpclient.put(source, target)
        except FileNotFoundError as e:
            print(e)
            print ("The system cannot find the file specified" + source)
        else:
                 print ("File uploaded successfully")
        ssh_client.close()




for b in BACKFILES:
        source = f'{SOURCE_PATH}{b}'
        target = f'{TARGET_PATH}{b}'
        scp_to_backup(HOST, PORT, USER, PASS, source, target)


system('rm -f /home/postgres_bak/*.dump')
