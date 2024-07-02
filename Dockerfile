FROM --platform=linux/amd64 python:3.8-slim-buster AS build

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

FROM --platform=linux/amd64 python:3.8-slim-buster

WORKDIR /app

RUN pip install --no-cache-dir flask joblib scikit-learn pandas numpy

COPY --from=build /app /app

EXPOSE 5000

CMD ["python", "service.py"]
