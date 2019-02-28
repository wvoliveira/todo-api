import redis
import json
import collections
from ..conf.settings import REDIS_HOST, REDIS_PORT, REDIS_DB


class Redis():
    def __init__(self):
        self._redis = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, db=REDIS_DB)

        if not self._redis.get("index"):
            self._redis.set("index", 0)

    def item_exists(self, todo_id):
        return self._redis.get(todo_id) != None

    def get(self, todo_id):
        data = self._redis.get(todo_id)
        return json.loads(data)

    def delete(self, todo_id):
        return self._redis.delete(todo_id)

    def get_all(self):
        _list = []

        for key in self._redis.keys("*"):
            key = key.decode("utf-8")
            if key != "index":
                dict_value = json.loads(self._redis.get(key))
                ordered_list = collections.OrderedDict(sorted(dict_value.items()))
                _list.append(ordered_list)

        list_sorted = sorted(_list, key=lambda d: int(d['id']))

        return list_sorted

    def post(self, data):
        increase_id = int(self._redis.get('index').decode('utf-8')) + 1
        data['id'] = increase_id

        str_data = json.dumps(data)

        if self._redis.set(increase_id, str_data):
            self._redis.set('index', increase_id)
            return data

    def put(self, todo_id, data):
        str_data = json.dumps(data)
        self._redis.set(todo_id, str_data)
