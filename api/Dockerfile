FROM python:latest
WORKDIR /app
COPY . .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt
CMD [ "python", "./app.py" ]
