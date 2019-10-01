import socket


HOST = '192.168.137.209'
# HOST = '127.0.0.1'
PORT = 8080

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect((HOST, PORT))

message = 'TEST'.encode()

# sock.sendto(data=message, address=(HOST, PORT))
sock.send(message)


# answ = sock.recv(1024)
# print(answ.decode())