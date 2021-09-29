from os import environ

from ariadne import (ObjectType, graphql_sync, load_schema_from_path,
                     make_executable_schema, snake_case_fallback_resolvers)
from flask import jsonify, request

from __init__ import app
from mutations import resolve_add_data
from queries import (resolve_get_average, resolve_get_average_between,
                     resolve_get_average_today, resolve_get_between,
                     resolve_get_latest, resolve_get_max,
                     resolve_get_max_between, resolve_get_max_today,
                     resolve_get_min, resolve_get_min_between,
                     resolve_get_min_today, resolve_get_today,
                     resolve_get_today_graph)

query = ObjectType("Query")
query.set_field("getMax", resolve_get_max)
query.set_field("getMin", resolve_get_min)
query.set_field("getAverage", resolve_get_average)

query.set_field("getToday", resolve_get_today)
query.set_field("getLatest", resolve_get_latest)
query.set_field("getTodayGraph", resolve_get_today_graph)

query.set_field("getBetween", resolve_get_between)

query.set_field("getAverageBetween", resolve_get_average_between)
query.set_field("getAverageToday", resolve_get_average_today)

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


@app.errorhandler(404)
def page_not_found(e):
    return jsonify({'error': 'not found'}), 404


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
