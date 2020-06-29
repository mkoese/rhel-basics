# Listen on port 6161
nc -l 6161 

# Connect to port 6161
nc server 6161

# ss - another utility to investigate sockets 
# Show all listening tcp ports
ss -tln

# Show all established tcp ports
ss -tn

# Show listening and established tcp ports
ss -ant

# Show socket using process
ss -antp