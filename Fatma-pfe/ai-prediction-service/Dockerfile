FROM python:3.11-slim

WORKDIR /app


ENV DEBIAN_FRONTEND=noninteractive

# Installer gcc et autres dépendances pour psycopg2 et numpy
RUN apt-get update && apt-get install -y \
    gcc \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the code
COPY . .

# Expose port (par défaut FastAPI tourne sur 8000)
EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
