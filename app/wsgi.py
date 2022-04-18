import json
from flask import Flask, jsonify, request
from prediction import predict
from prometheus_client import Counter
from prometheus_client import start_http_server
from werkzeug.middleware.dispatcher import DispatcherMiddleware
from prometheus_client import make_wsgi_app

application = Flask(__name__)

c = Counter('visit_count', 'Visit counter')

@application.route('/')
@application.route('/status')
def status():
    return jsonify({'status': 'ok'})


@application.route('/predictions', methods=['POST'])
def create_prediction():
    c.inc()
    data = request.data or '{}'
    body = json.loads(data)
    return jsonify(predict(body))

# Add prometheus wsgi middleware to route /metrics requests
app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {
    '/metrics': make_wsgi_app()
})
