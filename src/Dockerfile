FROM ubuntu:20.04

RUN apt-get update && \
 apt-get install -y mysql-client && apt-get install -y nginx && apt-get install -y bash && apt-get install -y curl && \
 rm -rf /var/lib/apt/lists/*

#COPY . /user/share/nginx/html/
COPY . /var/www/html/

#CMD service nginx start


#RUN sleep 1d

ENTRYPOINT ["nginx"]

# Set the default command
CMD ["-g", "daemon off;"]

# Start Nginx and keep container running
#CMD nginx -g 'daemon off;' 
#ENTRYPOINT ["service", "nginx", "start"]
