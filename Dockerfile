FROM crccheck/hello-world:latest
# WORKDIR /app
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt
# COPY . .
# ENV FLASK_RUN_HOST=0.0.0.0
EXPOSE 8000
# CMD [ "flask", "run"]
