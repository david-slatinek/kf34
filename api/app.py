import os
import uuid
from enum import Enum
from os import environ

from ariadne import (ObjectType, graphql_sync, load_schema_from_path,
                     make_executable_schema, snake_case_fallback_resolvers)
from flask import after_this_request, jsonify, request, send_file

from __init__ import app
from mutations import resolve_add_data
from queries import (get_today_graph, resolve_get_average,
                     resolve_get_average_between, resolve_get_average_today,
                     resolve_get_between, resolve_get_latest, resolve_get_max,
                     resolve_get_max_between, resolve_get_max_today,
                     resolve_get_median_between, resolve_get_median_today,
                     resolve_get_min, resolve_get_min_between,
                     resolve_get_min_today,
                     resolve_get_standard_deviation_between, resolve_get_today,
                     resolve_resolve_get_standard_deviation_today)

query = ObjectType("Query")
query.set_field("getMax", resolve_get_max)
query.set_field("getMin", resolve_get_min)
query.set_field("getAverage", resolve_get_average)

query.set_field("getToday", resolve_get_today)
query.set_field("getLatest", resolve_get_latest)

query.set_field("getBetween", resolve_get_between)

query.set_field("getAverageBetween", resolve_get_average_between)
query.set_field("getAverageToday", resolve_get_average_today)

query.set_field("getMedianBetween", resolve_get_median_between)
query.set_field("getMedianToday", resolve_get_median_today)

query.set_field("getStandardDeviationBetween", resolve_get_standard_deviation_between)
query.set_field("getStandardDeviationToday", resolve_resolve_get_standard_deviation_today)

query.set_field("getMaxBetween", resolve_get_max_between)
query.set_field("getMaxToday", resolve_get_max_today)

query.set_field("getMinBetween", resolve_get_min_between)
query.set_field("getMinToday", resolve_get_min_today)

mutation = ObjectType("Mutation")
mutation.set_field("addData", resolve_add_data)

type_defs = load_schema_from_path("schema.graphql")
schema = make_executable_schema(
    type_defs, query, mutation, snake_case_fallback_resolvers
)


class DeviceType(Enum):
    TEMPERATURE = 0
    HUMIDITY = 1


@app.errorhandler(404)
def page_not_found(e):
    return jsonify({'error': 'not found'}), 404


@app.route("/image", methods=["POST"])
def image():
    if request.headers.get('X-API-Key') != app.config["KEY"]:
        return jsonify({'error': 'api key not given or invalid'}), 401
    data = request.get_json()

    if data['device_type'] not in [d.name for d in DeviceType]:
        return jsonify({'error': 'device_type is not valid'}), 400

    file_id = str(uuid.uuid4())
    payload = get_today_graph(data['device_type'], file_id)

    if payload["success"]:
        try:
            @after_this_request
            def remove_file(response):
                os.remove(file_id + '.jpg')
                return response

            return send_file(file_id + '.jpg', mimetype='image/jpeg')
        except FileNotFoundError as error:
            jsonify({'error': str(error)}), 500
    return payload, 400


@app.route("/graphql", methods=["POST"])
def graphql_server():
    if request.headers.get('X-API-Key') != app.config["KEY"]:
        return jsonify({'error': 'api key not given or invalid'}), 401

    data = request.get_json()
    success, result = graphql_sync(
        schema,
        data,
        context_value=request,
        debug=app.debug
    )
    return jsonify(result), 200 if success else 400


if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=int(environ.get('PORT', 5000)))
