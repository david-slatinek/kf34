FROM python:latest
WORKDIR /app
COPY . .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get update && apt-get install wkhtmltopdf -y
CMD [ "gunicorn" ]
