FROM python:3.10-slim

#1 install system deps: libpq-dev for postgres, gcc from any C-extension, plus cron
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	libpq-dev \
	gcc \
	cron \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /app

#2 install python requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

#3 copy my app code
COPY etl.py .
COPY utils/ ./utils/

#4 add and resgister the cron job
# - copy the crontab file into /etc/cron.d
# - give it correct permissions
# - install it into root's crontab
COPY etl-cron /etc/cron.d/etl-cron
RUN chmod 0644 /etc/cron.d/etl-cron
	&& crontab /etc/cron.d/etl-cron

#5 create a logfile so cron can write to it
RUN touch /var/log/etl.log

#6 when the container starts, launch the cron in foreground
CMD ["cron","-f"]
