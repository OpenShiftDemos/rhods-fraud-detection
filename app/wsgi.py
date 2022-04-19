import json
from pydoc import pager
from flask import Flask, jsonify, request
from prediction import predict
from prometheus_client import Counter
from prometheus_client import Gauge
from prometheus_client import start_http_server
from werkzeug.middleware.dispatcher import DispatcherMiddleware
from prometheus_client import make_wsgi_app
import logging
import time

application = Flask(__name__)

c = Counter('requests_count', 'Requests counter')
legit = Counter('legit_count', 'Legitimate counter')
fraud = Counter('fraud_count', 'Fraud counter')
elapsedTime = Gauge('fraud_elapsed', 'Elapsed gauge')

logging.basicConfig(level=logging.INFO)

@application.route('/')
@application.route('/status')
def status():
    return jsonify({'status': 'ok'})


@application.route('/predictions', methods=['POST'])
def create_prediction():
    t0 = time.time()
    c.inc()
    data = request.data or '{}'
    body = json.loads(data)
    p = predict(body)
    
    #
    # Metrics
    #
    if p["prediction"] == "legitimate":
            legit.inc()
    if p["prediction"] == "fraud":
            fraud.inc()

    logging.debug(f'Prediction: {p["prediction"]}')
    
    r = jsonify(p)
    elapsedTime.set(time.time() - t0)
    return r

# Add prometheus wsgi middleware to route /metrics requests
application.wsgi_app = DispatcherMiddleware(application.wsgi_app, {
    '/metrics': make_wsgi_app()
})
