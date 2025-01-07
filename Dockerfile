FROM python:3.10-slim-buster

USER root

# Create app directory
RUN mkdir /app

# Create astro user to avoid "no matching entries in passwd file" error
RUN useradd -ms /bin/bash astro

# Copy application files
COPY . /app/

# Set working directory
WORKDIR /app/

# Install dependencies
RUN apt update -y && \
    pip3 install -r requirements.txt

# Set environment variables (no spaces around '=')
ENV AWS_DEFAULT_REGION="us-east-1"
ENV BUCKET_NAME="networksecurity-swapnil"
ENV PREDICTION_BUCKET_NAME="networksecurity-swapnil"
ENV AIRFLOW_HOME="/app/airflow"
ENV AIRFLOW_CORE_DAGBAG_IMPORT_TIMEOUT=1000
ENV AIRFLOW_CORE_ENABLE_XCOM_PICKLING=True
ENV PYTHONPATH="/app:${PYTHONPATH}"

# Initialize Airflow DB and create user
RUN airflow db init
RUN airflow users create -e swapnilbanduke28@gmail.com -f swapnil -l banduke -p admin -r Admin -u admin

# Ensure start.sh has correct permissions
RUN chmod 777 start.sh

# Switch to astro user for running Airflow
USER astro

# Set entrypoint and command
ENTRYPOINT ["/bin/sh"]
CMD ["start.sh"]
