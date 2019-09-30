# Start with a Linux micro-container to keep the image tiny
FROM ubuntu
RUN apt-get update && \
    apt-get install -y \
    	    python-dev \
    	    python-pip \
	    xz-utils \
	    zlib1g \
	    libxml2-dev \
	    libxslt1-dev \
	    bzip2 \
	    wget

ADD https://github.com/nexB/scancode-toolkit/releases/download/v2.2.1/scancode-toolkit-2.2.1.tar.bz2 /
# COPY scancode-toolkit-2.2.1.tar.bz2 /
RUN tar xjf scancode-toolkit-2.2.1.tar.bz2

RUN /scancode-toolkit-2.2.1/scancode --examples

RUN adduser -u 779 --disabled-password -gecos "" cma && \
    mkdir -p /hello && \
    chown -R cma:cma /hello && \
    chown -R cma:cma /scancode-toolkit-2.2.1

WORKDIR /hello
COPY requirements.txt /hello
RUN pip install --no-cache-dir -r requirements.txt

USER cma

COPY hello.py /hello

CMD [ "tail", "-f", "/dev/null" ]
