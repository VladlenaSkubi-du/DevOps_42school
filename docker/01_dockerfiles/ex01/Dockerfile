FROM		debian:latest
MAINTAINER  sschmele <sschmele@student.21-school.ru>

#Update and upgrade of the services
RUN			apt-get update -y && apt-get upgrade -y

#Necessary packages
RUN			apt-get -y install \
						wget \
						tar \
						bzip2

#Creating and entering a folder to work from there
WORKDIR		/home/teamspeak

#Installation of the service
RUN			wget https://files.teamspeak-services.com/releases/server/3.7.0/teamspeak3-server_linux_amd64-3.7.0.tar.bz2 && \
			tar -xvf teamspeak3-server_linux_amd64-3.7.0.tar.bz2
RUN			rm teamspeak3-server_linux_amd64-3.7.0.tar.bz2

#Entering the folder to work from there
WORKDIR		teamspeak3-server_linux_amd64

#Necessary parameters
ENV			TS3SERVER_LICENSE=accept
EXPOSE		9987/udp
EXPOSE		10011/tcp
EXPOSE		30033/tcp

ENTRYPOINT ["./ts3server_minimal_runscript.sh"]

#building an image:		docker build -t 01 . (the point in the end shows the directory)
#running the container:	docker run -it -p 10011:10011 -p 30033:30033 -p 9987:9987/udp 01
#						(in the interactive mode you should enter the container on the \
#						stage with the information about Server Query Admin Account:
#						there will be a phrase "I M P O R T A N T"
#exiting the container:	ctrl + 'C'
