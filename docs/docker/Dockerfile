#BASE IMAGE
FROM ubuntu:22.04

#INSTALL REQUIRED LIBRARIES
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y libunwind8 libglib2.0 libsoup2.4-1

#ADD EXPRESS CONSOLE APP TO DOCKER IMAGE
ADD / /app/

#EXPOSE PORT 80 AND RUN EXPRESS CONSOLE APP ON PORT 80
EXPOSE 80
WORKDIR /app
CMD /app/Express-Demo-Console --Port=80