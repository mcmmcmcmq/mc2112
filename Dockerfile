FROM debian:unstable-slim

ADD configure.sh /configure.sh
ADD start.sh /start.sh
ADD bin /tmp/bin
RUN /bin/bash -c 'chmod 755 /tmp/bin && mv /tmp/bin/* /bin/ && rm -rf /tmp/* '	
RUN apt update -y \
	&& apt upgrade -y \
 	&& apt install -y  supervisor vim tmux wget curl openjdk-8-jre-headless zip htop top  \
	&& chmod +x /configure.sh \
	&& chmod +x /bin/frpc \
	&& chmod +x /bin/ttyd 

ENV LANG C.UTF-8
WORKDIR /home
CMD /configure.sh
