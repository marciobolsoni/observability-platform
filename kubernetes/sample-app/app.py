
from flask import Flask, Response
import prometheus_client
from prometheus_client import Counter, Histogram
import random
import time

app = Flask(__name__)

# Define Prometheus metrics
REQUEST_COUNT = Counter(
    'http_requests_total',
    'Total number of HTTP requests',
    ['method', 'endpoint', 'status_code']
)
REQUEST_LATENCY = Histogram(
    'http_request_latency_seconds',
    'HTTP request latency',
    ['method', 'endpoint']
)

@app.route('/')
def index():
    start_time = time.time()
    # Simulate a random response time
    time.sleep(random.uniform(0.1, 0.6))
    REQUEST_COUNT.labels('GET', '/', 200).inc()
    latency = time.time() - start_time
    REQUEST_LATENCY.labels('GET', '/').observe(latency)
    return 'Hello, World!'

@app.route('/error')
def error():
    start_time = time.time()
    # Simulate a random response time
    time.sleep(random.uniform(0.2, 0.8))
    REQUEST_COUNT.labels('GET', '/error', 500).inc()
    latency = time.time() - start_time
    REQUEST_LATENCY.labels('GET', '/error').observe(latency)
    return 'Internal Server Error', 500

@app.route('/metrics')
def metrics():
    return Response(prometheus_client.generate_latest(), mimetype='text/plain')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
