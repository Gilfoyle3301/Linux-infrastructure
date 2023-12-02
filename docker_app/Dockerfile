FROM python:3.8-slim-buster
RUN apt-get update && \
	apt-get install -y gcc make apt-transport-https ca-certificates build-essential
WORKDIR  /home/otus/
RUN pip install --upgrade pip \
	pip install bs4 \
	pip install lxml \
	pip install requests \
	pip install psycopg2-binary
COPY scrapper.py /home/otus/scrapper.py
CMD ["python3", "scrapper.py"]
