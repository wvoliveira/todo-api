import logging, sys, json_logging

from flask.logging import default_handler
from flask import Flask, make_response, jsonify
from flask_restful import Resource, Api, reqparse, abort

from src.repository.redis import Redis
from src.conf.settings import APP_DEBUG

#
# App, logging and args
#

app = Flask(__name__)
api = Api(app, catch_all_404s=True)

json_logging.ENABLE_JSON_LOGGING = True
json_logging.init(framework_name='flask')
json_logging.init_request_instrument(app)

logger = logging.getLogger("logger")
logger.setLevel(logging.INFO)
logger.addHandler(logging.StreamHandler(sys.stdout))

app.logger.addHandler(logger)

parser = reqparse.RequestParser()
parser.add_argument('task', type=str, required=True, help='Task description')
parser.add_argument('status', choices=('pending', 'completed'), type=str, required=True, help='Pending or completed')


class Healthcheck(Resource):
    def get(self):
        return make_response('', 200)


class Todo(Resource):
    def __init__(self):
        try:
            self.redis = Redis()
        except Exception:
            abort(500)

    def abort_if_doesnt_exist(self, todo_id):
        if not self.redis.item_exists(todo_id):
            abort(404, message="Todo {} doesn't exist".format(todo_id))

    def get(self, todo_id):
        self.abort_if_doesnt_exist(todo_id)
        return self.redis.get(todo_id), 200

    def put(self, todo_id):
        args = parser.parse_args()
        task = {'id': todo_id, 'task': args['task'], 'status': args['status']}
        self.redis.put(todo_id, task)
        return task, 201

    def delete(self, todo_id):
        self.abort_if_doesnt_exist(todo_id)
        self.redis.delete(todo_id)
        return make_response('', 204)


class TodoList(Resource):
    def __init__(self):
        try:
            self.redis = Redis()
        except Exception:
            abort(500)

    def get(self):
        return self.redis.get_all()

    def post(self):
        args = parser.parse_args()
        task = {'task': args['task'], 'status': args['status']}
        return self.redis.post(task), 201

api.add_resource(TodoList, '/todos')
api.add_resource(Todo, '/todos/<int:todo_id>')
api.add_resource(Healthcheck, '/healthcheck')

if __name__ == '__main__':
    app.run(debug=APP_DEBUG, host="0.0.0.0", port=5000)
